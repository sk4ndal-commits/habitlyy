import 'package:flutter/material.dart';
import 'package:habitlyy/services/habits/ihabits_service.dart';
import 'dashboard_list_view.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          // First row: Graph
          Container(
            height: 200,
            color: Colors.blue, // Placeholder for the graph
            child: Center(child: Text('Graph Placeholder')),
          ),
          // Heading: Today's Tasks
          SizedBox(height: 16.0),
          Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Today's Tasks",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(height: 300, child: DashboardListView())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
