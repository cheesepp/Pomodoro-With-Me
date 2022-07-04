import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/providers/pomo_duration.dart';

class _BarChart extends StatefulWidget {
  const _BarChart({Key? key}) : super(key: key);

  @override
  State<_BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<_BarChart> {
  // double getDataInCurrentDay() {
  //   String currentDay = DateFormat('EEEE').format(DateTime.now());
  //   double result = 0;
  //   if (currentDay == 'Monday') {
  //     result = SavingDataLocally.getSecondsLearned();
  //   } else {
  //     result = SavingDataLocally.learnedOnMonday();
  //   }
  //   if (currentDay == 'Tuesday') {
  //     result = SavingDataLocally.getSecondsLearned();
  //   } else {
  //     result = SavingDataLocally.learnedOnTuesday();
  //   }
  //   if (currentDay == 'Wednesday') {
  //     result = SavingDataLocally.getSecondsLearned();
  //   } else {
  //     result = SavingDataLocally.learnedOnWednesday();
  //   }
  //   if (currentDay == 'Thursday') {
  //     result = SavingDataLocally.getSecondsLearned();
  //   } else {
  //     result = SavingDataLocally.learnedOnThursday();
  //   }
  //   if (currentDay == 'Friday') {
  //     result = SavingDataLocally.getSecondsLearned();
  //   } else {
  //     result = SavingDataLocally.learnedOnFriday();
  //   }
  //   if (currentDay == 'Saturday') {
  //     result = SavingDataLocally.getSecondsLearned();
  //   } else {
  //     result = SavingDataLocally.learnedOnSaturday();
  //   }
  //   if (currentDay == 'Sunday') {
  //     result = SavingDataLocally.getSecondsLearned();
  //   } else {
  //     result = SavingDataLocally.learnedOnSunday();
  //   }
  //   return result;
  // }

  @override
  void initState() {
    super.initState();
    SavingDataLocally.getSecondsLearned(
        DateFormat('EEEE').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 30) {
      text = '30';
    } else if (value == 60) {
      text = '60';
    } else if (value == 120) {
      text = '120';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: leftTitles,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: SavingDataLocally.learnedOnMonday(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: SavingDataLocally.learnedOnTuesday(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: SavingDataLocally.learnedOnWednesday(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: SavingDataLocally.learnedOnThursday(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: SavingDataLocally.learnedOnFriday(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: SavingDataLocally.learnedOnSaturday(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: SavingDataLocally.learnedOnSunday(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}

class BarChartSample3 extends StatefulWidget {
  const BarChartSample3({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color(0xfff6f7dd),
        child: const _BarChart(),
      ),
    );
  }
}
