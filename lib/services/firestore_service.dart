/**
 * - Used to read/write data to Firestore, using key-value pairs.
 * - Encapsulates all Firestore-specific methods. We can swap databases if we wanted to,
 * but Database would stay the same.
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  // Create private constructor so that objects can't be created outside of this class
  FirestoreService._();
  static final instance = FirestoreService._();

  // Moved from database.dart
  // Defines a single entry point for all writes to Firestore (useful for logging/debugging)
  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);
  }

  /**
   * Moved from database.dart
   * Used to be jobsStream()
   */
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();

    // Map over the snapshot documents and create a Job object
    // .map() returns an Iterable collection
    return snapshots.map((snapshot) => snapshot.documents
        .map(
          (snapshot) => builder(snapshot.data, snapshot.documentID),
        )
        .toList());
  }
}
