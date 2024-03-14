import 'package:everylounge/domain/entities/order/schedule.dart';
import 'package:intl/intl.dart';

class SchedulerParser {
  static String parseScheduleTime(String time) {
    final nowDate = DateFormat('y-MM-dd').format(DateTime.now());
    final inputDate = DateTime.parse('$nowDate $time');
    return DateFormat('HH:mm').format(inputDate);
  }

  static Map<String, List<String>> parserSchedule(List<Schedule> list) {
    Map<String, List<String>> map = {};

    for (var schedule in list) {
      for (var day in schedule.validDays) {
        var list = map[translatedDaysMap[day]];
        if (list == null || list.isEmpty) {
          map[translatedDaysMap[day]] = [
            "${parseScheduleTime(schedule.validFromTime)}-${parseScheduleTime(schedule.validTillTime)}"
          ];
        } else {
          var time = "${parseScheduleTime(schedule.validFromTime)}-${parseScheduleTime(schedule.validTillTime)}";
          if (!list.contains(time)) {
            list.add(time);
          }
          map[translatedDaysMap[day]] = list;
        }
      }
    }

    // Сортировка временных диапазонов для каждого дня недели
    map.forEach((day, timesList) {
      map[day] = sortTimeRanges(timesList);
    });

    // Сортировка дней недели
    var sortedByKeyMap = <String, List<String>>{};
    for (var key in translatedDaysMap.values.toList()) {
      sortedByKeyMap[key] = map[key] ?? [];
    }

    return sortedByKeyMap;
  }

  static List<String> sortTimeRanges(List<String> timeRanges) {
    timeRanges.sort((a, b) {
      final startA = a.split('-')[0];
      final startB = b.split('-')[0];
      return startA.compareTo(startB);
    });
    return timeRanges;
  }

  static Map get translatedDaysMap => {
        "mon": "Понедельник",
        "tue": "Вторник",
        "wed": "Среда",
        "thu": "Четверг",
        "fri": "Пятница",
        "sat": "Суббота",
        "sun": "Воскресение",
      };

  static bool isAroundClock(List<Schedule> list) {
    Map<String, List<String>> map = parserSchedule(list);
    bool isAround = map.entries.every((entry) {
      return entry.value.first == '00:00-23:59' || entry.value.first == '00:00-00:00';
    });
    return isAround;
  }

  static getTimeSchedulerMainTitle(List<Schedule>? scheduleList) {
    var timeFrom = '';
    var timeTill = '';
    var aroundClock = scheduleList != null ? SchedulerParser.isAroundClock(scheduleList) : false;
    if (aroundClock == false) {
      timeFrom = SchedulerParser.parseScheduleTime(scheduleList?.first.validFromTime ?? "");
      timeTill = SchedulerParser.parseScheduleTime(scheduleList?.first.validTillTime ?? "");
    }
    return ((scheduleList?.length ?? 0) > 1)
        ? 'Время работы'
        : aroundClock
            ? 'Круглосуточно'
            : 'C $timeFrom до $timeTill';
  }
}
