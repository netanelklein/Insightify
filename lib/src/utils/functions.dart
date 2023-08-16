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
    return DateFormat(date);
  }
}

String DateFormat(DateTime date) {
  String dateString = '';
  // Get day of the week
  switch (date.weekday) {
    case 1:
      dateString += 'Monday';
      break;
    case 2:
      dateString += 'Tuesday';
      break;
    case 3:
      dateString += 'Wednesday';
      break;
    case 4:
      dateString += 'Thursday';
      break;
    case 5:
      dateString += 'Friday';
      break;
    case 6:
      dateString += 'Saturday';
      break;
    case 7:
      dateString += 'Sunday';
      break;
  }
  dateString += ', ';
  // Get month
  switch (date.month) {
    case 1:
      dateString += 'January';
      break;
    case 2:
      dateString += 'February';
      break;
    case 3:
      dateString += 'March';
      break;
    case 4:
      dateString += 'April';
      break;
    case 5:
      dateString += 'May';
      break;
    case 6:
      dateString += 'June';
      break;
    case 7:
      dateString += 'July';
      break;
    case 8:
      dateString += 'August';
      break;
    case 9:
      dateString += 'September';
      break;
    case 10:
      dateString += 'October';
      break;
    case 11:
      dateString += 'November';
      break;
    case 12:
      dateString += 'December';
      break;
  }
  dateString += ' ${date.day}, ${date.year}';

  return dateString;
}
