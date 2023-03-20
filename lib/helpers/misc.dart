import 'package:intl/intl.dart';

class Misc {
  static bool convertToBoolean(String x) {
    if (x == "true" || x == "True" || x == "1" || x == "-1") {
      return true;
    } else {
      return false;
    }
  }

  static String sinceDate(Duration difference) {
    if ((difference.inDays / 365).floor() > 0) {
      return (difference.inDays / 365).floor().toString() + " Year";
    } else if ((difference.inDays / 30).floor() > 0) {
      return (difference.inDays / 30).floor().toString() + " Month";
    } else if ((difference.inDays / 7).floor() > 0) {
      return (difference.inDays / 7).floor().toString() + " Week";
    } else if ((difference.inDays).floor() > 0) {
      int hours = (difference.inHours - (difference.inDays * 24)).floor();
      return difference.inDays.floor().toString() + "d " + hours.toString() + "h"; // + Since_date.Minutes.ToString() + "m"
    } else if (difference.inHours.floor() > 0) {
      int minutes = (difference.inMinutes - (difference.inHours * 60)).floor();
      int seconds = (difference.inSeconds - (difference.inMinutes * 60)).floor();

      return difference.inHours.floor().toString() + "h " + minutes.toString() + "m " + seconds.toString() + "s";
    } else if (difference.inMinutes.floor() > 0) {
      int seconds = (difference.inSeconds - (difference.inMinutes * 60)).floor();

      return difference.inMinutes.floor().toString() + "m " + seconds.toString() + "s";
    } else {
      return difference.inSeconds.floor().toString() + "s";
    }
  }

  static String toShortDate(DateTime? date_time) {
    if (date_time == null) return "";
    return DateFormat('dd/MM/yyyy').format(date_time);
  }

  static String toShortTime(DateTime? date_time) {
    if (date_time == null) return "";
    return DateFormat('h:mm a').format(date_time);
  }

  static String toShortDateTime(DateTime date_time) {
    if (date_time == null) return "";
    return DateFormat('dd/MM/yyyy h:mm a').format(date_time);
  }

  static String shortTime({required int hour}) {
    if (hour == null) return "";
    if (hour < 10) {
      return "0" + hour.toString() + ":00";
    } else {
      return hour.toString() + ":00";
    }
  }
}
