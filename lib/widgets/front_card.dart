import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:to_do_list/constant_functions/get_location.dart';
import 'package:to_do_list/constant_functions/login_function.dart';
import 'package:to_do_list/constants/styling.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/model/profile_model.dart';

class FrontCard extends StatefulWidget {
  const FrontCard({super.key, required this.flipCard});

  final VoidCallback flipCard;

  @override
  State<FrontCard> createState() => _FrontCardState();
}

class _FrontCardState extends State<FrontCard> {
  final _loginFormKey = GlobalKey<FormState>();
  String? userId = firebaseAuth.currentUser?.uid;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isNotVisiblePassword = true;
  bool isShowSpinner = false;
  String? _enteredEmail;
  String? _enteredPassword;
  double _latitude = 26.8255886;
  double _longitude = 75.7923313;
  bool isLoginProgress = false;

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  _auth(context) async {
    setState(() {
      isShowSpinner = true;
    });
    _enteredEmail = _emailController.text;
    _enteredPassword = _passwordController.text;

    login(_enteredEmail, _enteredPassword, context);
    setState(() {
      isShowSpinner = false;
    });
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

  _googleSignIn() async {
    setState(() {
      isLoginProgress = true;
    });
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      profile = ProfileModel(
        profileUrl: userCredential.user!.photoURL ?? '',
        name: userCredential.user!.displayName ?? 'Anonymous',
        email: userCredential.user?.email ?? 'mail@website.com',
        fcmToken: '',
        dobUpdate: false,
        latitude: _latitude,
        longitude: _longitude,
        dateOfBirth: DateTime.now(),
        accountCreatedDate: DateTime.now(),
        lastOnline: DateTime.now(),
        phoneUpdate: false,
        phoneNumber: userCredential.user!.phoneNumber.toString(),
      );
      setState(() {
        isLoginProgress = false;
      });
    } catch (error) {
      log('line no: 96');
      log(error.toString());
      setState(() {
        isLoginProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoginProgress,
      child: Card(
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
              Text(
                'Login',
                style: kHeadingStyle(context),
              ),
              Text(
                'Enjoy Your Day...',
                style: kNormalText(context)
                    .copyWith(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _googleSignIn,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: const Color(0xff16202a),
                  side: const BorderSide(
                    style: BorderStyle.solid,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/pngs/google.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Sign in with Google',
                      style: kNormalText(context).copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white),
              const SizedBox(height: 40),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: [
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
                              isNotVisiblePassword = !isNotVisiblePassword;
                            });
                          },
                          icon: Icon(
                            isNotVisiblePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      textCapitalization: TextCapitalization.none,
                      style: kNormalText(context).copyWith(color: Colors.white),
                      obscureText: isNotVisiblePassword,
                      readOnly: isShowSpinner,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoginProgress = true;
                        });
                        _auth(context);
                      },
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
                              'Login',
                              style: kNormalText(context),
                            ),
                    ),
                    const SizedBox(height: 60),
                    TextButton(
                      onPressed: widget.flipCard,
                      child: Text(
                        'Create new account',
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
      ),
    );
  }
}
