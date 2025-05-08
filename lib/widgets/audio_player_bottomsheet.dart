import 'package:flutter/material.dart';

class AudioBottomSheet extends StatefulWidget {
  const AudioBottomSheet({super.key});

  @override
  State<AudioBottomSheet> createState() => _AudioBottomSheetState();
}

class _AudioBottomSheetState extends State<AudioBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF49c2c5),
          borderRadius: BorderRadius.circular(32)
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.play_arrow),
              Center(child: const Text("Audio Player Here")),
            ],
          ),
        )
      ),
    );
  }
}