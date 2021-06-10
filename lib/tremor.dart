const String tableTremors = 'tremors';

class TremorFields {
  static const String id = '_id';
  static const String recordedDateTime = 'recordedDateTime';
  static const List<String> values = <String>[id, recordedDateTime];
}

class Tremor {
  const Tremor({this.id, required this.recordedDateTime});

  final int? id;
  final DateTime recordedDateTime;

  Tremor copy({
    int? id,
    DateTime? recordedDateTime,
  }) =>
      Tremor(
          id: id ?? this.id,
          recordedDateTime: recordedDateTime ?? this.recordedDateTime);

  static Tremor fromJson(Map<String, Object?> json) => Tremor(
      id: json[TremorFields.id] as int?,
      recordedDateTime:
          DateTime.parse(json[TremorFields.recordedDateTime] as String));

  Map<String, Object?> toJson() => {
        TremorFields.id: id,
        TremorFields.recordedDateTime: recordedDateTime.toIso8601String()
      };
}
