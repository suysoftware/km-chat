class UserCoordinates {
  UserCoordinates({
    required this.latitude,
    required this.longitude,
    required this.isoCountryCode,
    required this.administrativeArea,
    required this.locality,
    required this.subLocality,
    required this.postalCode,
  });

  double latitude;
  double longitude;
  String isoCountryCode;
  String administrativeArea;
  String locality;
  String subLocality;
  String postalCode;

  factory UserCoordinates.fromJson(Map<String, dynamic> json) =>
      UserCoordinates(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        isoCountryCode: json["iso_country_code"],
        administrativeArea: json["administrative_area"],
        locality: json["locality"],
        subLocality: json["sub_locality"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "iso_country_code": isoCountryCode,
        "administrative_area": administrativeArea,
        "locality": locality,
        "sub_locality": subLocality,
        "postal_code": postalCode,
      };
}
