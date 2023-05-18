import '../../../../locator.dart';
import '../../../../service/admin_service.dart';
import 'chart_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  final adminService = locator<AdminService>();

  LineChart({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: adminService.dailyScansStream(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        if (snapshot.hasData && snapshot.data.docs.length > 0) {
          List<_ScansData> graphData = [];
          snapshot.data.docs.forEach((document) {
            graphData.add(
              _ScansData(
                DateTime.parse(document.data()['timestamp']),
                document.data()['count'],
              ),
            );
          });

          return ChartContainer(
            child: SfCartesianChart(
              primaryXAxis:
                  CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
              primaryYAxis:
                  NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
              title: ChartTitle(
                text: 'Daily Scans',
                textStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // legend: Legend(isVisible: true),

              tooltipBehavior: TooltipBehavior(enable: true),
              series: <LineSeries<_ScansData, String>>[
                LineSeries<_ScansData, String>(
                  name: 'Daily Scans',
                  dataSource: graphData,
                  xValueMapper: (_ScansData data, _) =>
                      DateFormat("dd/MM/yy").format(data.date),
                  yValueMapper: (_ScansData data, _) => data.count,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _ScansData {
  _ScansData(this.date, this.count);
  final DateTime date;
  final int count;
}
