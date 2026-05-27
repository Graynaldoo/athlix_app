import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/match_model.dart';

class MatchRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser!.uid;

  // READ — stream semua open match
  Stream<List<MatchModel>> getOpenMatches() {
    return _firestore
        .collection('matches')
        .where('status', isEqualTo: 'open')
        .orderBy('matchDate', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map(MatchModel.fromFirestore).toList());
  }

  // CREATE — buat match baru
  Future<void> createMatch(MatchModel match) async {
    await _firestore.collection('matches').add(match.toFirestore());
  }

  // UPDATE — edit match (hanya host)
  Future<void> updateMatch(String matchId, Map<String, dynamic> data) async {
    await _firestore.collection('matches').doc(matchId).update(data);
  }

  // DELETE — hapus match (hanya host)
  Future<void> deleteMatch(String matchId) async {
    await _firestore.collection('matches').doc(matchId).delete();
  }

  // JOIN match
  Future<void> joinMatch(String matchId) async {
    await _firestore.collection('matches').doc(matchId).update({
      'joinedPlayerIds': FieldValue.arrayUnion([currentUserId]),
    });
  }

  // LEAVE match
  Future<void> leaveMatch(String matchId) async {
    await _firestore.collection('matches').doc(matchId).update({
      'joinedPlayerIds': FieldValue.arrayRemove([currentUserId]),
    });
  }

  // Stream match milik user sendiri
  Stream<List<MatchModel>> getMyMatches() {
    return _firestore
        .collection('matches')
        .where('hostId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(MatchModel.fromFirestore).toList());
  }
}