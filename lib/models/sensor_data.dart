class SensorData {
  final String id;
  final String name;
  final String unit;
  final String icon;
  final double value;
  final DateTime timestamp;

  SensorData({
    required this.id,
    required this.name,
    required this.unit,
    required this.icon,
    required this.value,
    required this.timestamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      icon: json['icon'],
      value: (json['value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
