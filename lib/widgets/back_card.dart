import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final String userId = firebaseAuth.currentUser!.uid;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisiblePassword = true;
  String _enteredName = 'Anonymous';
  String _enteredEmail = '';
  String _enteredPassword = '';

  Future<void> _auth() async {
    _enteredName = _nameController.text;
    _enteredEmail = _emailController.text;
    _enteredPassword = _passwordController.text;
    signup(_enteredName, _enteredEmail, _enteredPassword, context);

    try {
      UserCredential userCredentials =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );

      await fireStore.collection('users').doc(userId).set({
        'name': _enteredName,
        'email': _enteredEmail,
      });
    } on FirebaseAuthException catch (error) {
      showError(context, error);
    }
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
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.words,
                    style: kNormalText(context).copyWith(color: Colors.white),
                    onTapOutside: (value) {
                      _enteredName = _nameController.text;
                    },
                    onFieldSubmitted: (value) {
                      _enteredName = _nameController.text;
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    style: kNormalText(context).copyWith(color: Colors.white),
                    onTapOutside: (value) {
                      _enteredEmail = _emailController.text;
                    },
                    onFieldSubmitted: (value) {
                      _enteredEmail = _emailController.text;
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
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.none,
                    style: kNormalText(context).copyWith(color: Colors.white),
                    obscureText: isVisiblePassword,
                    onTapOutside: (value) {
                      _enteredPassword = _passwordController.text;
                    },
                    onFieldSubmitted: (value) {
                      _enteredPassword = _passwordController.text;
                    },
                    onSaved: (value) {
                      _enteredPassword = value!;
                    },
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
