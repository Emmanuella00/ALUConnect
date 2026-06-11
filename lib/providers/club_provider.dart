import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/club.dart';

class ClubProvider extends ChangeNotifier {
  static const _joinedKey = 'joined_club_ids';
  static const _helpfulKey = 'announcement_helpful_counts';

  final Set<String> _joinedIds = {};
  final Map<String, int> _helpfulCounts = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;
  Set<String> get joinedIds => _joinedIds;
  int get joinedCount => _joinedIds.length;

  bool isJoined(String clubId) => _joinedIds.contains(clubId);

  int helpfulCount(String announcementId) => _helpfulCounts[announcementId] ?? 0;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final joined = prefs.getStringList(_joinedKey);
    if (joined != null) {
      _joinedIds.addAll(joined);
    } else {
      _joinedIds.add('2');
    }

    final helpfulJson = prefs.getString(_helpfulKey);
    if (helpfulJson != null) {
      final decoded = jsonDecode(helpfulJson) as Map<String, dynamic>;
      decoded.forEach((key, value) {
        _helpfulCounts[key] = value as int;
      });
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> _persistJoined() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_joinedKey, _joinedIds.toList());
  }

  Future<void> _persistHelpful() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_helpfulKey, jsonEncode(_helpfulCounts));
  }

  Future<void> toggleJoin(String clubId) async {
    if (_joinedIds.contains(clubId)) {
      _joinedIds.remove(clubId);
    } else {
      _joinedIds.add(clubId);
    }
    await _persistJoined();
    notifyListeners();
  }

  Future<void> markHelpful(String announcementId) async {
    _helpfulCounts[announcementId] = (_helpfulCounts[announcementId] ?? 0) + 1;
    await _persistHelpful();
    notifyListeners();
  }

  List<Club> get joinedClubs =>
      MockClubs.all.where((c) => _joinedIds.contains(c.id)).toList();
}
