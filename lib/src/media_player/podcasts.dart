// Classes to store fetched on-demand data from RSS feed

import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For non ISO8601 date parsing


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

  factory Show.fromRssFeed(RssFeed feed) {
    // Extract the image URL - handling both RSS image and iTunes image
    String imageUrl = feed.image?.url ?? 
                    (feed.itunes?.image?.href ?? 'assets/images/logo_mic_black_on_white.png');
    return Show(
      title: feed.title ?? 'Untitled Podcast',
      desc: feed.description ?? 'No description available',
      imgUrl: imageUrl,

      episodes: feed.items.map((item) => Episode(
        title: item.title ?? 'Untitled Episode',
        mediaUrl: item.enclosure?.url ?? '',
        imageUrl: item.itunes?.image?.href ?? 'assets/images/logo_mic_black_on_white.png',
        description: item.description,
        publishDate: Episode._parseRssDate(item.pubDate?.toString()),
      )).toList(),
    );
  }
}

class Episode {
  final String title;
  final String mediaUrl;
  final String? imageUrl;
  final String? description;
  final DateTime? publishDate;

  Episode({
    required this.title,
    required this.mediaUrl,
    this.imageUrl,
    this.description,
    this.publishDate,
  });

  // Note these are not standard ISO8601 date strings - the RSS feed uses a different format
  // Format is as follows:
  // <pubDate>Tue, 05 Mar 2024 13:00:44 -0500</pubDate>
  // The parser assumes this format
  // The format used is the "RFC 822/1123" format
  static DateTime? _parseRssDate(String? dateString) {
    if (dateString == null) return null;
    
    try {
      // Format for: "Mon, 21 Apr 2025 16:14:10 -0400"
      final formatter = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z');
      return formatter.parse(dateString);
    } catch (e) {
      debugPrint('Failed to parse RSS date: $dateString');
      return null;
    }
  }
}
