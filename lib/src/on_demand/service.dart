// This file contains the definition of the Episode class and the Episodes class.
// It also contains the definition of the Podcast class and the OnDemand class, which is responsible for fetching podcast data.
// The OnDemand class has a method to fetch podcasts and populate the list of podcasts with sample data.

// Contains sample data for the OnDemand page

class OnDemand {
  List<Podcast> podcasts = [];
  List<Episode> episodes = [];

  int get podcastCount => podcasts.length;

  Future fetchPodcasts() async {
    // Simulate a network call to fetch podcasts
    await Future.delayed(const Duration(seconds: 2));
    podcasts.add(Podcast(
      title: "Podcast 1",
      description: "Description of Podcast 1",
      imageUrl:
          "https://img.transistor.fm/YBPnBSbmXN_SP-ODi1aIL7qrkwQPFX5Htd4ef2WFupg/rs:fill:400:400:1/q:60/aHR0cHM6Ly9pbWct/dXBsb2FkLXByb2R1/Y3Rpb24udHJhbnNp/c3Rvci5mbS9zaG93/LzMyMjIzLzE2OTU3/NDE0NzQtYXJ0d29y/ay5qcGc.webp",
      episodes: [
        Episode(
          title: "Episode 1",
          description: "Description of Episode 1",
          streamUrl: "https://example.com/episode1.mp3",
          imageUrl: "https://img.transistor.fm/YBPnBSbmXN_SP-ODi1aIL7qrkwQPFX5Htd4ef2WFupg/rs:fill:400:400:1/q:60/aHR0cHM6Ly9pbWct/dXBsb2FkLXByb2R1/Y3Rpb24udHJhbnNp/c3Rvci5mbS9zaG93/LzMyMjIzLzE2OTU3/NDE0NzQtYXJ0d29y/ay5qcGc.webp",
          date: "2023-10-01",
        ),
        Episode(
          title: "Episode 2",
          description: "Description of Episode 2",
          streamUrl: "https://example.com/episode2.mp3",
          imageUrl: "https://img.transistor.fm/YBPnBSbmXN_SP-ODi1aIL7qrkwQPFX5Htd4ef2WFupg/rs:fill:400:400:1/q:60/aHR0cHM6Ly9pbWct/dXBsb2FkLXByb2R1/Y3Rpb24udHJhbnNp/c3Rvci5mbS9zaG93/LzMyMjIzLzE2OTU3/NDE0NzQtYXJ0d29y/ay5qcGc.webp",
          date: "2023-10-02",
        ),
      ],
    ));
    
    for (var podcast in podcasts) {
      for (var episode in podcast.episodes) {
        episodes.add(episode);
      }
    }
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
  String get latestEpisodeDate {
    return episodes.isNotEmpty ? episodes.last.date : "No episodes available";
  }
}

class Episodes {
  List<Episode> episodes = [];

  Future fetchEpisodes() async {
    episodes.add(Episode(
      title: "Episode 1",
      description: "Description of Episode 1",
      streamUrl: "https://example.com/episode1.mp3",
      imageUrl: "https://example.com/image1.jpg",
      date: "2023-10-01",
    ));
  }
}

class Episode {
  final String title;
  final String description;
  final String streamUrl;
  final String imageUrl;
  final String date;

  Episode({
    required this.title,
    required this.description,
    required this.streamUrl,
    required this.imageUrl,
    required this.date,
  });
}
