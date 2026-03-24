import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';
import '../../models/user_model.dart';

/// Reads and writes the Firestore `users` collection.
class FirestoreUserDataSource {
  FirestoreUserDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection(AppConstants.usersCollection).doc(uid);

  // ── Create ────────────────────────────────────────────────────────────────

  Future<void> createUserDocument(UserModel model) async {
    try {
      // set with merge:true is idempotent — safe to call on Google re-sign.
      await _userDoc(model.uid).set(model.toFirestore(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to create user document.');
    }
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  Stream<UserModel?> getUserStream(String uid) {
    return _userDoc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _userDoc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to fetch user.');
    }
  }

  // ── savedGyms Updates ─────────────────────────────────────────────────────

  Future<void> saveGym(String uid, String gymId) async {
    try {
      await _userDoc(uid).update({
        'savedGyms': FieldValue.arrayUnion([gymId]),
      });
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to save gym.');
    }
  }

  Future<void> unsaveGym(String uid, String gymId) async {
    try {
      await _userDoc(uid).update({
        'savedGyms': FieldValue.arrayRemove([gymId]),
      });
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to unsave gym.');
    }
  }
}
