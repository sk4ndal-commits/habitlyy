import 'package:flutter/material.dart';
import 'package:habitlyy/views/dashboard/dashboard_graph_view.dart';
import 'dashboard_list_view.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 32.0),
          _buildSectionTitle(context, "Today's Progress"),
          _buildGraphCard(),
          SizedBox(height: 32.0),
          _buildSectionTitle(context, "Today's Tasks"),
          SizedBox(height: 16.0),
          // Wrap the DashboardListView in Expanded
          Expanded(
            child: DashboardListView(),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGraphCard() {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Container(
              height: 220,
              child: DashboardGraphView(),
            ),
          ],
        ),
      ),
    );
  }
}
