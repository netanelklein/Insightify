import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';

List<int> msToTime(int ms) {
  int seconds = (ms / 1000).round();
  int minutes = (seconds / 60).floor();
  seconds = seconds % 60;
  int hours = (minutes / 60).floor();
  minutes = minutes % 60;
  int days = (hours / 24).floor();
  hours = hours % 24;
  return [days, hours, minutes, seconds];
}

String msToTimeString(int ms) {
  List<int> time = msToTime(ms);
  if (time[0] > 0) {
    return '${time[0]} days, ${time[1]} hours, ${time[2]} minutes and ${time[3]} seconds';
  } else if (time[1] > 0) {
    return '${time[1]} hours, ${time[2]} minutes and ${time[3]} seconds';
  } else if (time[2] > 0) {
    return '${time[2]} minutes and ${time[3]} seconds';
  } else {
    return '${time[3]} seconds';
  }
}

String msToTimeStringShort(int ms) {
  List<int> time = msToTime(ms);
  if (time[0] > 0) {
    return '${time[0]} days and ${time[1]}:${time[2].toString().padLeft(2, '0')}:${time[3].toString().padLeft(2, '0')} hours';
  } else if (time[1] > 0) {
    return '${time[1]}:${time[2].toString().padLeft(2, '0')}:${time[3].toString().padLeft(2, '0')} hours';
  } else if (time[2] > 0) {
    return '${time[2].toString().padLeft(2, '0')}:${time[3].toString().padLeft(2, '0')} minutes';
  } else {
    return '${time[3].toString().padLeft(2, '0')} seconds';
  }
}

bool isSameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String getDayString(DateTime date) {
  if (isSameDay(date, DateTime.now())) {
    return 'Today';
  } else if (isSameDay(date, DateTime.now().subtract(Duration(days: 1)))) {
    return 'Yesterday';
  } else {
    return dateFormat(date);
  }
}

String dateFormat(DateTime date) {
  return '${weekdays[date.weekday - 1]}, ${date.day}. ${months[date.month - 1]} ${date.year}';
}

String timestampToString(String timestamp, bool withDate) {
  final DateTime ts = DateTime.parse(timestamp).toLocal();
  if (withDate) {
    return '${ts.day.toString().padLeft(2, '0')}/${ts.month.toString().padLeft(2, '0')}/${ts.year.toString()} ${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}:${ts.second.toString().padLeft(2, '0')}';
  }
  return '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}:${ts.second.toString().padLeft(2, '0')}';
}

openSpotify(String uri) async {
  Uri url = Uri.parse(uri);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $uri';
  }
}
