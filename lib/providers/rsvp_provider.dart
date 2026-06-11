import 'package:flutter/material.dart';
import '../data/rsvp_database.dart';

class RsvpProvider extends ChangeNotifier {
  final RsvpDatabase _db = RsvpDatabase();
  final Set<String> _rsvpedIds = {};
  final Set<String> _interestedIds = {};
  final Set<String> _savedIds = {};

  bool isGoing(String eventId) => _rsvpedIds.contains(eventId);
  bool isInterested(String eventId) => _interestedIds.contains(eventId);
  bool isSaved(String eventId) => _savedIds.contains(eventId);

  Set<String> get rsvpedIds => _rsvpedIds;
  Set<String> get interestedIds => _interestedIds;
  Set<String> get savedIds => _savedIds;

  Future<void> load() async {
    final rows = await _db.fetchAll();
    if (rows.isEmpty) return;
    for (final row in rows) {
      final id = row['event_id'] as String;
      if (row['going'] == 1) _rsvpedIds.add(id);
      if (row['interested'] == 1) _interestedIds.add(id);
      if (row['saved'] == 1) _savedIds.add(id);
    }
    notifyListeners();
  }

  void _persist(String eventId) {
    _db.save(
      eventId,
      going: _rsvpedIds.contains(eventId),
      interested: _interestedIds.contains(eventId),
      saved: _savedIds.contains(eventId),
    );
  }

  void rsvp(String eventId) {
    _rsvpedIds.add(eventId);
    _interestedIds.remove(eventId);
    notifyListeners();
    _persist(eventId);
  }

  void markInterested(String eventId) {
    _interestedIds.add(eventId);
    _rsvpedIds.remove(eventId);
    notifyListeners();
    _persist(eventId);
  }

  void toggleSave(String eventId) {
    if (_savedIds.contains(eventId)) {
      _savedIds.remove(eventId);
    } else {
      _savedIds.add(eventId);
    }
    notifyListeners();
    _persist(eventId);
  }

  void cancelRsvp(String eventId) {
    _rsvpedIds.remove(eventId);
    notifyListeners();
    _persist(eventId);
  }

  void reset() {
    _rsvpedIds.clear();
    _interestedIds.clear();
    _savedIds.clear();
    notifyListeners();
    _db.clear();
  }
}
