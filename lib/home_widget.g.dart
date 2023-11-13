// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeWidget _$HomeWidgetFromJson(Map<String, dynamic> json) => HomeWidget(
      json['title'] as String,
      json['type'] as String,
      json['details'] as String,
      json['background'] as String,
    )..subTitle = json['subTitle'] as String?;

Map<String, dynamic> _$HomeWidgetToJson(HomeWidget instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subTitle': instance.subTitle,
      'type': instance.type,
      'details': instance.details,
      'background': instance.background,
    };
