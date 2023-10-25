// class Event {
//   final DateTime title;
//   const Event(this.title);

//   @override
//   String toString() => '$title';
// }
import 'package:workoutdiary/hivedata/xlog.dart';

class Event {
  final DateTime datetime;
  final List<Xlog> xlogs;
  final List<Ximg> ximgs;
  const Event(this.datetime, this.ximgs, this.xlogs);

  @override
  String toString() => '$datetime';
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

int getHashCodeInverse(DateTime key) {
  // return key.day * 1000000 + key.month * 10000 + key.year;
  return key.year * 10000 + key.month * 100 + key.day;
}

DateTime changeHashCodeToDateTime(int hashCode) {
  // year 값을 추출합니다.
  int year = hashCode % 10000;
  // month 값을 추출합니다.
  int month = ((hashCode / 10000) % 100).floor();
  // day 값을 추출합니다.
  int day = ((hashCode / 1000000) % 100).floor();
  return DateTime.utc(year, month, day);
}

DateTime changeHashCodeToInverseDateTime(int hashCode) {
  // year 값을 추출합니다.
  int year = ((hashCode / 10000) % 10000).floor();
  // month 값을 추출합니다.
  int month = ((hashCode / 100) % 100).floor();
  // day 값을 추출합니다.
  int day = hashCode % 100;
  return DateTime.utc(year, month, day);
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}
