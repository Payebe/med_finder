class Pharmacy {
  final String nomPharmacie;
  final String type;
  final String emplacement;
  final List<String> contacts;
  final double? longitude;
  final double? latitude;

  Pharmacy({
    required this.nomPharmacie,
    required this.type,
    required this.emplacement,
    required this.contacts,
    this.longitude,
    this.latitude,
  });
}
