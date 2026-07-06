import 'package:isar/isar.dart';
import 'package:travelmateai/features/explore/data/models/travel_stats_isar_model.dart';
import 'package:travelmateai/features/explore/data/models/visited_place_isar_model.dart';
import 'package:travelmateai/features/favorites/data/models/favorite_isar_model.dart';
import 'package:travelmateai/features/documents/data/models/document_isar_model.dart';
import 'package:travelmateai/features/expenses/data/models/expense_isar_model.dart';
import 'package:travelmateai/features/journal/data/models/journal_isar_model.dart';
import 'package:travelmateai/features/packing/data/models/packing_isar_model.dart';
import 'package:travelmateai/features/trips/data/models/trip_isar_model.dart';

/// All Isar collection schemas for the app database.
abstract final class AppIsarSchemas {
  static List<CollectionSchema> get all => [
        TripIsarModelSchema,
        ExpenseIsarModelSchema,
        PackingIsarModelSchema,
        JournalIsarModelSchema,
        DocumentIsarModelSchema,
        FavoriteIsarModelSchema,
        VisitedPlaceIsarModelSchema,
        TravelStatsIsarModelSchema,
      ];
}
