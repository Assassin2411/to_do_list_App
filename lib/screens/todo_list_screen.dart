import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/constants/styling.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/model/profile_model.dart';
import 'package:to_do_list/screens/profile_screen.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  static String routeName = '/to_do_list_screen';

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  String userId = firebaseAuth.currentUser!.uid;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    await fireStore.collection('users').doc(userId).update({
      'lastOnline': DateTime.now(),
    });
    final userData = await fireStore.collection('users').doc(userId).get();

    if (userData.exists) {
      setState(() {
        profile = ProfileModel.fromMap(userData.data()!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor(context),
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
                    onPressed: () {},
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
                      backgroundColor: Theme.of(context).backgroundColor,
                      backgroundImage: const AssetImage(
                          'assets/images/pngs/Profile-Male-Transparent.png'),
                      foregroundImage: profile.profileUrl != ''
                          ? CachedNetworkImageProvider(profile.profileUrl)
                          : null,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
