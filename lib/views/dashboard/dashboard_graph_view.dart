import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../../service_locator.dart';
import '../../services/habits/ihabits_service.dart';

class DashboardGraphView extends StatefulWidget {
  @override
  _DashboardGraphViewState createState() => _DashboardGraphViewState();
}

class _DashboardGraphViewState extends State<DashboardGraphView> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final habitsService = getIt<IHabitsService>();
    final todayHabits = habitsService.getTodayHabits();
    Future.microtask(() {
      Provider.of<HabitsProvider>(context, listen: false)
          .setTodayHabits(todayHabits);
    });
  }

  @override
  Widget build(BuildContext context) {
    final todayHabits = Provider.of<HabitsProvider>(context).todayHabits;

    double totalTargetHours =
        todayHabits.fold(0, (sum, habit) => sum + habit.targetHours);
    double totalInvestedHours =
        todayHabits.fold(0, (sum, habit) => sum + habit.investedHours);

    final data = [
      PieChartData('Invested', totalInvestedHours, Colors.green),
      PieChartData(
          'Remaining', totalTargetHours - totalInvestedHours, Colors.orange),
    ];

    return SfCircularChart(
      series: <CircularSeries>[
        PieSeries<PieChartData, String>(
          dataSource: data,
          xValueMapper: (PieChartData data, _) => data.label,
          yValueMapper: (PieChartData data, _) => data.value,
          pointColorMapper: (PieChartData data, _) => data.color,
          dataLabelMapper: (PieChartData data, _) =>
              '${data.label}: ${data.value.toStringAsFixed(1)}h',
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings: ConnectorLineSettings(
              type: ConnectorType.curve,
              length: '10%',
            ),
          ),
        ),
      ],
    );
  }
}

class PieChartData {
  final String label;
  final double value;
  final Color color;

  PieChartData(this.label, this.value, this.color);
}
