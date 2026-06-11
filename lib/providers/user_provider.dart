import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _campus = '';

  String get email => _email;
  String get campus => _campus.isEmpty ? 'ALU Campus' : _campus;

  String get fullName {
    if (_firstName.isNotEmpty || _lastName.isNotEmpty) {
      return '$_firstName $_lastName'.trim();
    }
    if (_email.isNotEmpty) return _nameFromEmail(_email);
    return 'ALU Student';
  }

  String get firstName {
    final parts = fullName.split(' ').where((p) => p.isNotEmpty).toList();
    return parts.isEmpty ? 'there' : parts.first;
  }

  String get initials {
    final parts = fullName.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'AL';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String _nameFromEmail(String email) {
    final local = email.split('@').first;
    final parts =
        local.split(RegExp(r'[._]+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'ALU Student';
    return parts
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _firstName = prefs.getString('user_first_name') ?? '';
    _lastName = prefs.getString('user_last_name') ?? '';
    _email = prefs.getString('user_email') ?? '';
    _campus = prefs.getString('user_campus') ?? '';
    notifyListeners();
  }

  void clear() {
    _firstName = '';
    _lastName = '';
    _email = '';
    _campus = '';
    notifyListeners();
  }
}
