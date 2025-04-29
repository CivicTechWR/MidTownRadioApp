import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

class OnDemand {
  List<Episode> episodes = [];
  final Map<String, Uint8List> _imageCache = {};

  OnDemand._();

  static Future<OnDemand> create() async {
    final onDemand = OnDemand._();
    await onDemand._fetchEpisodes();
    return onDemand;
  }

  final List<String> streams = _Streams().getStreams();

  Future _fetchEpisodes() async {
    try {
      episodes.clear();
      for (var url in streams) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {

          final feed = RssFeed.parse(response.body);
          final podcastName = feed.title ?? 'Untitled Podcast';
            final imageUrl = feed.image?.url ??
                (feed.itunes?.image?.href ??
                    'assets/images/logo_mic_black_on_white.png');
            if (!_imageCache.containsKey(podcastName) && imageUrl.startsWith('http')) {
              final imageResponse = await http.get(Uri.parse(imageUrl));
              if (imageResponse.statusCode == 200) {
                _imageCache[podcastName] = imageResponse.bodyBytes;
              }
            }

          for (var item in feed.items) {
            if (_episodeExists(item.guid ?? '')) {
              continue;
            }
            final episode = Episode(
              guid: item.guid ?? 'No GUID Provided',
              podcastName: podcastName,
              podcastImageUrl: imageUrl,
              episodeName: item.title ?? 'Untitled Episode',
              episodeDescription:
                  item.description ?? 'No description available',
              episodeStreamUrl: item.enclosure?.url ?? '',
              episodeDate: item.pubDate != null
                  ? DateFormat('MMM d, yyyy').format(
                      DateFormat("EEE, dd MMM yyyy HH:mm:ss Z")
                          .parse(item.pubDate!, true))
                  : 'No date available',
              episodeSortDate: item.pubDate != null
                  ? DateFormat('yyyy-MM-dd').format(
                      DateFormat("EEE, dd MMM yyyy HH:mm:ss Z")
                          .parse(item.pubDate!, true))
                  : 'No date available',
            );
            episodes.add(episode);
          }
        } else {
          throw Exception(
              'Failed to load RSS feed (${response.statusCode}): $url');
        }
      }

      episodes.sort(
        (a, b) => DateTime.parse(b.episodeSortDate)
            .compareTo(DateTime.parse(a.episodeSortDate)),
      );
    } catch (e) {
      // print('Error fetching RSS feed: $e');
      throw Exception('Error fetching RSS feed.');
    }
  }
  
  Uint8List? getCachedImage(String podcastName) {
    return _imageCache[podcastName];
  }

  bool _episodeExists(String guid) {
    return episodes.any((e) => e.guid == guid);
  }
}

class Podcast {
  final String title;
  final String description;
  final String imageUrl;
  final List<Episode> episodes;

  Podcast({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.episodes,
  });
}

class Episodes {
  List<Episode> episodes = [];
}

class Episode {
  final String podcastName;
  final String podcastImageUrl;
  final String episodeName;
  final String episodeDescription;
  final String episodeStreamUrl;
  final String episodeDate;
  final String episodeSortDate;
  final String guid;

  Episode(
      {required this.guid,
      required this.podcastName,
      required this.podcastImageUrl,
      required this.episodeName,
      required this.episodeDescription,
      required this.episodeStreamUrl,
      required this.episodeDate,
      required this.episodeSortDate});
}

class _Streams {
  final List<String> _streams = [
    'https://feeds.transistor.fm/midtown-radio',
    'https://feeds.transistor.fm/on-the-scene',
    'https://feeds.transistor.fm/makings-of-a-scene',
    'https://feeds.transistor.fm/midtown-conversations'
  ];
  List<String> getStreams() {
    return _streams;
  }
}
