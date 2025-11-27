import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // collection names
  final String tipsCollection = 'daily_tips';
  final String favoritesCollection = 'favorites';

  /// Fetch all tips (snapshot). We'll pick a random one on the client.
  Future<List<Map<String, dynamic>>> fetchAllTips() async {
    final snap = await _db.collection(tipsCollection).get();
    return snap.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList(growable: false);
  }

  /// Save favorite. If user is signed in, save with userId, else still save
  /// but include deviceId = 'anon' (or you can change to local cache).
  Future<void> saveFavorite(Map<String, dynamic> tip) async {
    final user = FirebaseAuth.instance.currentUser;
    final payload = {
      'tipId': tip['id'],
      'title': tip['title'] ?? '',
      'content': tip['content'] ?? '',
      'category': tip['category'] ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'userId': user?.uid ?? 'anonymous',
    };

    await _db.collection(favoritesCollection).add(payload);
  }

  /// Remove favorite by favorite doc id
  Future<void> removeFavorite(String favoriteDocId) async {
    await _db.collection(favoritesCollection).doc(favoriteDocId).delete();
  }

  /// Fetch favorites for current user (returns list of docs with id)
  Future<List<Map<String, dynamic>>> fetchFavoritesForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snap = await _db
        .collection(favoritesCollection)
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((d) {
      final m = d.data();
      m['favId'] = d.id;
      return m;
    }).toList();
  }

  /// pick a random tip from a list
  Map<String, dynamic>? pickRandomTip(List<Map<String, dynamic>> tips) {
    if (tips.isEmpty) return null;
    final idx = Random().nextInt(tips.length);
    return tips[idx];
  }
}
