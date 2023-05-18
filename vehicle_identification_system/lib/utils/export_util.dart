import 'dart:io';
// import 'dart:js';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportUtil {
  void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  static Future<File> createLocalFile(
      {String? filename, String? fileExtension}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final path = await _localPath;
    print(path);
    return File('$path/$filename.$fileExtension').create();
  }

  static saveAsCsv({List<List<dynamic>>? rows, String? filename}) async {
    File f = await createLocalFile(filename: filename, fileExtension: "csv");
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    // Fluttertoast.showToast(msg: "Downloaded Successfully.");
  }

  static saveAsPdf({
    String? filename,
    List<List<dynamic>>? headers,
    List<List<dynamic>>? data,
    String? pdfTitle,
  }) async {
    File file = await createLocalFile(filename: filename, fileExtension: "pdf");

    final pdf = pw.Document();
    // write on pdf
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(level: 0, child: pw.Text(pdfTitle!)),
            pw.Table.fromTextArray(headers: headers!, data: data!)
          ];
        },
      ),
    );

    // save pdf
    file.writeAsBytesSync(await pdf.save());
    // showToast(context, "Downloaded Successfully.");

    // Fluttertoast.showToast(msg: "Downloaded Successfully.");
  }
}
