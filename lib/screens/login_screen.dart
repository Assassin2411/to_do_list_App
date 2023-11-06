import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/constants/styling.dart';
import 'package:to_do_list/widgets/back_card.dart';
import 'package:to_do_list/widgets/front_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String routeName = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FlipCardState> _flipCardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kScaffoldColor(context),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/pngs/background_for_login.png',
                ),
                fit: BoxFit.fill,
                // opacity: 0.5,
              ),
            ),
          ),
          FlipCard(
            key: _flipCardKey,
            flipOnTouch: false,
            front: FrontCard(
              flipCard: () {
                _flipCardKey.currentState?.toggleCard();
              },
            ),
            back: BackCard(
              flipCard: () {
                _flipCardKey.currentState?.toggleCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
