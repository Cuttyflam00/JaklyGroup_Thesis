// ignore_for_file: library_private_types_in_public_api, prefer_if_null_operators, unnecessary_null_comparison

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../locator.dart';
import '../../../models/log.dart';
import '../../../models/vehicle.dart';
import '../../../service/admin_service.dart';
import '../../../utils/export_util.dart';
import '../../../utils/utils.dart';
import '../../../widgets/loading_screen.dart';
import '../../../widgets/my_drawer.dart';
import 'admin_vehicle_detail_screen.dart';
import 'widgets/download_dialog_content.dart';

class AdminLogsScreen extends StatefulWidget {
  const AdminLogsScreen({super.key});

  @override
  _AdminLogsScreenState createState() => _AdminLogsScreenState();
}

class _AdminLogsScreenState extends State<AdminLogsScreen> {
  var adminService = locator<AdminService>();
  List<Log> filteredData = [];
  late List<Log> allLogs;
  late String filePath;
  bool showClearFilter = false;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Log>> getData() async {
    var data = await adminService.getAllLogs();
    allLogs = data;
    return data;
  }

  void downloadPdfHandler() {
    var logs = filteredData != null ? filteredData : allLogs;

    dynamic headers = [
      'Owner Name',
      'License Plate',
      'Time',
      'Direction',
      'Mobile No.',
    ];
    final data = logs
        .map((log) => [
              log.vehicle['ownerName'],
              log.vehicle['licensePlateNo'],
              DateFormat("dd/MM/yyyy hh:mm aa")
                  .format(DateTime.parse(log.time)),
              Utils.numToString(log.direction),
              log.vehicle['ownerMobileNo'],
            ])
        .toList();

    String currDate = DateTime.now().toString();
    String filename = "Logs_$currDate";
    ExportUtil.saveAsPdf(
        data: data, headers: headers, filename: filename, pdfTitle: "All Logs");
  }

  downloadCsvHandler() async {
    var logs = filteredData != null ? filteredData : allLogs;
    List<List<dynamic>> rows = [];
    rows.add([
      "Name",
      "License Plate",
      "Time",
      "Direction",
      "Mobile No.",
      "Model",
      "Role",
      "Expires"
    ]);

    for (int i = 0; i < logs.length; i++) {
      List<dynamic> row = [];
      row.add(logs[i].vehicle["ownerName"]);
      row.add(logs[i].vehicle["licensePlateNo"]);
      row.add(DateFormat("dd/MM/yyyy hh:mm aa")
          .format(DateTime.parse(logs[i].time)));
      row.add(Utils.numToString(logs[i].direction));
      row.add(logs[i].vehicle["ownerMobileNo"]);
      row.add(logs[i].vehicle["model"]);
      row.add(logs[i].vehicle["role"]);
      row.add(DateFormat("dd/MM/yyyy hh:mm aa")
          .format(DateTime.parse(logs[i].vehicle["expires"])));

      rows.add(row);
    }

    String currDate = DateTime.now().toString();
    String filename = "Logs_$currDate";
    await ExportUtil.saveAsCsv(rows: rows, filename: filename);
  }

  void showDownloadDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => DownloadDialogContent(
        downloadCsvHandler: downloadCsvHandler,
        downloadPdfHandler: downloadPdfHandler,
      ),
    );
  }

  void filterDataOnDateRange() async {
    final DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 1)),
        end: DateTime.now().add(const Duration(days: 1)),
      ),
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2030, 7),
      helpText: 'Select a date',
    );

    if (newDateRange != null) {
      var newData = allLogs
          .where((element) => (DateTime.parse(element.time)
                      .compareTo(newDateRange.start) >=
                  0 &&
              DateTime.parse(element.time).compareTo(newDateRange.end) <= 0))
          .toList();
      setState(() {
        filteredData = newData;
        showClearFilter = true;
      });
    }
  }

  void searchHandler({required String text}) {
    text = text.toLowerCase();
    var newData = allLogs
        .where((element) =>
            element.vehicle["ownerName"].toLowerCase().contains(text) ||
            element.vehicle["licensePlateNo"].toLowerCase().contains(text) ||
            element.vehicle["ownerMobileNo"].toLowerCase().contains(text) ||
            DateFormat("dd/MM/yyyy hh:mm aa")
                .format(DateTime.parse(element.time))
                .toLowerCase()
                .contains(text))
        .toList();
    setState(() {
      filteredData = newData;
    });
  }

  void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      rightIcon: GestureDetector(
        onLongPress: () {
          showToast(context, "Download as Csv or Pdf");
        },
        onTap: showDownloadDialog,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.file_download),
        ),
      ),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: AnimatedSearchBar(
                label: "Vehicle Logs",
                searchDecoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                labelStyle: const TextStyle(color: Colors.black, fontSize: 24),
                onChanged: (text) {
                  searchHandler(text: text);
                },
              ),
            ),
            FutureBuilder(
              future: getData(),
              builder: (context, AsyncSnapshot<List<Log>> snapshot) {
                if (snapshot.hasData) {
                  return PaginatedDataTable(
                    header: Row(
                      mainAxisAlignment: showClearFilter
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        showClearFilter
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    filteredData = [];
                                    showClearFilter = false;
                                  });
                                  showToast(context, "Filter Cleared !!");
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: lightBlue,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    children: const [
                                      FaIcon(
                                        FontAwesomeIcons.xmark,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text("Clear Filter",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        InkWell(
                          onTap: filterDataOnDateRange,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: const Icon(Icons.date_range),
                          ),
                        ),
                      ],
                    ),
                    rowsPerPage:
                        snapshot.data!.length < 10 ? snapshot.data!.length : 10,
                    columns: const [
                      DataColumn(label: Text('Owner Name')),
                      DataColumn(label: Text('License Plate')),
                      DataColumn(label: Text('Time')),
                      DataColumn(label: Text('Direction')),
                    ],
                    source: _DataSource(context,
                        filteredData != null ? filteredData : snapshot.data!),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 95),
                    child: const Text("Some Error Occured !!"),
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 145),
                    child: LoadingScreen(
                        lottieAssetPath: "assets/gif/loading-animation.json"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Row {
  _Row(
    this.licensePlateNo,
    this.ownerName,
    this.time,
    this.direction,
  );

  final String licensePlateNo;
  final String ownerName;
  final String time;
  final String direction;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  final List<_Row> _rows = [];
  List<Log> data = [];

  void navigateToVehicleDetail({required Vehicle vehicle}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdminVehicleDetailScreen(vehicle: vehicle)));
  }

  _DataSource(this.context, this.data) {
    for (var log in data) {
      _rows.add(
        _Row(
          log.vehicle['licensePlateNo'],
          log.vehicle['ownerName'],
          DateFormat("dd/MM/yyyy hh:mm aa").format(DateTime.parse(log.time)),
          Utils.numToString(log.direction),
        ),
      );
    }
  }

  final int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];

    return DataRow.byIndex(
      index: index,
      // selected: row.selected,
      // onSelectChanged: (value) {
      //   if (row.selected != value) {
      //     _selectedCount += value ? 1 : -1;
      //     assert(_selectedCount >= 0);
      //     row.selected = value;
      //     notifyListeners();
      //   }
      // },
      cells: [
        DataCell(Text(row.ownerName)),
        DataCell(Text(row.licensePlateNo)),
        DataCell(Text(
          row.time,
        )),
        DataCell(Center(child: Text(row.direction))),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
