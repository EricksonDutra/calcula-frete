class PlaceLocation {
  final double latitude;
  final double longitude;

  PlaceLocation({required this.latitude, required this.longitude});
}

class Place {
  final String? id;
  final String? title;
  final PlaceLocation location;

  Place({
    this.id,
    this.title,
    required this.location,
  });
}
