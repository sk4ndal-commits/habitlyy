import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../providers/habit_provider.dart';
import '../../viewmodels/habits/habit_viewmodel.dart';

class DashboardGraphView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access `HabitsProvider`
    final habitsProvider = Provider.of<HabitsProvider>(context);
    final todayHabits = habitsProvider.todayHabits;

    return todayHabits.isEmpty
        ? Center(child: Text('No habits for today'))
        : _buildDashboardGraph(todayHabits);
  }

  // Process the habits and build the graphical UI
  Widget _buildDashboardGraph(List<TimeInvestmentHabitViewModel> todayHabits) {
    // Recalculate metrics to ensure they reflect the current state
    double totalTargetHours =
        todayHabits.fold(0, (sum, habit) => sum + habit.targetHours);
    double totalInvestedHours =
        todayHabits.fold(0, (sum, habit) => sum + habit.investedHours);

    int completedTasks =
        todayHabits.where((habit) => habit.isCompleted()).length;
    int totalTasks = todayHabits.length;
    double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    // Prepare data for the pie chart
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

  // Render a pie chart using Syncfusion
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
                '${data.label}\n${data.value.toStringAsFixed(2)}h',
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

  // Render the linear progress section
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
