import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  // begin::Entry

  // getter for isAuth to load desired screen
  bool get isAuth {
    return token != null;
  }
  // getter to test the token status if it's set or not

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }
/* 
URLs

1. For SignIn
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAC9X5k3AqU5gXmrYiscPMLuQnj0Rq1qGQ';


2. For Sign Up
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAC9X5k3AqU5gXmrYiscPMLuQnj0Rq1qGQ';
 */

  Future<void> _authenticateUser(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAC9X5k3AqU5gXmrYiscPMLuQnj0Rq1qGQ';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // Setting properties for the token
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogOut();
      notifyListeners();
      // Storing Login Information for auto login
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      print("Auth Provider: $error");
      throw error;
    }
  }

// Setting up the Sign Up
  Future<void> signUp(String email, String password) async {
    return _authenticateUser(email, password, "signUp");
  }

  // Setting up the Login
  Future<void> logIn(String email, String password) async {
    return _authenticateUser(email, password, "signInWithPassword");
  }

  // Auto Login Functionality
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

// Log Out method
  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // Auto Logout Functionality
  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryTime), logOut);
  }

  // end::Entry
}
