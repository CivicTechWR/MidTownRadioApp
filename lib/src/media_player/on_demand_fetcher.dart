import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/podcasts.dart';

class RssService {
  // Cache to store fetched shows
  static final Map<String, Show> _showCache = {};

  // Main fetch method that accepts any RSS URL
  static Future<Show> fetchShow({required String rssUrl, bool forceRefresh = false}) async {
    // Return cached version if available and not forcing refresh
    if (!forceRefresh && _showCache.containsKey(rssUrl)) {
      return _showCache[rssUrl]!;
    }

    try {
      final response = await http.get(Uri.parse(rssUrl));
      if (response.statusCode == 200) {
        final feed = RssFeed.parse(response.body);
        final show = Show.fromRssFeed(feed);
        
        // Update cache for next time
        _showCache[rssUrl] = show;
        
        return show;
      } else {
        throw Exception('Failed to load RSS feed (${response.statusCode}): $rssUrl');
      }
    } catch (e) {
      throw Exception('Error fetching RSS feed ($rssUrl): $e');
    }
  }

  // Uses above method to fetch Midtown Radio RSS specifically
  // Seems to be the main feed
  static Future<Show> fetchMidtownRadioShow({bool forceRefresh = false}) {
    return fetchShow(
      rssUrl: 'https://feeds.transistor.fm/midtown-radio',
      forceRefresh: forceRefresh,
    );
  }

  // Below are the other RSS feeds I found, but we can add/delete feeds
  ////////////////////////////////////////////////////////////////////
  static Future<Show> fetchOnTheScene({bool forceRefresh = false}) {
    return fetchShow(
      rssUrl: 'https://feeds.transistor.fm/on-the-scene',
      forceRefresh: forceRefresh,
    );
  }

  // Makings of a scene
  static Future<Show> fetchMakingsOfAScene({bool forceRefresh = false}) {
    return fetchShow(
      rssUrl: 'https://feeds.transistor.fm/makings-of-a-scene',
      forceRefresh: forceRefresh,
    );
  }

  // Midtown Conversations
  static Future<Show> fetchMidtownConversations({bool forceRefresh = false}) {
    return fetchShow(
      rssUrl: 'https://feeds.transistor.fm/midtown-conversations',
      forceRefresh: forceRefresh,
    );
  }
  ////////////////////////////////////////////////////////////////////
}