// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/custom_icon_button.dart';

class DownloadDialogContent extends StatelessWidget {
  final downloadCsvHandler;
  final downloadPdfHandler;
  const DownloadDialogContent(
      {super.key,
      @required this.downloadCsvHandler,
      @required this.downloadPdfHandler});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                downloadCsvHandler();
              },
              child: const CustomIconButton(
                icon: FaIcon(
                  FontAwesomeIcons.fileCsv,
                  color: Colors.white,
                  size: 26,
                ),
                bgColor: primaryBlue,
                text: "Csv",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                downloadPdfHandler();
              },
              child: const CustomIconButton(
                icon: FaIcon(
                  FontAwesomeIcons.filePdf,
                  color: Colors.white,
                  size: 26,
                ),
                bgColor: primaryBlue,
                text: "Pdf",
              ),
            )
          ],
        ),
      ),
    );
  }
}
