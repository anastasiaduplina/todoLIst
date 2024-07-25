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

  // elegant form of the equality operator overriding
  @override
  bool operator ==(Object other) {
    return (identical(this, other) ||
           ((other is ActionDto)&&
            (id == other.id)&&
            (text == other.text)&&
            (done == other.done)&&
            (deadline == other.deadline)&&
            (color == other.color)&&
            (changedAt == other.changedAt)&&
            (createdAt == other.createdAt)&&
            (lastUpdatedBy == other.lastUpdatedBy)
           )
           );
  }

  // hashCode getter should be overriden, using exclusive operatort helps uniquly indentifying the instance(exclusive operator should be used to merge hashCodes of attributes composited inside the object).
  @override
  int get hashCode => id.hashCode ^
    text.hashCode ^ 
    done.hashCode ^
    deadLine.hashCode ^
    importance.hashCode ^
    color.hashCode ^
    createdAt.hashCode ^
    changedAt.hashCode ^
    lastUpdatedBy.hashCode;
  
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
