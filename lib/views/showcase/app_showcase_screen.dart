import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import package

class AppShowcaseScreen extends StatelessWidget {
  final PageController _pageController =
      PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('What the app offers')),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _buildShowcasePage(
                  context,
                  title: 'Feature 1',
                  description: 'Description of feature 1.',
                  image: Icons.star,
                ),
                _buildShowcasePage(
                  context,
                  title: 'Feature 2',
                  description: 'Description of feature 2.',
                  image:
                      Icons.settings,
                ),
                _buildShowcasePage(
                  context,
                  title: 'Feature 3',
                  description: 'Description of feature 3.',
                  image: Icons.check,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          SmoothPageIndicator(
            controller: _pageController,
            count: 3, // Number of pages
            effect: WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: Colors.blue,
              dotColor: Colors.grey,
            ), // Customizable effect
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildShowcasePage(BuildContext context,
      {required String title,
      required String description,
      required IconData image}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(image, size: 100, color: Colors.blue),
          SizedBox(height: 16.0),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
