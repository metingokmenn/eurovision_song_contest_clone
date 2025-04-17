import 'dart:async';
import 'dart:math';

import '../../features/home/data/models/contestant_model.dart';
import '../../features/home/data/models/contest_model.dart';
import '../../features/home/data/models/performance_model.dart';
import '../../features/home/data/models/round_model.dart';
import '../../features/home/data/models/score_model.dart';

import 'api_service.dart';

class MockApiService implements ApiService {
  final Random _random = Random();

  @override
  Future<List<int>> getContestYears() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(400)));

    // Return a list of years in descending order (most recent first)
    return List.generate(67, (index) => 2023 - index);
  }

  @override
  Future<ContestModel> getContestByYear(int year) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 600 + _random.nextInt(300)));

    // Return mock data for a contest in a specific year
    return ContestModel(
      year: year,
      arena: 'Malmö Arena',
      city: 'Malmö',
      country: 'Sweden',
      presenters: ['Petra Mede', 'Måns Zelmerlöw'],
      broadcasters: ['SVT'],
      slogan: 'United by Music',
      contestants: [],
      rounds: [
        RoundModel(name: 'Semi-Final 1', date: '2023-05-09'),
        RoundModel(name: 'Semi-Final 2', date: '2023-05-11'),
        RoundModel(name: 'Grand Final', date: '2023-05-13'),
      ],
    );
  }

  @override
  Future<List<ContestantModel>> getContestantsByYear(int year) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 700 + _random.nextInt(300)));

    // Return a list of mock contestants for the specified year
    return [
      ContestantModel(
        id: 1,
        country: 'Sweden',
        artist: 'Loreen',
        song: 'Tattoo',
        videoUrls: ['https://www.youtube.com/watch?v=JsOrOKH3z4s'],
        composers: ['Thomas G:son', 'Jimmy Jansson', 'Loreen'],
        lyricists: ['Thomas G:son', 'Jimmy Jansson', 'Loreen'],
        broadcaster: 'SVT',
      ),
      ContestantModel(
        id: 2,
        country: 'Finland',
        artist: 'Käärijä',
        song: 'Cha Cha Cha',
        videoUrls: ['https://www.youtube.com/watch?v=znWi3zO5Kq0'],
        composers: ['Käärijä', 'Aleksi Nurmi', 'Johannes Naukkarinen'],
        lyricists: ['Käärijä'],
        broadcaster: 'YLE',
      ),
      ContestantModel(
        id: 3,
        country: 'Israel',
        artist: 'Noa Kirel',
        song: 'Unicorn',
        videoUrls: ['https://www.youtube.com/watch?v=r4wbdKmM3bQ'],
        composers: ['Doron Medalie', 'Yinon Yahel', 'May Sfadia'],
        lyricists: ['Doron Medalie'],
        broadcaster: 'KAN',
      ),
    ];
  }

  @override
  Future<List<PerformanceModel>> getVotingResultsByYear(int year) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 900 + _random.nextInt(400)));

    // Return mock voting results
    return [
      PerformanceModel(
        contestantId: 1,
        running: 9,
        place: 1,
        scores: [
          ScoreModel(
            name: 'Jury',
            points: 340,
            votes: {'Finland': 12, 'Italy': 12, 'Croatia': 12},
          ),
          ScoreModel(
            name: 'Televote',
            points: 243,
            votes: {'Finland': 8, 'Italy': 10, 'Croatia': 7},
          ),
        ],
      ),
      PerformanceModel(
        contestantId: 2,
        running: 13,
        place: 2,
        scores: [
          ScoreModel(
            name: 'Jury',
            points: 150,
            votes: {'Sweden': 8, 'Italy': 10, 'Croatia': 10},
          ),
          ScoreModel(
            name: 'Televote',
            points: 376,
            votes: {'Sweden': 12, 'Italy': 12, 'Croatia': 12},
          ),
        ],
      ),
      PerformanceModel(
        contestantId: 3,
        running: 15,
        place: 3,
        scores: [
          ScoreModel(
            name: 'Jury',
            points: 177,
            votes: {'Sweden': 10, 'Finland': 7, 'Croatia': 8},
          ),
          ScoreModel(
            name: 'Televote',
            points: 185,
            votes: {'Sweden': 7, 'Finland': 6, 'Croatia': 8},
          ),
        ],
      ),
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getFeaturedContent() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(300)));

    // Return a list of featured content (news, highlights, etc.)
    return [
      {
        'type': 'news',
        'title': 'Eurovision 2024 Host City Announced',
        'summary':
            'Malmö will host the 68th Eurovision Song Contest following Loreen\'s victory.',
        'imageUrl': 'https://example.com/images/malmo.jpg',
        'date': '2023-08-15',
      },
      {
        'type': 'video',
        'title': 'Top 10 Most Memorable Eurovision Performances',
        'summary':
            'Relive the most unforgettable moments in Eurovision history.',
        'imageUrl': 'https://example.com/images/top10.jpg',
        'videoUrl': 'https://www.youtube.com/watch?v=example',
        'duration': '10:27',
      },
      {
        'type': 'article',
        'title': 'How Voting Works in Eurovision',
        'summary': 'A comprehensive guide to the Eurovision voting system.',
        'imageUrl': 'https://example.com/images/voting.jpg',
        'date': '2023-05-01',
      },
    ];
  }

  @override
  Future<List<ContestModel>> searchContests(String query) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 600 + _random.nextInt(300)));

    // Mock search results based on the query
    // This would typically filter based on contest years, host countries, winners, etc.
    return [
      ContestModel(
        year: 2023,
        arena: 'Liverpool Arena',
        city: 'Liverpool',
        country: 'United Kingdom',
        presenters: [
          'Graham Norton',
          'Hannah Waddingham',
          'Alesha Dixon',
          'Julia Sanina'
        ],
        broadcasters: ['BBC'],
        slogan: 'United By Music',
        contestants: [],
        rounds: [
          RoundModel(name: 'Semi-Final 1', date: '2023-05-09'),
          RoundModel(name: 'Semi-Final 2', date: '2023-05-11'),
          RoundModel(name: 'Grand Final', date: '2023-05-13'),
        ],
      ),
      ContestModel(
        year: 2022,
        arena: 'Pala Olimpico',
        city: 'Turin',
        country: 'Italy',
        presenters: ['Laura Pausini', 'Alessandro Cattelan', 'Mika'],
        broadcasters: ['RAI'],
        slogan: 'The Sound of Beauty',
        contestants: [],
        rounds: [
          RoundModel(name: 'Semi-Final 1', date: '2022-05-10'),
          RoundModel(name: 'Semi-Final 2', date: '2022-05-12'),
          RoundModel(name: 'Grand Final', date: '2022-05-14'),
        ],
      ),
    ];
  }
}
