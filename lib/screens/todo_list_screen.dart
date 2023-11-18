import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:to_do_list/constant_functions/get_location.dart';
import 'package:to_do_list/constant_functions/modal_bottom_sheet.dart';
import 'package:to_do_list/constants/styling.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/model/profile_model.dart';
import 'package:to_do_list/screens/profile_screen.dart';
import 'package:to_do_list/widgets/todo_list_widget.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  static String routeName = '/to_do_list_screen';

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  String userId = firebaseAuth.currentUser!.uid;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  Future<void> _fetchData() async {
    final userData = await fireStore.collection('users').doc(userId).get();

    if (userData.exists) {
      await fireStore.collection('users').doc(userId).update({
        'lastOnline': DateTime.now(),
        'latitude': _latitude,
        'longitude': _longitude,
      });
      setState(() {
        profile = ProfileModel.fromMap(userData.data()!);
      });
    }
  }

  void _getLocation() async {
    try {
      Position position = await determinePosition();
      log('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      _latitude = position.latitude;
      _longitude = position.longitude;
      _fetchData();
    } catch (e) {
      log(e.toString());
    }
  }

  void _addTask(double screenWidth) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      useSafeArea: false,
      builder: (context) {
        return const ModalBottomSheet(
          buttonName: 'Save',
          docId: 'docId',
          heading: '',
          body: '',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kScaffoldColor(context),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ToDoList',
                style: kHeadingStyle(context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week',
                    style: kSubHeading(context),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      _addTask(screenWidth);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Task',
                          style: kButtonTextStyle(context),
                        ),
                        Icon(
                          Icons.add,
                          size: 18,
                          color: kRedColor(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const ToDoListWidget(),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: const AssetImage(
                          'assets/images/pngs/Profile-Male-Transparent.png'),
                      foregroundImage: profile.profileUrl != ''
                          ? CachedNetworkImageProvider(profile.profileUrl)
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
