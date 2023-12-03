import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_list/constants/styling.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/model/profile_model.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static String routeName = '/Profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final RegExp dateOfBirthRegex =
      RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[012])/(19|20)\d\d$');

  String userId = firebaseAuth.currentUser!.uid;
  bool isShowSpinner = false;
  File? _newImage;
  bool selectingPhoto = false;

  @override
  void initState() {
    _nameController.text = profile.name;
    _emailController.text = profile.email;
    if (profile.dobUpdate) {
      _formatDateOfBirth(profile.dateOfBirth);
    }
    if (profile.phoneUpdate) {
      _phoneNumberController.text = profile.phoneNumber.toString();
    }
    super.initState();
  }

  void _formatDateOfBirth(DateTime date) {
    final DateFormat formatter =
        DateFormat('dd-MM-yyyy'); // or any format you need
    _dobController.text = formatter.format(date);
  }

  Future<void> _onSave() async {
    setState(() {
      isShowSpinner = true;
    });
    // _dobCheck();
    // _phoneCheck();
    if (_nameController.text.isNotEmpty) {
      await fireStore.collection('users').doc(userId).update({
        'name': _nameController.text,
      });
    }
    setState(() {
      isShowSpinner = false;
    });
  }

  _takeImage() async {
    setState(() {
      selectingPhoto = true;
    });
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() {
        selectingPhoto = false;
      });
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

    _newImage = File(croppedFile!.path);

    String filePath = 'users/$userId/${DateTime.now().millisecondsSinceEpoch}';
    await fireStorage.ref(filePath).putFile(_newImage!);
    final imageUrl = await fireStorage.ref(filePath).getDownloadURL();
    setState(() {
      profile.profileUrl = imageUrl;
      selectingPhoto = false;
    });
    await fireStore.collection('users').doc(userId).update({
      'profileUrl': profile.profileUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kScaffoldColor(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kScaffoldColor(context),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await GoogleSignIn().signOut();
              await firebaseAuth.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (ctx) => LoginScreen()),
                      (route) => false);
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage: const AssetImage(
                        'assets/images/pngs/Profile-Male-Transparent.png'),
                    foregroundImage: profile.profileUrl != ''
                        ? CachedNetworkImageProvider(profile.profileUrl)
                        : null,
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
                  if (selectingPhoto)
                    const Positioned(
                      right: 30,
                      left: 30,
                      bottom: 30,
                      top: 30,
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              const SizedBox(height: 80),
              TextFormField(
                decoration: kTextFieldInputDecoration(context, 'Name', ''),
                //     .copyWith(
                //   suffixIcon: const Icon(
                //     Icons.check,
                //     color: Colors.green,
                //   ),
                // ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                controller: _nameController,
                readOnly: false,
              ),
              // const SizedBox(height: 30),
              // TextFormField(
              //   decoration: kTextFieldInputDecoration(
              //           context, 'Date of Birth', 'DD/MM/YYYY')
              //       .copyWith(
              //     suffixIcon: Icon(
              //       Icons.check,
              //       color: !profile.dobUpdate
              //           ? Theme.of(context).colorScheme.surface
              //           : Colors.green,
              //     ),
              //   ),
              //   style: TextStyle(
              //     color: Theme.of(context).colorScheme.onSurface,
              //   ),
              //   keyboardType: TextInputType.number,
              //   controller: _dobController,
              //   readOnly: profile.dobUpdate,
              // ),
              // const SizedBox(height: 30),
              // TextFormField(
              //   decoration:
              //       kTextFieldInputDecoration(context, 'Number', '').copyWith(
              //     suffixIcon: Icon(
              //       Icons.check,
              //       color: !profile.phoneUpdate
              //           ? Theme.of(context).colorScheme.surface
              //           : Colors.green,
              //     ),
              //   ),
              //   style: TextStyle(
              //     color: Theme.of(context).colorScheme.onSurface,
              //   ),
              //   controller: _phoneNumberController,
              //   maxLength: 10,
              //   readOnly: profile.phoneUpdate,
              // ),
              const SizedBox(height: 30),
              TextFormField(
                decoration:
                    kTextFieldInputDecoration(context, 'Email', '').copyWith(
                  suffixIcon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                controller: _emailController,
                readOnly: true,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff334e6a),
                  fixedSize: Size(screenWidth - 40, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isShowSpinner
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Save',
                        style:
                            kNormalText(context).copyWith(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Future<void> _dobCheck() async {
//   if (!profile.dobUpdate) {
//     if (dateOfBirthRegex.hasMatch(_dobController.text)) {
//       DateFormat format = DateFormat("dd/MM/yyyy");
//       profile.dateOfBirth = format.parse(_dobController.text);
//       profile.dobUpdate = true;
//       await fireStore.collection('users').doc(userId).update({
//         'dobUpdate': true,
//         'dateOfBirth': profile.dateOfBirth,
//       });
//       setState(() {});
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Entered format was wrong!'),
//         ),
//       );
//     }
//   }
// }
//
// Future<void> _phoneCheck() async {
//   if (!profile.phoneUpdate) {
//     if (_phoneNumberController.text.length == 10) {
//       profile.phoneNumber = int.parse(_phoneNumberController.text);
//       profile.phoneUpdate = true;
//       await fireStore.collection('users').doc(userId).update({
//         'phoneUpdate': true,
//         'phoneNumber': profile.phoneNumber,
//       });
//       setState(() {});
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Phone number is short!'),
//         ),
//       );
//     }
//   }
// }
}
