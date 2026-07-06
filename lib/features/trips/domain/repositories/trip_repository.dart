import 'package:dartz/dartz.dart';
import 'package:travelmateai/core/errors/failures.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';

/// Trip filter options for list queries.
class TripFilter {
  const TripFilter({
    this.searchQuery,
    this.status,
    this.favoritesOnly = false,
    this.archivedOnly = false,
    this.includeArchived = false,
  });

  final String? searchQuery;
  final TripStatus? status;
  final bool favoritesOnly;
  final bool archivedOnly;
  final bool includeArchived;
}

/// Domain repository contract for trips.
abstract class TripRepository implements BaseRepository<Trip> {
  Future<Either<Failure, Trip>> createTrip(Trip trip);
  Future<Either<Failure, Trip>> updateTrip(Trip trip);
  Future<Either<Failure, void>> archiveTrip(String id);
  Future<Either<Failure, Trip>> duplicateTrip(String id);
  Future<Either<Failure, void>> toggleFavorite(String id);
  Future<List<Trip>> getFiltered({required String userId, TripFilter? filter});
  Future<List<Trip>> getUpcoming({required String userId, int limit = 5});
  Future<List<Trip>> getActive({required String userId, int limit = 5});
  Future<List<Trip>> getRecent({required String userId, int limit = 5});
}
