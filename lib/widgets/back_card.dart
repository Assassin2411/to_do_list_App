import 'package:flutter/material.dart';

import '../constants/styling.dart';

class BackCard extends StatefulWidget {
  const BackCard({super.key, required this.flipCard});

  final VoidCallback flipCard;

  @override
  State<BackCard> createState() => _BackCardState();
}

class _BackCardState extends State<BackCard> {
  final _signupFormKey = GlobalKey<FormState>();
  bool isVisiblePassword = false;
  String _enteredName = 'Anonymous';
  String _enteredEmail = '';
  String _enteredPassword = '';

  void _signup() {
    final isValid = _signupFormKey.currentState!.validate();
    if (!isValid) return;
    _signupFormKey.currentState!.save();
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
            Text(
              'SignUp',
              style: kHeadingStyle(context),
            ),
            Text(
              'Enjoy Your Day...',
              style: kNormalText(context)
                  .copyWith(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 40),
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
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.words,
                    style: kNormalText(context),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.length < 3) {
                        return 'Please enter a correct name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: kTextFieldInputDecoration(
                      context,
                      'Email',
                      'mail@website.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    style: kNormalText(context),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredEmail = value!;
                    },
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
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.none,
                    style: kNormalText(context),
                    obscureText: isVisiblePassword,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.length < 8) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredPassword = value!;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff334e6a),
                      fixedSize: Size(screenWidth - 80, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Signup',
                      style: kNormalText(context),
                    ),
                  ),
                  const SizedBox(height: 15),
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
