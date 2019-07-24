/**
 * Write own data types and do data conversion inside the Database class.
 * 
 * This is the application facing API to Firestore. This class works with data models
 * like the Job model, and we will add more models as needed.
 */

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

import 'api_path.dart';

abstract class Database {
  Future<void> setJob(Job job);
  // void readJobs();
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentData() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  // assert() makes sure that uid is not null before setting
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  /**
   * Moved all of the Firestore specific code to a separate class, so we  don't need
   * to worry about implementation in FirestoreDatabase class. Easier to create new
   * methods to write data. Can copy/paste setJob() (used to be createJob()) and adjust data type and API path
   * as needed. Same thing for reading data from a different API path, copy/paste 
   * jobsStream(), adjust the type being returned, and change the API path.
   * 
   * Can new data types if needed by creating models and craeting fromMap() and toMap()
   */
  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async => await _service.deleteData(
        path: APIPath.job(uid, job.id),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  /**
   * Firestore is a realtime DB
   * We can use streams to read data
   * And update the UI when data changes in Firestore
   */
  // void readJobs() {
  //   final path = APIPath.jobs(uid);
  //   final reference = Firestore.instance.collection(path);
  //   final snapshots = reference.snapshots();
  //   snapshots.listen((snapshot) {
  //     snapshot.documents.forEach((snapshot) => print(snapshot.data));
  //   });
  // }
  /**
   * Above is what this method used to be.
   * Using Stream and StreamBuilder makes the application reactive.
   */
  // Stream<List<Job>> jobsStream() {
  //   final path = APIPath.jobs(uid);
  //   final reference = Firestore.instance.collection(path);
  //   final snapshots = reference.snapshots();

  //   // Map over the snapshot documents and create a Job object
  //   // .map() returns an Iterable collection
  //   return snapshots.map((snapshot) => snapshot.documents
  //       .map(
  //         (snapshot) => Job.fromMap(snapshot.data),
  //       )
  //       .toList());
  // }
}
