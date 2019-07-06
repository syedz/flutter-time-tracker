/**
 * When using Firestore, implement fromMap(data) and toMap() in the model classes
 */

import 'package:meta/meta.dart';

class Job {
  Job({@required this.name, @required this.ratePerHour});
  final String name;
  final int ratePerHour;

  /**
   * Use factory keyword when implementing a constructor that doesn't always 
   * create a new instance of its class. Factory constructor might return an 
   * instance from a cache, or it might return an instance of a subtype.
   */
  factory Job.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];

    return Job(
      name: name,
      ratePerHour: ratePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
