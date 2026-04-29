extension DateNormalization on DateTime {
  /// Returns a new DateTime with only year, month, and day (no time).
  DateTime get dateOnly => DateTime(year, month, day);

  /// Whether this date is the same calendar day as [other].
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Whether this date is today.
  bool get isToday => isSameDay(DateTime.now());

  /// Whether this date is in the past (before today).
  bool get isPast => dateOnly.isBefore(DateTime.now().dateOnly);

  /// Returns the start of the month that contains this date.
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Returns the end of the month that contains this date.
  DateTime get endOfMonth => DateTime(year, month + 1, 0);
}
