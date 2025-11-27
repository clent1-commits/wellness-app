import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  final FirestoreService _fs = FirestoreService();
  List<Map<String, dynamic>> _favorites = [];
  bool _loading = true;

  // Animation controller for card entrance
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _loadFavorites();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _fetchFirestoreFavorites();
    } else {
      await _fetchLocalFavorites();
    }

    _animationController.forward();
  }

  Future<void> _fetchFirestoreFavorites() async {
    try {
      final favorites = await _fs.fetchFavoritesForCurrentUser();
      setState(() => _favorites = favorites);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading favorites: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _fetchLocalFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFavorites = prefs.getStringList('local_favorites') ?? [];

    setState(() {
      _favorites = savedFavorites.map((fav) {
        final parts = fav.split('||');
        return {'title': parts[0], 'content': parts[1], 'id': parts[2]};
      }).toList();
      _loading = false;
    });
  }

  Future<void> _removeFavorite(String favoriteDocId) async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() => _loading = true);

    try {
      if (user != null) {
        await _fs.removeFavorite(favoriteDocId);
      } else {
        final prefs = await SharedPreferences.getInstance();
        final existing = prefs.getStringList('local_favorites') ?? [];
        existing.removeWhere((fav) => fav.contains(favoriteDocId));
        await prefs.setStringList('local_favorites', existing);
      }
      await _loadFavorites();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing favorite: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildFavoriteCard(Map<String, dynamic> favorite, int index) {
    return FadeTransition(
      opacity:
      CurvedAnimation(parent: _animationController, curve: Interval(0, 1.0)),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.2 * (index + 1)),
          end: Offset.zero,
        ).animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOut)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade700, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade200.withOpacity(0.4),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favorite['title'] ?? '',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    favorite['content'] ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _removeFavorite(favorite['id']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade700, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _loading
              ? Center(child: CircularProgressIndicator())
              : _favorites.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border,
                    size: 60, color: Colors.purple.shade200),
                SizedBox(height: 16),
                Text(
                  "No favorites yet 🌱",
                  style: TextStyle(
                      fontSize: 18, color: Colors.purple.shade400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
              : RefreshIndicator(
            onRefresh: _loadFavorites,
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _favorites.length,
              itemBuilder: (context, index) =>
                  _buildFavoriteCard(_favorites[index], index),
            ),
          ),
        ),
      ),
    );
  }
}
