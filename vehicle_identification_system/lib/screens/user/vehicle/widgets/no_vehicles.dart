import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/rounded_button.dart';

class NoVehicles extends StatelessWidget {
  const NoVehicles({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "No Vehicles at the Gate",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Stack(
                children: [
                  Image.asset(
                    'assets/images/warning.png',
                  ),
                  Image.asset(
                    'assets/images/car2.png',
                  ),
                ],
              ),
              RoundedButton(
                press: () {
                  Navigator.pop(context);
                },
                color: lightBlue,
                key: key,
                child: const Text("Go Back",
                    style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
