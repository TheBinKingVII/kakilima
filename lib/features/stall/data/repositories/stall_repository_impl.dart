import 'package:dartz/dartz.dart';
import 'package:kakilima/core/failures/base_failure.dart';
import 'package:kakilima/features/stall/data/datasources/stall_remote_datasource.dart';
import 'package:kakilima/features/stall/domain/entities/stall_entity.dart';
import 'package:kakilima/features/stall/domain/repositories/stall_repository.dart';

class StallRepositoryImpl implements StallRepository {
  final StallRemoteDatasource _remoteDatasource;

  StallRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, StallEntity?>> getVendorStall(String vendorId) async {
    try {
      final stall = await _remoteDatasource.getVendorStall(vendorId);
      return Right(stall);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StallEntity>> createStall({
    required String vendorId,
    required String name,
    String? nameEnhanced,
    String? description,
    String? photoUrl,
    required double longitude,
    required double latitude,
  }) async {
    try {
      final stall = await _remoteDatasource.createStall(
        vendorId: vendorId,
        name: name,
        nameEnhanced: nameEnhanced,
        description: description,
        photoUrl: photoUrl,
        longitude: longitude,
        latitude: latitude,
      );
      return Right(stall);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

