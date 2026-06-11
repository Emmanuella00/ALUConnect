import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';

class OpportunityProvider extends ChangeNotifier {
  static const _storageKey = 'user_opportunities';

  final List<Event> _userOpportunities = [];
  bool _loaded = false;

  bool get isLoaded => _loaded;
  List<Event> get userOpportunities => List.unmodifiable(_userOpportunities);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      _userOpportunities
        ..clear()
        ..addAll(list.map((e) => Event.fromJson(e as Map<String, dynamic>)));
    }
    _loaded = true;
    notifyListeners();
  }

  Future<bool> addOpportunity(Event event) async {
    try {
      _userOpportunities.insert(0, event);
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_userOpportunities.map((e) => e.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<Event> getAllEvents() {
    final mockNonFeatured = MockEvents.all.where((e) => !e.isFeatured).toList();
    return [..._userOpportunities, ...mockNonFeatured];
  }
}
