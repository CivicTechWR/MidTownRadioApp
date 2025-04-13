import 'package:flutter/material.dart';
import 'package:ctwr_midtown_radio_app/src/home/view.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  static const routeName = '/error';

  static const String title = 'Error';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 100),
            SizedBox(height: 20),
            Text(
              'An error occurred',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, HomePage.routeName);
              },
              child: Text('Back to Home'))
          ],
        ),
      ),
    );
  }
}
