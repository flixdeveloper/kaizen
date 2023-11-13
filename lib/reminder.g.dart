// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) => Reminder(
      DateTime.parse(json['time'] as String),
      (json['days'] as List<dynamic>).map((e) => e as bool).toList(),
    )..id = json['id'] as int;

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'id': instance.id,
      'time': instance.time.toIso8601String(),
      'days': instance.days,
    };
