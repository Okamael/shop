import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expiryDate;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get uid {
    return isAuth ? _uid : null;
  }

  Future<void> singUp({required String email, required String password}) async {
    return _authenticate(
        email: email, password: password, urlFragment: 'signUp');
  }

  Future<void> singIn({required String email, required String password}) async {
    return _authenticate(
        email: email, password: password, urlFragment: 'signInWithPassword');
  }

  Future<void> _authenticate(
      {required String email,
      required String password,
      required String urlFragment}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyDOrH29sBMSNGcFb5aPzbRhsa99zccta3g';

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthExceptions(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _uid = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn'])),
      );
    }
    notifyListeners();
  }
}
