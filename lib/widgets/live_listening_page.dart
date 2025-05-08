import 'package:flutter/material.dart';

class LiveListeningPage extends StatefulWidget {
  const LiveListeningPage({super.key});

  @override
  State<LiveListeningPage> createState() => _LiveListeningPageState();
}

class _LiveListeningPageState extends State<LiveListeningPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Live Listening",
        style: TextStyle(
          fontSize: 32,
        ),
      )
    );
  }
}