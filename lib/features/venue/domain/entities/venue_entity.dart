import 'package:equatable/equatable.dart';

class VenueEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> sportsAvailable;
  final double rating;
  final String imageUrl;
  final String priceRange;

  const VenueEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.sportsAvailable,
    required this.rating,
    required this.imageUrl,
    required this.priceRange,
  });

  @override
  List<Object?> get props => [
    id, name, address, latitude, longitude, sportsAvailable, rating, imageUrl, priceRange
  ];
}
