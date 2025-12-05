class FavoriteCity {
  final String id;
  final String name;
  final double? lat;
  final double? lon;
  final DateTime addedAt;

  FavoriteCity({
    required this.id,
    required this.name,
    this.lat,
    this.lon,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'lat': lat,
    'lon': lon,
    'addedAt': addedAt.toIso8601String(),
  };

  factory FavoriteCity.fromJson(Map<String, dynamic> json) {
    return FavoriteCity(
      id: json['id'],
      name: json['name'],
      lat: json['lat'],
      lon: json['lon'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
}