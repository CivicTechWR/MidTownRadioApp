import 'package:flutter/material.dart';

class Episode {
  final String title;
  final String mediaSrc; 

  Episode({
    required this.title,
    required this.mediaSrc,
  });
}

class Show {
  final String title;
  final String desc;
  final String imgUrl;
  final List<Episode> episodes;

  Show({
    required this.title,
    required this.desc,
    required this.imgUrl,
    required this.episodes,
  });
}  

class OnDemandPage extends StatefulWidget {
  const OnDemandPage({super.key});
  static const routeName = '/on_demand';
  final String title = 'On Demand';

  @override
  State<OnDemandPage> createState() => _ShowListState();
}

class _ShowListState extends State<OnDemandPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello World!"),
      ),
    );
  }
}