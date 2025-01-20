import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../service_locator.dart';
import '../../services/habits/ihabits_service.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';

class DashboardGraphView extends StatefulWidget {
  @override
  _DashboardGraphViewState createState() => _DashboardGraphViewState();
}

class _DashboardGraphViewState extends State<DashboardGraphView> {
  late Future<List<TimeInvestmentHabitViewModel>> _todayHabitsFuture;

  @override
  void initState() {
    super.initState();
    _loadData(); // Initialize the future
  }

  // Fetch today's habits asynchronously
  void _loadData() async {
    final habitsService = getIt<IHabitsService>();
    _todayHabitsFuture = habitsService.getTodayHabitsAsync();
    await _todayHabitsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TimeInvestmentHabitViewModel>>(
      future: _todayHabitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No habits for today'));
        } else {
          // Process the habits and build the UI
          final todayHabits = snapshot.data!;
          return _buildDashboardGraph(todayHabits);
        }
      },
    );
  }

  // Build the UI based on the habits data
  Widget _buildDashboardGraph(List<TimeInvestmentHabitViewModel> todayHabits) {
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
        _buildPieChart(data),
        SizedBox(height: 8.0),
        _buildProgressSection(progress, completedTasks, totalTasks),
      ],
    );
  }

  Widget _buildPieChart(List<PieChartData> data) {
    return Container(
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
              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              labelPosition: ChartDataLabelPosition.outside,
              connectorLineSettings: ConnectorLineSettings(
                type: ConnectorType.curve,
                length: '10%',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
      double progress, int completedTasks, int totalTasks) {
    return Padding(
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
    );
  }
}

class PieChartData {
  final String label;
  final double value;
  final Color color;

  PieChartData(this.label, this.value, this.color);
}