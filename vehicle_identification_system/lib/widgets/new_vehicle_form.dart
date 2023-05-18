// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api, sized_box_for_whitespace

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import 'custom_icon_button.dart';
import 'custom_input_field.dart';

class NewVehicleForm extends StatefulWidget {
  final bool isAdmin;
  final TextEditingController nameTextController;
  final TextEditingController mobileTextController;
  final TextEditingController licenseTextController;
  final TextEditingController modelTextController;
  final TextEditingController roleTextController;
  final String role;
  final Color color;
  final pickedImage;
  final bool profileImageCheckbox;
  final bool? isInCampus;
  final DateTime expiryDate;
  final Function setExpiryDate;
  final Function setRole;
  final Function setProfileImageCheckbox;
  final Function setPickedImage;
  final Function setColor;
  final Function? setIsInCampus;

  const NewVehicleForm({
    super.key,
    required this.isAdmin,
    required this.nameTextController,
    required this.mobileTextController,
    required this.licenseTextController,
    required this.modelTextController,
    required this.roleTextController,
    required this.role,
    required this.color,
    required this.pickedImage,
    required this.profileImageCheckbox,
    required this.expiryDate,
    required this.setExpiryDate,
    required this.setProfileImageCheckbox,
    required this.setRole,
    required this.setPickedImage,
    required this.setColor,
    this.setIsInCampus,
    this.isInCampus,
  });

  @override
  _NewVehicleFormState createState() => _NewVehicleFormState();
}

class _NewVehicleFormState extends State<NewVehicleForm> {
  final picker = ImagePicker();
  Color tempColor = Colors.red;
  TextStyle labelStyle =
      const TextStyle(fontWeight: FontWeight.w300, fontSize: 16);

  void _openDialog(String title, Widget content, context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('CANCEL'),
            ),
            TextButton(
              child: const Text('SUBMIT'),
              onPressed: () {
                widget.setColor(tempColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker(context) async {
    _openDialog(
        "Pick your Car Color",
        MaterialColorPicker(
          // allowShades: false,
          selectedColor: widget.color,
          onColorChange: (color) {
            print(color);
            setState(() {
              tempColor = color;
            });
          },
        ),
        context);
  }

  void getImage({required ImageSource imageSource}) async {
    var pickedFile =
        await picker.pickImage(source: imageSource, imageQuality: 50);
    if (pickedFile != null) {
      widget.setPickedImage(pickedFile);
    }
  }

  void selectDate(context) async {
    if (widget.isAdmin) {
      final DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: widget.expiryDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2030, 7),
        helpText: 'Select a date',
      );
      if (newDate != null) {
        widget.setExpiryDate(newDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
          controller: widget.nameTextController,
          labelText: "Name",
        ),
        const SizedBox(height: 20),

        CustomInputField(
          controller: widget.mobileTextController,
          labelText: "Mobile No.",
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),

        CustomInputField(
          controller: widget.licenseTextController,
          labelText: "License Plate No.",
        ),
        const SizedBox(height: 20),

        //role
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Role", style: labelStyle),
            DropdownButton(
              value: widget.role,
              items: allRoles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                widget.setRole(newValue);
              },
            ),
          ],
        ),
        widget.role == 'Other'
            ? CustomInputField(
                controller: widget.roleTextController,
                labelText: "Role",
              )
            : Container(),
        const SizedBox(height: 20),

        CustomInputField(
          controller: widget.modelTextController,
          labelText: "Model",
        ),
        const SizedBox(height: 20),

        // color
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Color", style: labelStyle),
            CircleColor(
              circleSize: 30.0,
              color: widget.color,
              onColorChoose: (color) {
                _openColorPicker(context);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),

        //expires
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Expires", style: labelStyle),
            Container(
              child: Row(
                children: [
                  Text(
                    DateFormat("dd, MMMM yyyy hh:mm aa")
                        .format(DateTime.parse(widget.expiryDate.toString())),
                    style: TextStyle(
                        color: widget.isAdmin ? Colors.black : Colors.grey),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: InkWell(
                      child: Icon(
                        Icons.calendar_today,
                        color: widget.isAdmin ? Colors.black : Colors.grey,
                      ),
                      onTap: () {
                        selectDate(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        //Is in campus
        widget.isAdmin
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Is inside campus ?", style: labelStyle),
                  Switch(
                    value: widget.isInCampus!,
                    activeColor: primaryBlue,
                    onChanged: (bool value) {
                      widget.setIsInCampus!(value);
                    },
                  ),
                ],
              )
            : Container(),
        widget.isAdmin ? const SizedBox(height: 20) : Container(),

        //profile
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Auto select default profile image", style: labelStyle),
            Checkbox(
              shape: const CircleBorder(),
              fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return primaryBlue;
                  } else {
                    return Colors.transparent;
                  }
                },
              ),
              value: widget.profileImageCheckbox,
              onChanged: (value) {
                widget.setProfileImageCheckbox(value ?? false);
              },
            ),
          ],
        ),
        widget.profileImageCheckbox != true && widget.pickedImage != null
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Image.file(
                        File(widget.pickedImage.path),
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.xmark,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            widget.setPickedImage(null);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
        widget.profileImageCheckbox != true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Profile Image", style: labelStyle),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.image, size: 28),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 125,
                              // color: lightBlue,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        getImage(
                                            imageSource: ImageSource.camera);
                                      },
                                      child: const CustomIconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.camera,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                        bgColor: primaryBlue,
                                        text: "Camera",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        getImage(
                                            imageSource: ImageSource.gallery);
                                      },
                                      child: const CustomIconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.images,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                        bgColor: primaryBlue,
                                        text: "Gallery",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
