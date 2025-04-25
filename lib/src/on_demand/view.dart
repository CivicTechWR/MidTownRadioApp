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
  List<Future<Show?>> _showFuture = [];
  bool _isLoading = true;
  List<Show>? _shows;
  Map<String, bool> _showAllEpisodesMap = {};


  // Loads shows from RSS to display
  @override
  void initState() {
    super.initState();
    _loadShows();
  }

  // Gets shows from RSS feed
  Future<void> _loadShows() async {
    setState(() {
      _isLoading = true;
      _shows = null;
      _showAllEpisodesMap = {}; 
    });

    // Create a list of futures, attempting to fetch each show
    _showFuture.add(RssService.fetchMakingsOfAScene());
    _showFuture.add(RssService.fetchMidtownConversations());
    _showFuture.add(RssService.fetchOnTheScene());
    _showFuture.add(RssService.fetchMidtownRadioShow());

    try {
      // Waits for all shows to fetch
      final List<Show?> results = await Future.wait(_showFuture);

      // Filter out the nulls (failed fetches) and keep the successful Show objects
      final List<Show> successfulShows = results.whereType<Show>().toList();

      if (!mounted) return;

      // Update shows with newly loaded shows
      setState(() {
        _shows = successfulShows;
        // Initialize the expansion map  to false for the successfully loaded shows
        for (var show in _shows!) {
          _showAllEpisodesMap[show.title] = false;
        }

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _shows = [];
      });
      debugPrint('Unexpected error in loading shows: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_shows == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load podcast episodes'),
            TextButton(
              onPressed: _loadShows,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _shows!.length,
      itemBuilder: (context, index) {
        // Extracted logic/UI into its own method for each show
        return _showBuilder(context, _shows![index], playerProvider);
      },
    );
  }

  Padding _showBuilder(BuildContext context, Show show, PlayerProvider playerProvider) {

    // Manage expansion state - show 5 shows and let user expand
    final episodesToShow = (_showAllEpisodesMap[show.title] ?? false)
        ? show.episodes 
        : show.episodes.take(3).toList();


    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 300,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right:5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xfff05959),width: 7),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xfff05959)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: show.imgUrl.startsWith('http')
                                ? Image.network(show.imgUrl, width: 125)
                                : Image.asset(show.imgUrl, width: 125),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            show.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Color(0xff33cccc), fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Text(show.desc, style: TextStyle(color: Color(0xff33cccc),fontWeight: FontWeight.bold),),
                  ),
                  
                  // Episode list with fade effect
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [Colors.transparent,(Theme.of(context).brightness == Brightness.dark) ? Colors.white:Colors.black],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center).createShader(bounds);
                    },
                    child: ListView.builder(
                      itemCount: episodesToShow.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final episode = episodesToShow[index];
                        return Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (currentMedia != episode.mediaUrl) {
                                    currentMedia = episode.mediaUrl;
                                    playerProvider.setStream(
                                      url: episode.mediaUrl,
                                      title: episode.title,
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(episode.title),
                                  if (episode.publishDate != null)
                                    Text(
                                      formatDate(episode.publishDate!.toLocal()),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Show More/Less button
                  if (show.episodes.length > 5)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllEpisodesMap[show.title] = !_showAllEpisodesMap[show.title]!;
                        });
                      },
                      child: Text(
                        (_showAllEpisodesMap[show.title] ?? false) ? 'Show Less' : 'Show More',
                        style: TextStyle(color: Color(0xfff05959)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
