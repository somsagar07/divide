import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide/model/groups.dart';

class Groupdata {
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('Groups');

  List<Group> _groupListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Group(
          gname: doc['Gname'],
          names: doc['Name'],
          spend: doc['Spent'],
          uid: doc['user']);
    }).toList();
  }

  Stream<List<Group>> get groups {
    return groupCollection.snapshots().map(_groupListFromSnapshot);
  }
}
