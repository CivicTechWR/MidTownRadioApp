/*
Displays on demand shows/podcasts fetched from the RSS feed
for now, I am only fetching from the midtown-radio RSS feed 
I see there are others for specific podcasts, and we should discuss which feed(s) to pull
This works but all episodes of everything are just in one big long list, and we probably 
want to make it easier for people to find follow ups to shows
*/

// TODO:
// For some reason here the theme does not fully switch on the container until I hot reload the page
// Also picture asset is white background even in dark mode

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
                leading: Image.network(
                  show.imageUrl,
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

class OnDemandListTile extends StatelessWidget {
  OnDemandListTile({
    super.key,
    required this.podcastName,
    required this.podcastImageUrl,
    required this.podcastEpisodeName,
    required this.podcastEpisodeDate,
    required this.podcastEpisodeStreamUrl,
  });

  final String podcastName;
  final String podcastImageUrl;
  final String podcastEpisodeName;
  final String podcastEpisodeDate;
  final String podcastEpisodeStreamUrl;

  final playerProvider = Provider.of<PlayerProvider>(context);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(podcastImageUrl),
      title: Text(podcastName),
      subtitle: Text(podcastEpisodeName),
      // trailing: ,
      onTap: () => playerProvider.setStream(podcastEpisodeStreamUrl),
    );
  }
}
