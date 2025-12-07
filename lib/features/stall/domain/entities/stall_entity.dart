import 'package:equatable/equatable.dart';

class StallEntity extends Equatable {
  final String id;
  final String vendorId;
  final String name;
  final String? nameEnhanced;
  final String? description;
  final String? photoUrl;
  final String? location; // PostGIS POINT format
  final String? currentLocation; // PostGIS POINT format
  final bool isActive;
  final DateTime? lastSeenAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StallEntity({
    required this.id,
    required this.vendorId,
    required this.name,
    this.nameEnhanced,
    this.description,
    this.photoUrl,
    this.location,
    this.currentLocation,
    required this.isActive,
    this.lastSeenAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        vendorId,
        name,
        nameEnhanced,
        description,
        photoUrl,
        location,
        currentLocation,
        isActive,
        lastSeenAt,
        createdAt,
        updatedAt,
      ];
}

