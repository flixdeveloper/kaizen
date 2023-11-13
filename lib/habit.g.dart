// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) => Habit(
      json['title'] as String,
      json['icon'] as int,
      json['isBuild'] as bool,
      json['frequency'] as String,
      (json['customDays'] as List<dynamic>).map((e) => e as bool).toList(),
      json['goal'] as int,
      json['allowReminder'] as bool,
      (json['reminders'] as List<dynamic>)
          .map((e) => Reminder.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..did = json['did'] as int
      ..resetAt = DateTime.parse(json['resetAt'] as String);

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
      'title': instance.title,
      'icon': instance.icon,
      'isBuild': instance.isBuild,
      'frequency': instance.frequency,
      'customDays': instance.customDays,
      'goal': instance.goal,
      'did': instance.did,
      'allowReminder': instance.allowReminder,
      'reminders': instance.reminders.map((e) => e.toJson()).toList(),
      'resetAt': instance.resetAt.toIso8601String(),
    };
