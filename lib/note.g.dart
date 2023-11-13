// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      json['type'] as String,
      (json['question'] as List<dynamic>).map((e) => e as String).toList(),
      (json['answear'] as List<dynamic>).map((e) => e as String).toList(),
    )..date = json['date'] as String;

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'type': instance.type,
      'date': instance.date,
      'question': instance.question,
      'answear': instance.answear,
    };
