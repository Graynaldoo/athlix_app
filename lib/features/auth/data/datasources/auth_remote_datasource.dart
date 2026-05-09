import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _firestore
        .collection('users')
        .doc(cred.user!.uid)
        .get();
    return UserModel.fromFirestore(doc.data()!, cred.user!.uid);
  }

  Future<UserModel> register(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = UserModel(
      uid: cred.user!.uid,
      email: email,
      name: name,
      reliabilityScore: 100.0,
      createdAt: DateTime.now(),
    );
    await _firestore
        .collection('users')
        .doc(cred.user!.uid)
        .set(user.toFirestore());
    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc.data()!, user.uid);
    });
  }
}