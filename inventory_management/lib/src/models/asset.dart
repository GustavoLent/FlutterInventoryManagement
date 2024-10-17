class Asset {
  final String? gatewayId;
  final String id;
  final String? locationId;
  final String name;
  final String? parentId;
  final String? sensorId;
  final String? sensorType;
  final String? status;

  Asset({
    this.gatewayId,
    required this.id,
    this.locationId,
    required this.name,
    this.parentId,
    this.sensorId,
    this.sensorType,
    this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> map) {
    return Asset(
      gatewayId: map['gatewayId'],
      id: map['id'] ?? '',
      locationId: map['locationId'],
      name: map['name'] ?? '',
      parentId: map['parentId'],
      sensorId: map['sensorId'],
      sensorType: map['sensorType'],
      status: map['status'],
    );
  }
}
