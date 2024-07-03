import 'package:json_annotation/json_annotation.dart';

part 'action_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ActionDto {
  String id;
  String text;
  @JsonKey(
    fromJson: _boolFromString,
  )
  bool done;
  int? deadline;
  ImportanceDto importance;
  String color;
  @JsonKey(name: "created_at")
  int createdAt;
  @JsonKey(name: "changed_at")
  int changedAt;
  @JsonKey(name: "last_updated_by")
  String lastUpdatedBy;

  static bool _boolFromString(Object done) {
    if (done is String) {
      return done == "1";
    }
    if (done is int) {
      return done == 1;
    }
    if (done is bool) {
      return done;
    }
    return false;
  }

  ActionDto(
    this.id,
    this.text,
    this.done,
    this.deadline,
    this.importance,
    this.color,
    this.createdAt,
    this.changedAt,
    this.lastUpdatedBy,
  );

  factory ActionDto.fromJson(Map<String, dynamic> json) =>
      _$ActionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ActionDtoToJson(this);

  @override
  bool operator ==(Object other) {
    if (other is! ActionDto) return false;
    if (id != other.id) return false;
    if (text != other.text) return false;
    if (done != other.done) return false;
    if (deadline != other.deadline) return false;
    if (color != other.color) return false;
    if (changedAt != other.changedAt) return false;
    if (createdAt != other.createdAt) return false;
    if (lastUpdatedBy != other.lastUpdatedBy) return false;
    return true;
  }

  @override
  int get hashCode => text.hashCode;
}

enum ImportanceDto {
  @JsonValue("basic")
  basic,
  @JsonValue("low")
  low,
  @JsonValue("high")
  high;

  const ImportanceDto();
}
