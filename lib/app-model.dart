import 'package:flutter/material.dart';
import 'package:auth0/auth0.dart';
import 'package:oauth2_flutter_example/components/user_profile.dart';

class AppModel with ChangeNotifier {
  bool isLogged = false;
  String loginEmail = '';
  String loginPassword = '';

  String code = '';
  String oob_code = '';
  String changePassword = '';

  String signUpEmail = '';
  String signUpPassword = '';

  String errorLogIn = '';
  String errorSignUp = '';

  String dialogMsg = '';

  bool isWaitingForOtpCode = false;
  bool isWaitingForResponse = false;
  bool isMfa = false;
  bool isMfaPhoneAvail = false;
  // bool isMfaEmailAvail = false;

  UserProfile? userProfile;
  Auth0Client? client;
  List<Map<String, dynamic>> factors = List.empty();
  List<Map<String, dynamic>> meta = List.empty();

  void updateUserProfile(dynamic user) {
    if (user['user_metadata'] != null) {
      var d = user['user_metadata'] as Map<String, dynamic>;
      updateUserMetadata(d);
    } else {
      userProfile = UserProfile(
          sub: user['sub'],
          nickname: user['nickname'],
          name: user['name'],
          pictureUrl: Uri.parse(user['picture']),
          updatedAt: DateTime.parse(user['updated_at']),
          email: user['email'],
          isEmailVerified: user['email_verified'],
          accessToken: user['accessToken'],
          mfaToken: user['mfaToken']);
    }
    notifyListeners();
  }

  void setLoginError(String err) {
    errorLogIn = err;
    notifyListeners();
  }

  void setSignUpError(String err) {
    errorSignUp = err;
    notifyListeners();
  }

  void setIsLogged(bool value) {
    isLogged = value;
    notifyListeners();
  }

  void setIsWaiting(bool value) {
    isWaitingForResponse = value;
    notifyListeners();
  }

  void logOut() {
    userProfile = null;
    errorLogIn = '';
    errorSignUp = '';
    isLogged = false;
    notifyListeners();
  }

  void updateFactors(dynamic value) {
    var i = List<Map<String, dynamic>>.empty(growable: true);
    for (var it in value) {
      var it2 = (it as Map<String, dynamic>);
      i.add(it2);
    }
    factors = i;
    notifyListeners();
  }

  void updateUserMetadata(dynamic meta) {
    var i = List<Map<String, dynamic>>.empty(growable: true);
    meta.forEach((key, value) {
      i.add({key: value});
    });
    this.meta = i;
    notifyListeners();
  }

  void setUseMfa(bool value) {
    isMfa = value;
    notifyListeners();
  }

  void updateCode(String value) {
    code = value;
    notifyListeners();
  }

  void setDialogStatus(String value) {
    dialogMsg = value;
    notifyListeners();
  }
}
