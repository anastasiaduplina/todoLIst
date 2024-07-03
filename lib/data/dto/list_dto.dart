import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import 'action_dto.dart';

part 'list_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ListDto {
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(defaultValue: 0)
  final int revision;
  @JsonKey(defaultValue: [])
  final List<ActionDto> list;

  const ListDto(this.status, this.revision, this.list);

  factory ListDto.fromJson(Map<String, dynamic> json) =>
      _$ListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ListDtoToJson(this);
}
