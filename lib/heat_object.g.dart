// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heat_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Heat _$HeatFromJson(Map<String, dynamic> json) => Heat()
  ..did = (json['did'] as List<dynamic>).map((e) => e as int).toList()
  ..total = (json['total'] as List<dynamic>).map((e) => e as int).toList()
  ..date = DateTime.parse(json['date'] as String);

Map<String, dynamic> _$HeatToJson(Heat instance) => <String, dynamic>{
      'did': instance.did,
      'total': instance.total,
      'date': instance.date.toIso8601String(),
    };
