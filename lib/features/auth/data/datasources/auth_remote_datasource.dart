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

    final firebaseUser = cred.user;
    if (firebaseUser == null) {
      throw Exception('Login gagal: user tidak ditemukan');
    }

    final doc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    // If user document doesn't exist in Firestore, create it automatically
    if (!doc.exists || doc.data() == null) {
      final newUser = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? email,
        name: firebaseUser.displayName ?? email.split('@').first,
        photoUrl: firebaseUser.photoURL,
        reliabilityScore: 100.0,
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(newUser.toFirestore());
      return newUser;
    }

    return UserModel.fromFirestore(doc.data()!, firebaseUser.uid);
  }

  Future<UserModel> register(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = cred.user;
    if (firebaseUser == null) {
      throw Exception('Registrasi gagal: user tidak dibuat');
    }

    final user = UserModel(
      uid: firebaseUser.uid,
      email: email,
      name: name,
      reliabilityScore: 100.0,
      createdAt: DateTime.now(),
    );
    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
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
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromFirestore(doc.data()!, user.uid);
    });
  }
}