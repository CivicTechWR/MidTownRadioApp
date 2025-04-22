// Fetches shows/episodes from RSS feed and returns using classes in podcasts.dart

import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/podcasts.dart';

class RssService {
  // I don't know if this is the exact URL they want...? its easy to swap out
  static const String rssUrl = 'https://feeds.transistor.fm/midtown-radio';

  // Gets info from RSS feed - this should probably be cached, with a pulldown to refresh functionality
  static Future<Show> fetchShow() async {
    try {
      final response = await http.get(Uri.parse(rssUrl));
      if (response.statusCode == 200) {
        final feed = RssFeed.parse(response.body);
        return Show.fromRssFeed(feed);
      } else {
        throw Exception('Failed to load RSS feed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching RSS feed: $e');
    }
  }
}
