import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartExample extends StatefulWidget {
  const BarChartExample({super.key});

  @override
  State<BarChartExample> createState() => _BarChartExampleState();
}

class _BarChartExampleState extends State<BarChartExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BarChart(
        BarChartData(
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [BarChartRodData(toY: 8, color: Colors.red)],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [BarChartRodData(toY: 10, color: Colors.green)],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [BarChartRodData(toY: 14, color: Colors.blue)],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [BarChartRodData(toY: 25, color: Colors.amber)],
            ),
          ],
        ),

        duration: Duration(milliseconds: 1200),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }
}

// Map<String,dynamic>
// graphData
//  "y": 3
// "color": "red"
// "x":2
