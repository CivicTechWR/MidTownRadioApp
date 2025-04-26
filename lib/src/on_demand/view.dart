import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';
import 'package:ctwr_midtown_radio_app/src/on_demand/service.dart';

class OnDemandPage extends StatefulWidget {
  const OnDemandPage({super.key});
  static const routeName = '/on_demand';
  final String title = 'On Demand';

  @override
  State<OnDemandPage> createState() => _OnDemandPageState();
}

class _OnDemandPageState extends State<OnDemandPage> {
  final OnDemand onDemand = OnDemand();

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    double imageSize = 100;
    return FutureBuilder(
      future: onDemand.fetchPodcasts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching shows'));
        } else if (onDemand.podcasts.isEmpty) {
          return const Center(child: Text('No shows available'));
        } else {
          return ListView.builder(
            itemCount: onDemand.episodes.length,
            itemBuilder: (context, index) {
              final Episode show = onDemand.episodes[index];
              return ListTile(
                leading: Image.network(show.imageUrl, 
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
                title: Text(show.title),
                subtitle: Text(show.description),
                onTap: () => playerProvider.setStream(show.streamUrl),
              );
            },
          );
        }
      },
    );
  }
}