import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@module
abstract class FirestoreModule {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}
