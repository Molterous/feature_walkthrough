import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WalkThroughNotifier {


  /// Shared Preference Keys
  static const String _idsPrefKey = "WalkThroughIds";


  /// class instance
  static final WalkThroughNotifier _inst = WalkThroughNotifier._privateConstructor();
  static WalkThroughNotifier get instance => _inst;


  /// private constructor
  WalkThroughNotifier._privateConstructor() { _retrieveSavedIds(); }


  /// to keep track of shown walk-throughs
  List<String> _shownWalkThroughs = [];


  /// to prevent multiple alert showing for same id
  String _lastId = "";

  // getter
  bool get isShownBefore => _id.value == _lastId;

  // setter
  void shownWalkthrough() {
    _lastId = _id.value;
    _updateSavedIds();
  }


  /// whether to show walkthrough or not
  bool _saveInPref = true;

  // setter
  void setPrefSave({required saveInPref}) => _saveInPref = saveInPref;


  /// Value-Notifier which is listened by Walk-Through widget
  final ValueNotifier<String> _id = ValueNotifier<String>("");

  // getter
  ValueNotifier get id => _id;

  // setter
  void setId(String id) {

    if (_shownWalkThroughs.contains(id)) return;

    _lastId = _id.value;
    _id.value = id;
  }


  /// to get all shown walk-throughs ids
  Future<void> _retrieveSavedIds() async {

    final prefs = await SharedPreferences.getInstance();
    _shownWalkThroughs = prefs.getStringList(_idsPrefKey) ?? <String>[];
  }


  /// to save shown walk-throughs ids in shared preference
  Future<void> _updateSavedIds() async {

    if (!_saveInPref) return;

    _shownWalkThroughs.add(_id.value);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_idsPrefKey, _shownWalkThroughs);
  }
}