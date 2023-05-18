// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

List<BoxShadow> shadowList = [
  const BoxShadow(color: Colors.grey, blurRadius: 30, offset: Offset(0, 10))
];

class MyDrawer extends StatefulWidget {
  final child;
  final String? title;
  final Widget? rightIcon;
  const MyDrawer({super.key, required this.child, this.title, this.rightIcon});
  @override
  // ignore: library_private_types_in_public_api
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  openDrawer() {
    setState(() {
      xOffset = 230;
      yOffset = 150;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isDrawerOpen) {
          closeDrawer();
        }
      },
      child: AnimatedContainer(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        transform: Matrix4.translationValues(xOffset, yOffset, 0)
          ..scale(scaleFactor)
          ..rotateY(isDrawerOpen ? -0.5 : 0),
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45, blurRadius: 30, offset: Offset(0, 15))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isDrawerOpen
                        ? IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 28,
                            ),
                            onPressed: () {
                              closeDrawer();
                            },
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.menu,
                              size: 32,
                            ),
                            onPressed: () {
                              openDrawer();
                            }),
                    Text(
                      widget.title ?? "",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    const SizedBox(width: 40),
                    widget.rightIcon ?? Container(),
                  ],
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
