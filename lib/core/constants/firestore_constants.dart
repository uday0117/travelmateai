/// Firestore collection and field names.
abstract final class FirestoreConstants {
  static const String usersCollection = 'users';
  static const String tripsCollection = 'trips';
  static const String expensesCollection = 'expenses';
  static const String packingListsCollection = 'packingLists';
  static const String documentsCollection = 'documents';
  static const String journalEntriesCollection = 'journalEntries';
  static const String settingsCollection = 'settings';
  static const String favoritesCollection = 'favorites';
  static const String notificationsCollection = 'notifications';
  static const String visitedPlacesCollection = 'visitedPlaces';
  static const String travelStatsCollection = 'travelStats';

  static const String syncStatusField = 'syncStatus';
  static const String updatedAtField = 'updatedAt';
  static const String createdAtField = 'createdAt';
  static const String userIdField = 'userId';
  static const String tripIdField = 'tripId';
  static const String isDeletedField = 'isDeleted';
}
