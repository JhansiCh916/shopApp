import 'dart:io';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate = DateTime.now();
  String? _userID;
  Timer? _authTimer;

  bool get isAuth {
    print("\$HI${token}");
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userID;
  }

  // Auth(this._token, this._expiryDate, this._userID);

  Future<void> _authenticate(String email, String password,
      String urlSegment) async {
    final url = Uri.parse(urlSegment);
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDate = DateTime.now().add(
          Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'userId': _userID,
        'expiryDate': _expiryDate?.toIso8601String(),
      });
      preferences.setString('userData', userData);

    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogIn() async {
    final shredPrefrences = await SharedPreferences.getInstance();
    if (!shredPrefrences.containsKey('userData')) {
      return false;
    }
    final extractedData = json.decode(shredPrefrences.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userID = extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;

  }

  Future<void> signUp(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDNTlRRnP1vtk47cwYyZ4KRhKK4RJwNp1k";
    return _authenticate(email, password, url);
  }

  Future<void> loginIn(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDNTlRRnP1vtk47cwYyZ4KRhKK4RJwNp1k";
    return _authenticate(email, password, url);
  }

  Future<void> logOut() async {
    _token = null;
    _userID = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry ?? 0), logOut);
  }
}
