// A model class for StreamHistory
class StreamHistoryEntry {
  final String endTime;
  final String artist;
  final String title;
  final num msPlayed;

  StreamHistoryEntry(
      {required this.endTime,
      required this.artist,
      required this.title,
      required this.msPlayed});

  factory StreamHistoryEntry.fromJson(Map<String, dynamic> json) {
    return StreamHistoryEntry(
        endTime: json['endTime'],
        artist: json['artistName'],
        title: json['trackName'],
        msPlayed: json['msPlayed']);
  }
}

class StreamHistory {
  final List<StreamHistoryEntry> items;

  StreamHistory({required this.items});

  factory StreamHistory.fromJson(Map<String, dynamic> json) {
    return StreamHistory(
        items: (json['items'] as List)
            .map((e) => StreamHistoryEntry.fromJson(e))
            .toList());
  }

  void addItems(List<StreamHistoryEntry> newItems) {
    items.addAll(newItems);
  }

  int length() {
    return items.length;
  }
}

class ExtendedStreamHistoryEntry {
  final DateTime ts;
  final int msPlayed;
  final String artist;
  final String album;
  final String title;
  final String uri;
  final String reasonStart;
  final String reasonEnd;
  final bool shuffle;
  final bool skipped;
  final bool offline;

  ExtendedStreamHistoryEntry(
      {required this.ts,
      required this.msPlayed,
      required this.artist,
      required this.album,
      required this.title,
      required this.uri,
      required this.reasonStart,
      required this.reasonEnd,
      required this.shuffle,
      required this.skipped,
      required this.offline});
}

class ExtendedStreamHistory {
  final List<ExtendedStreamHistoryEntry> items;

  ExtendedStreamHistory({required this.items});

  ExtendedStreamHistory.empty() : items = [];

  get entries {
    return items;
  }

  void addItems(List<ExtendedStreamHistoryEntry> newItems) {
    items.addAll(newItems);
  }

  int length() {
    return items.length;
  }

  Map<DateTime, int> getDateMap() {
    Map<DateTime, int> dateMap = {};
    for (var entry in items) {
      DateTime date = DateTime(entry.ts.year, entry.ts.month, entry.ts.day);
      if (dateMap.containsKey(date)) {
        dateMap[date] = dateMap[date]! + entry.msPlayed;
      } else {
        dateMap[date] = entry.msPlayed;
      }
    }
    return dateMap;
  }
}
