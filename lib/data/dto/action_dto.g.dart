// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionDto _$ActionDtoFromJson(Map<String, dynamic> json) => ActionDto(
      json['id'] as String,
      json['text'] as String,
      ActionDto._boolFromString(json['done'] as Object),
      (json['deadline'] as num?)?.toInt(),
      $enumDecode(_$ImportanceDtoEnumMap, json['importance']),
      json['color'] as String,
      (json['created_at'] as num).toInt(),
      (json['changed_at'] as num).toInt(),
      json['last_updated_by'] as String,
    );

Map<String, dynamic> _$ActionDtoToJson(ActionDto instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'done': instance.done,
      'deadline': instance.deadline,
      'importance': _$ImportanceDtoEnumMap[instance.importance]!,
      'color': instance.color,
      'created_at': instance.createdAt,
      'changed_at': instance.changedAt,
      'last_updated_by': instance.lastUpdatedBy,
    };

const _$ImportanceDtoEnumMap = {
  ImportanceDto.basic: 'basic',
  ImportanceDto.low: 'low',
  ImportanceDto.high: 'high',
};
