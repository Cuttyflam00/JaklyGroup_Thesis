// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../../../../components/progress_widget.dart';
import '../../../../constants/colors.dart';

class VehicleInfoError extends StatelessWidget {
  final String? errorMsg;
  final bool isLoading;
  final Function? findVehicleHandler;
  final String? timestamp;
  VehicleInfoError({
    super.key,
    this.errorMsg,
    this.findVehicleHandler,
    this.isLoading = false,
    this.timestamp,
  });

  final TextEditingController textEditingController = TextEditingController();

  void searchBtnHandler(context) {
    print(textEditingController.text);
    if (textEditingController.text != "" &&
        textEditingController.text != null) {
      findVehicleHandler!(
        licensePlate: textEditingController.text,
        timestamp: timestamp,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Input field cannot be empty !!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              errorMsg!,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Material(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: TextField(
                    controller: textEditingController,
                    cursorColor: primaryBlue,
                    decoration: const InputDecoration(
                      hintText: "Enter License Plate No. ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                            width: 1,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(
                          width: 1,
                          color: primaryBlue,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: TextButton(
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                      backgroundColor: MaterialStatePropertyAll(primaryBlue),
                    ),
                    onPressed: () {
                      if (!isLoading) {
                        searchBtnHandler(context);
                      }
                    },
                    child: isLoading
                        ? circularprogress()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Search",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.search,
                                color: Colors.white,
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
