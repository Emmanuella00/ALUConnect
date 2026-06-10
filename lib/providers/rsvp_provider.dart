import 'package:flutter/material.dart';

class RsvpProvider extends ChangeNotifier {
  final Set<String> _rsvpedIds = {};
  final Set<String> _interestedIds = {};
  final Set<String> _savedIds = {};

  bool isGoing(String eventId) => _rsvpedIds.contains(eventId);
  bool isInterested(String eventId) => _interestedIds.contains(eventId);
  bool isSaved(String eventId) => _savedIds.contains(eventId);

  Set<String> get rsvpedIds => _rsvpedIds;
  Set<String> get interestedIds => _interestedIds;
  Set<String> get savedIds => _savedIds;

  void rsvp(String eventId) {
    _rsvpedIds.add(eventId);
    _interestedIds.remove(eventId);
    notifyListeners();
  }

  void markInterested(String eventId) {
    _interestedIds.add(eventId);
    _rsvpedIds.remove(eventId);
    notifyListeners();
  }

  void toggleSave(String eventId) {
    if (_savedIds.contains(eventId)) {
      _savedIds.remove(eventId);
    } else {
      _savedIds.add(eventId);
    }
    notifyListeners();
  }

  void cancelRsvp(String eventId) {
    _rsvpedIds.remove(eventId);
    notifyListeners();
  }
}
