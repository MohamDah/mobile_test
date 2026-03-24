import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';
import '../../models/gym_model.dart';

/// Interacts directly with the Firestore `gyms` collection.
class FirestoreGymDataSource {
  FirestoreGymDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _gymsRef =>
      _firestore.collection(AppConstants.gymsCollection);

  // ── Read ─────────────────────────────────────────────────────────────────

  /// Emits a new list on every Firestore write — powers real-time UI updates.
  Stream<List<GymModel>> getGymsStream() {
    try {
      return _gymsRef
          .orderBy('name')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => GymModel.fromFirestore(doc)).toList());
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to load gyms.');
    }
  }

  Future<GymModel> getGymById(String id) async {
    try {
      final doc = await _gymsRef.doc(id).get();
      if (!doc.exists) throw const NotFoundFailure('Gym not found.');
      return GymModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to fetch gym.');
    }
  }

  // ── Write ────────────────────────────────────────────────────────────────

  Future<void> createGym(GymModel model) async {
    try {
      await _gymsRef.add(model.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to create gym.');
    }
  }

  Future<void> updateGym(GymModel model) async {
    try {
      await _gymsRef.doc(model.id).update(model.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to update gym.');
    }
  }

  Future<void> deleteGym(String id) async {
    try {
      await _gymsRef.doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to delete gym.');
    }
  }
}
