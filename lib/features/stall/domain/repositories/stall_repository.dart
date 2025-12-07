import 'package:dartz/dartz.dart';
import 'package:kakilima/core/failures/base_failure.dart';
import 'package:kakilima/features/stall/domain/entities/stall_entity.dart';

abstract class StallRepository {
  Future<Either<Failure, StallEntity?>> getVendorStall(String vendorId);
  Future<Either<Failure, StallEntity>> createStall({
    required String vendorId,
    required String name,
    String? nameEnhanced,
    String? description,
    String? photoUrl,
    required double longitude,
    required double latitude,
  });
  Future<Either<Failure, List<StallEntity>>> getAllActiveStalls({
    double? latitude,
    double? longitude,
  });
}

