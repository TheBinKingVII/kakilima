import 'package:kakilima/features/stall/domain/entities/stall_entity.dart';

class StallModel extends StallEntity {
  const StallModel({
    required super.id,
    required super.vendorId,
    required super.name,
    super.nameEnhanced,
    super.description,
    super.photoUrl,
    super.location,
    super.currentLocation,
    required super.isActive,
    super.lastSeenAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory StallModel.fromJson(Map<String, dynamic> json) {
    return StallModel(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String,
      name: json['name'] as String,
      nameEnhanced: json['name_enhanced'] as String?,
      description: json['description'] as String?,
      photoUrl: json['photo_url'] as String?,
      location: json['location'] != null ? json['location'] as String : null,
      currentLocation: json['current_location'] != null ? json['current_location'] as String : null,
      isActive: json['is_active'] as bool? ?? true,
      lastSeenAt: json['last_seen_at'] != null ? DateTime.parse(json['last_seen_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'name': name,
      'name_enhanced': nameEnhanced,
      'description': description,
      'photo_url': photoUrl,
      'location': location,
      'current_location': currentLocation,
      'is_active': isActive,
      'last_seen_at': lastSeenAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'vendor_id': vendorId,
      'name': name,
      'name_enhanced': nameEnhanced,
      'description': description,
      'photo_url': photoUrl,
      'location': location != null ? 'POINT(${_parsePoint(location!)}' : null,
    };
  }

  String _parsePoint(String pointString) {
    // Parse PostGIS POINT format: "POINT(longitude latitude)" or "SRID=4326;POINT(longitude latitude)"
    if (pointString.contains('POINT')) {
      final match = RegExp(r'POINT\(([^)]+)\)').firstMatch(pointString);
      if (match != null) {
        return match.group(1)!;
      }
    }
    return pointString;
  }
}

