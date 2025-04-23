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
import 'package:ctwr_midtown_radio_app/src/media_player/podcasts.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/on_demand_fetcher.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/date_formatting.dart';


class OnDemandPage extends StatefulWidget {
  const OnDemandPage({super.key});
  static const routeName = '/on_demand';
  final String title = 'On Demand';

  @override
  State<OnDemandPage> createState() => _OnDemandPageState();
}

class _OnDemandPageState extends State<OnDemandPage> {
  String currentMedia = "";
  late Future<Show> _showFuture;
  bool _isLoading = true;
  Show? _show;

  // Loads shows from RSS to display
  @override
  void initState() {
    super.initState();
    _loadShow();
  }

  // Gets shows from RSS feed
  void _loadShow() {
    setState(() {
      _isLoading = true;
      _showFuture = RssService.fetchMidtownRadioShow();
      _showFuture.then((show) {
        setState(() {
          _show = show;
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        debugPrint('Error loading show: $error');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // This comes up if for some reason the shows couldn't fetch
    if (_show == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load podcast episodes'),
            TextButton(
              onPressed: _loadShow,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // If shows are all fully loaded, we display them and allow play
    // *NOTE: for now we are only fetching one "Show" which is the midtwon radio main RSS with everything
    // we probably want to separate by show or something
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: (Theme.of(context).brightness == Brightness.dark)
                    ? const Color.fromARGB(255, 49, 49, 49)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    blurRadius: 3,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      // information about the show - image, title, description
                      Row(
                        children: [
                          _show!.imgUrl.startsWith('http')
                              ? Image.network(_show!.imgUrl, width: 125)
                              : Image.asset(_show!.imgUrl, width: 125),

                          Expanded(
                            child: Center(
                              child: Text(
                                _show!.title,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                          )
                        ]
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(_show!.desc),
                      ),

                      // Display list of episodes of a show
                      ListView.builder(
                        itemCount: _show!.episodes.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final episode = _show!.episodes[index];
                          return Row(
                            children: [
                              // Play/pause button, uses setStream and provider to display properly everywhere
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (currentMedia != episode.mediaUrl) {
                                      currentMedia = episode.mediaUrl;
                                      playerProvider.setStream(
                                        url: episode.mediaUrl,
                                        title: episode.title
                                      );
                                      playerProvider.play();
                                    } else {
                                      if (playerProvider.isPlaying) {
                                        playerProvider.pause();
                                      } else {
                                        playerProvider.play();
                                      }
                                    }
                                  });
                                },
                                icon: Icon(
                                  ((currentMedia == episode.mediaUrl) &&
                                          playerProvider.isPlaying)
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),

                              // Displays title and publish date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(episode.title),
                                    if (episode.publishDate != null)
                                      Text(
                                        // Displays date formatted "Monday, January 1st, 2025"
                                        formatDate(episode.publishDate!.toLocal()),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      
                                      Divider()
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
