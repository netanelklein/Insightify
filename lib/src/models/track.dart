import '../utils/functions.dart';

class Track {
  final String title;
  final String artistName;
  final String albumName;
  int msPlayed;
  int timesPlayed;
  int skipped;
  String trackId;

  Track({
    required this.title,
    required this.artistName,
    required this.albumName,
    required this.msPlayed,
    required this.timesPlayed,
    required this.skipped,
    required this.trackId,
  });

  int get timePlayed {
    return msPlayed;
  }

  int get times {
    return timesPlayed;
  }

  int get skips {
    return skipped;
  }

  get id {
    return trackId;
  }

  get album {
    return albumName;
  }

  get artist {
    return artistName;
  }

  @override
  String toString() {
    List<int> time = msToTime(msPlayed);
    return '${time[0]} days, ${time[1]} hours, ${time[2]} minutes and ${time[3]} seconds.\nPlayed $times times and skipped $skips times.';
  }
}
