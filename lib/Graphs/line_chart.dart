import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartExample extends StatelessWidget {
  const LineChartExample({super.key});

  List<FlSpot> makeSpots(List<int> visits) {
    List<FlSpot> spots = [];
    for (int i = 0; i < visits.length; i++) {
      spots.add(FlSpot(i.toDouble(), visits[i].toDouble()));
    }
    return spots;
  }

  Widget monthLabel(double value, TitleMeta meta) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    int index = value.toInt();
    if (index >= 0 && index < months.length) {
      return Text(months[index]);
    }
    return const Text("");
  }

  @override
  Widget build(BuildContext context) {
    final List<int> visits = [
      20,
      45,
      30,
      60,
      90,
      70,
      100,
      85,
      65,
      40,
      55,
      75,
      40,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Patient Visits by Month")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minY: 0,
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  getTitlesWidget: monthLabel,
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: makeSpots(visits),
                isCurved: true,
                barWidth: 4,
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.green],
                ),
                dotData: FlDotData(show: true),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
