import 'package:dartz/dartz.dart';
import 'package:kakilima/core/failures/base_failure.dart';
import 'package:kakilima/features/stall/domain/entities/stall_entity.dart';
import 'package:kakilima/features/stall/domain/repositories/stall_repository.dart';

class StallUsecase {
  final StallRepository _stallRepository;

  StallUsecase(this._stallRepository);

  Future<Either<Failure, StallEntity?>> getVendorStall(String vendorId) async {
    return await _stallRepository.getVendorStall(vendorId);
  }

  Future<Either<Failure, StallEntity>> createStall({
    required String vendorId,
    required String name,
    String? nameEnhanced,
    String? description,
    String? photoUrl,
    required double longitude,
    required double latitude,
  }) async {
    return await _stallRepository.createStall(
      vendorId: vendorId,
      name: name,
      nameEnhanced: nameEnhanced,
      description: description,
      photoUrl: photoUrl,
      longitude: longitude,
      latitude: latitude,
    );
  }
}

