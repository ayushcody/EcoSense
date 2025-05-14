import 'sensor_data.dart';

class SensorModel {
  final String id;
  final String name;
  final String unit;
  final String icon;
  double value;
  List<SensorData> history;
  double? threshold;

  SensorModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.icon,
    required this.value,
    required this.history,
    this.threshold,
  });

  SensorModel copyWith({
    String? id,
    String? name,
    String? unit,
    String? icon,
    double? value,
    List<SensorData>? history,
    double? threshold,
  }) {
    return SensorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      icon: icon ?? this.icon,
      value: value ?? this.value,
      history: history ?? this.history,
      threshold: threshold ?? this.threshold,
    );
  }
}
