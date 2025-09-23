import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartExample extends StatelessWidget {
  const LineChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Line Chart Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(

            // show grid lines at back
            gridData: FlGridData(show: true),

            // to show titles at axis
            titlesData: FlTitlesData(show: true),

            // to draw borders around the chart
            borderData: FlBorderData(show: true),

            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 1),
                  FlSpot(1, 3),
                  FlSpot(2, 2),
                  FlSpot(3, 5),
                  FlSpot(4, 4),
                ],

                // for curve or straight line
                isCurved: true,
                // colors: [Colors.blue],

                // to change lines width
                barWidth: 4,

                // gradient line
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green,Colors.black],
                ),

                // to show dots at points
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
