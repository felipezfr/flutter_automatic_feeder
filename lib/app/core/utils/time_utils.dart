import 'package:flutter/material.dart' show TimeOfDay;

class TimeUtils {
  // Converte TimeOfDay para minutos desde 00:00
  static int timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  // Converte minutos desde 00:00 para TimeOfDay
  static TimeOfDay minutesToTimeOfDay(int minutes) {
    return TimeOfDay(
      hour: minutes ~/ 60,
      minute: minutes % 60,
    );
  }

  // Formata minutos para string no formato HH:mm
  static String formatMinutes(int minutes) {
    final time = minutesToTimeOfDay(minutes);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
