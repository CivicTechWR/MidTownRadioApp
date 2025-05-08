import 'package:flutter/material.dart';

class OnDemandListeningPage extends StatefulWidget {
  const OnDemandListeningPage({super.key});

  @override
  State<OnDemandListeningPage> createState() => _OnDemandListeningPageState();
}

class _OnDemandListeningPageState extends State<OnDemandListeningPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "On Demand Listening",
        style: TextStyle(
          fontSize: 32,
        ),
      )
    );
  }
}