class AlertModel {
  final String sensorId;
  final double minThreshold;
  final double maxThreshold;
  final String? whatsappNumber;

  AlertModel({
    required this.sensorId,
    required this.minThreshold,
    required this.maxThreshold,
    this.whatsappNumber,
  });
}