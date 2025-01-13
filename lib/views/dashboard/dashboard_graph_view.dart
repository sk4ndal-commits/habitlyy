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

    int completedTasks =
        todayHabits.where((habit) => habit.isCompleted()).length;
    int totalTasks = todayHabits.length;
    double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    final data = [
      PieChartData('Done', totalInvestedHours, Colors.green),
      PieChartData(
          'Remaining', totalTargetHours - totalInvestedHours, Colors.orange),
    ];

    return Column(
      children: [
        Container(
          height: 150,
          child: SfCircularChart(
            series: <CircularSeries>[
              PieSeries<PieChartData, String>(
                dataSource: data,
                xValueMapper: (PieChartData data, _) => data.label,
                yValueMapper: (PieChartData data, _) => data.value,
                pointColorMapper: (PieChartData data, _) => data.color,
                dataLabelMapper: (PieChartData data, _) =>
                    '${data.label} \n ${data.value.toStringAsFixed(1)}h',
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  labelPosition: ChartDataLabelPosition.outside,
                  connectorLineSettings: ConnectorLineSettings(
                    type: ConnectorType.curve,
                    length: '10%',
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              SizedBox(height: 8.0),
              Text(
                '$completedTasks/$totalTasks tasks completed',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
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
