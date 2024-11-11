// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EventModel {
  String? id;
  DateTime startTime;
  DateTime endTime;
  bool isAllDay;
  String subject;
  String? notes;
  String? recurrenceRule;
  EventModel({
    this.id,
    required this.startTime,
    required this.endTime,
    this.isAllDay = false, // mac dinh
    this.subject = '',
    this.notes,
    this.recurrenceRule,
  });

  EventModel copyWith({
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    String? subject,
    String? notes,
    String? recurrenceRule,
  }) {
    return EventModel(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      subject: subject ?? this.subject,
      notes: notes ?? this.notes,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'isAllDay': isAllDay,
      'subject': subject,
      'notes': notes,
      'recurrenceRule': recurrenceRule,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      isAllDay: map['isAllDay'] as bool,
      subject: map['subject'] as String,
      notes: map['notes'] != null ? map['notes'] as String : null,
      recurrenceRule: map['recurrenceRule'] != null
          ? map['recurrenceRule'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventModel(startTime: $startTime, endTime: $endTime, isAllDay: $isAllDay, subject: $subject, notes: $notes, recurrenceRule: $recurrenceRule)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;

    return other.startTime == startTime &&
        other.endTime == endTime &&
        other.isAllDay == isAllDay &&
        other.subject == subject &&
        other.notes == notes &&
        other.recurrenceRule == recurrenceRule;
  }

  @override
  int get hashCode {
    return startTime.hashCode ^
        endTime.hashCode ^
        isAllDay.hashCode ^
        subject.hashCode ^
        notes.hashCode ^
        recurrenceRule.hashCode;
  }
}

extension ExtEventmodel on EventModel {
  String get formatedStartTimeString =>
      '${startTime.hour}:${startTime.minute}:${startTime.day}/${startTime.month}/${startTime.year}';
  String get formatedEndTimeString =>
      '${endTime.hour}:${endTime.minute}:${endTime.day}/${endTime.month}/${endTime.year}';
}
