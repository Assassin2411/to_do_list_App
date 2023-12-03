import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_list/constant_functions/get_location.dart';
import 'package:to_do_list/constant_functions/signup_function.dart';
import 'package:to_do_list/constants/styling.dart';
import 'package:to_do_list/main.dart';

class BackCard extends StatefulWidget {
  const BackCard({super.key, required this.flipCard});

  final VoidCallback flipCard;

  @override
  State<BackCard> createState() => _BackCardState();
}

class _BackCardState extends State<BackCard> {
  final _signupFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisiblePassword = true;
  bool isShowSpinner = false;
  String _enteredName = 'Anonymous';
  String _enteredEmail = '';
  String _enteredPassword = '';
  File? _newImage;
  String _fcmToken = '';
  double _latitude = 26.8255886;
  double _longitude = 75.7923313;

  Future<void> _getDeviceToken() async {
    final fCMToken = await firebaseMessaging.getToken();
    _fcmToken = fCMToken!;
  }

  void _getLocation() async {
    try {
      Position position = await determinePosition();
      log('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _auth() async {
    setState(() {
      isShowSpinner = true;
    });
    _enteredName = _nameController.text;
    _enteredEmail = _emailController.text;
    _enteredPassword = _passwordController.text;

    _getDeviceToken();
    _getLocation();

    signup(_enteredName, _enteredEmail, _enteredPassword, _newImage, _fcmToken,
        _latitude, _longitude, context);
    setState(() {
      isShowSpinner = false;
    });
  }

  _takeImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      minHeight: 1080,
      minWidth: 1080,
      quality: 35,
    );

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: result!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop your image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop your image',
        ),
      ],
    );

    File croppedImage = File(croppedFile!.path);
    setState(() {
      _newImage = croppedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
      color: const Color.fromARGB(235, 22, 32, 42),
      shadowColor: const Color(0xff6e453a),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: screenWidth - 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SignUp',
                      style: kHeadingStyle(context),
                    ),
                    Text(
                      'Enjoy Your Day...',
                      style: kNormalText(context)
                          .copyWith(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xff334e6a),
                      backgroundImage: const AssetImage(
                          'assets/images/pngs/Profile-Male-Transparent.png'),
                      foregroundImage:
                          _newImage != null ? FileImage(_newImage!) : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      height: 30,
                      width: 30,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: const Color(0xffefefef),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: IconButton(
                            onPressed: _takeImage,
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 60),
            Form(
              key: _signupFormKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: kTextFieldInputDecoration(
                      context,
                      'Full Name',
                      'Anonymous',
                    ),
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.words,
                    style: kNormalText(context).copyWith(color: Colors.white),
                    readOnly: isShowSpinner,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: kTextFieldInputDecoration(
                      context,
                      'Email',
                      'mail@website.com',
                    ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    style: kNormalText(context).copyWith(color: Colors.white),
                    readOnly: isShowSpinner,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: kTextFieldInputDecoration(
                      context,
                      'Password',
                      'Min. 8 character',
                    ).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisiblePassword = !isVisiblePassword;
                          });
                        },
                        icon: Icon(isVisiblePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.none,
                    style: kNormalText(context).copyWith(color: Colors.white),
                    obscureText: isVisiblePassword,
                    readOnly: isShowSpinner,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _auth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff334e6a),
                      fixedSize: Size(screenWidth - 80, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isShowSpinner
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Signup',
                            style: kNormalText(context),
                          ),
                  ),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: widget.flipCard,
                    child: Text(
                      'Already have an account',
                      style: kNormalText(context).copyWith(
                        color: kRedColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
