// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goal _$GoalFromJson(Map<String, dynamic> json) => Goal(
      json['type'] as int,
      json['goal'] as String,
    )..customType = json['customType'] as String?;

Map<String, dynamic> _$GoalToJson(Goal instance) => <String, dynamic>{
      'type': instance.type,
      'goal': instance.goal,
      'customType': instance.customType,
    };
