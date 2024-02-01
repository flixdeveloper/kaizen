// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      json['type'] as String,
      (json['question'] as List<dynamic>).map((e) => e as String).toList(),
      (json['answear'] as List<dynamic>).map((e) => e as String).toList(),
      getDate(json),
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'type': instance.type,
      'dateTime': instance.dateTime.toIso8601String(),
      'question': instance.question,
      'answear': instance.answear,
    };

DateTime getDate(Map<String, dynamic> json) {
  if (json.containsKey('dateTime'))
    return DateTime.parse(json['dateTime'] as String);
  if (json.containsKey('date')) {
    final oldDateString = json['date'] as String;
    DateTime oldDate = new DateFormat('EEEE, MMM d').parse(oldDateString);
    return oldDate;
  }
  return DateTime.now();
}
