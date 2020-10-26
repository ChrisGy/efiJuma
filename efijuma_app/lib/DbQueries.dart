import 'package:firebase_database/firebase_database.dart';

import 'firebaseCRUD.dart' show rootRef;

Future<void> testFunc() async {
  Query query1 = rootRef.child("test").child("key1").equalTo(23);
  print((await query1.once()).value);
}
