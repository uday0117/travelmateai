import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmateai/core/constants/firestore_constants.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/features/auth/domain/entities/app_user.dart';

/// Creates and updates the Firestore user profile document after sign-in.
class FirestoreUserService {
  FirestoreUserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> ensureUserProfile(AppUser user) async {
    if (!FirebaseService.isInitialized) return;

    try {
      final doc = _firestore.collection(FirestoreConstants.usersCollection).doc(user.id);
      final snapshot = await doc.get();
      final payload = <String, dynamic>{
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'provider': user.provider.name,
        'isAnonymous': user.isAnonymous,
        FirestoreConstants.updatedAtField: FieldValue.serverTimestamp(),
      };
      if (!snapshot.exists) {
        payload[FirestoreConstants.createdAtField] = FieldValue.serverTimestamp();
      }
      await doc.set(payload, SetOptions(merge: true));
    } catch (e, st) {
      AppLogger.warning('Failed to upsert user profile for ${user.id}', e, st);
    }
  }
}
