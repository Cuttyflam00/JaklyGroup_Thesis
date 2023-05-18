// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/colors.dart';
import '../../user/main_screen.dart';

List<Map> adminDrawerItems = [
  {'icon': Icons.dashboard, 'title': 'Dashboard', 'index': 0},
  {'icon': FontAwesomeIcons.list, 'title': 'Logs', 'index': 1},
  {'icon': FontAwesomeIcons.car, 'title': 'Vehicles', 'index': 2},
  {'icon': FontAwesomeIcons.plus, 'title': 'Add Vehicle', 'index': 3},
];

class AdminDrawerScreen extends StatefulWidget {
  final Function currentScreenHandler;
  final int currentScreen;
  const AdminDrawerScreen(
      {super.key,
      required this.currentScreenHandler,
      required this.currentScreen});

  @override
  _AdminDrawerScreenState createState() => _AdminDrawerScreenState();
}

class _AdminDrawerScreenState extends State<AdminDrawerScreen> {
  void logoutHandler() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBlue,
      padding: const EdgeInsets.only(top: 50, bottom: 70, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              SizedBox(
                width: 10,
              ),
              FaIcon(
                FontAwesomeIcons.car,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Campus Car Admin',
                style: TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: 'CarterOne'),
              ),
            ],
          ),
          Column(children: [
            ...adminDrawerItems.map((element) => GestureDetector(
                  onTap: () {
                    widget.currentScreenHandler(element['index']);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: widget.currentScreen == element['index']
                            ? Colors.grey[100]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30)),
                    padding:
                        const EdgeInsets.only(top: 18, bottom: 18, left: 14),
                    child: Row(
                      children: [
                        Icon(
                          element['icon'],
                          color: widget.currentScreen == element['index']
                              ? Colors.black
                              : Colors.white,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(element['title'],
                            style: TextStyle(
                                color: widget.currentScreen == element['index']
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                )),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false);
              },
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.only(top: 18, bottom: 18, left: 14),
                child: Row(
                  children: const [
                    Icon(
                      FontAwesomeIcons.circleArrowLeft,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Go Back",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            )
          ]),
          GestureDetector(
            onTap: logoutHandler,
            child: Row(
              children: const [
                SizedBox(
                  width: 14,
                ),
                Icon(FontAwesomeIcons.rightFromBracket,
                    color: Colors.white, size: 20),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Log out',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
