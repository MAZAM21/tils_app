import 'package:cloud_firestore/cloud_firestore.dart';


class Role {
  final String role;

  Role(this.role);
  factory Role.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Role(data['role']??'none');
  }
  String get getRole {
    return role;
  }
}
