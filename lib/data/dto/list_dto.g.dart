// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListDto _$ListDtoFromJson(Map<String, dynamic> json) => ListDto(
      json['status'] as String? ?? '',
      (json['revision'] as num?)?.toInt() ?? 0,
      (json['list'] as List<dynamic>?)
              ?.map((e) => ActionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ListDtoToJson(ListDto instance) => <String, dynamic>{
      'status': instance.status,
      'revision': instance.revision,
      'list': instance.list.map((e) => e.toJson()).toList(),
    };
