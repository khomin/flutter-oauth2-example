import 'dart:ffi';

import 'package:auth0/auth0.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiHelper {
  static Future<dynamic> logIn(
      {String? email, String? password, Auth0Client? client}) async {
    assert(email != null && password != null && client != null);
    var userAuth = await client?.passwordGrant({
      'username': email!,
      'password': password!,
      'scope':
          'openid profile email read:current_user update:current_user_metadata',
      'audience': "https://${dotenv.env['AUTH0_DOMAIN']}/api/v2/"
    });
    var user =
        await client?.getUserInfo({'access_token': userAuth!.accessToken});
    var mfaAuth = await client?.passwordGrant({
      'username': email!,
      'password': password!,
      'grant_type': 'password',
      'scopes':
          'openid profile email read:current_user update:current_user_metadata enroll read:authenticators remove:authenticators read:users update:users_app_metadata',
      "audience": "https://${dotenv.env['AUTH0_DOMAIN']}/mfa/",
    });
    user['accessToken'] = userAuth?.accessToken;
    user['mfaToken'] = mfaAuth?.accessToken;
    user['refreshToken'] = userAuth?.refreshToken;
    return user;
  }
}
