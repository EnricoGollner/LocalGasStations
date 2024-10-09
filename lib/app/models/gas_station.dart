class GasStation {
  final String name;
  final String address;
  final String? photoReference;
  final double lat;
  final double long;
  final bool isOpen;

  GasStation({
    required this.name,
    required this.address,
    this.photoReference,
    required this.lat,
    required this.long,
    required this.isOpen,
  });

  factory GasStation.fromJson(Map<String, dynamic> json) {
    return GasStation(
      name: json['name'],
      address: json['vicinity'],
      photoReference: json['photos'] != null ? json['photos'][0]['photo_reference'] : null,
      lat: json['geometry']['location']['lat'],
      long: json['geometry']['location']['lng'],
      isOpen: json['opening_hours']['open_now'],
    );
  }
}