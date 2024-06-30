import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import 'action_dto.dart';

part 'element_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ElementDto {
  final ActionDto element;

  const ElementDto(this.element);

  factory ElementDto.fromJson(Map<String, dynamic> json) =>
      _$ElementDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ElementDtoToJson(this);
}
