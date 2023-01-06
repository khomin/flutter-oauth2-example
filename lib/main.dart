import 'package:flutter/material.dart';
import 'package:oauth2_flutter_example/app-model.dart';
import 'package:oauth2_flutter_example/login-mfa-page.dart';
import 'package:oauth2_flutter_example/login-mfa-try-page.dart';
import 'package:oauth2_flutter_example/login-page.dart';
import 'package:oauth2_flutter_example/signup-page.dart';
import 'package:oauth2_flutter_example/user-profile-page.dart';
import 'package:provider/provider.dart';
import 'package:auth0/auth0.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppModel>(create: (_) => AppModel()),
        ],
        builder: (context, child) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.grey,
            ),
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginPage(),
              '/login_mfa_select': (context) => const LoginMfaPage(),
              '/login_mfa_try': (context) => const LoginMfaTryPage(),
              '/sign_up': (context) => const SignUpPage(),
              '/user_page': (context) => const UserProfilePage(),
            },
            home: Builder(builder: (context) {
              var appModel = Provider.of<AppModel>(context);
              appModel.client = Auth0Client(
                  clientId: dotenv.env['AUTH0_CLIENT_ID']!,
                  domain: dotenv.env['AUTH0_DOMAIN']!,
                  connectTimeout: 10000,
                  sendTimeout: 10000,
                  receiveTimeout: 60000,
                  clientSecret: dotenv.env['AUTH0_SECRET']!,
                  useLoggerInterceptor: true,
                  accessToken: '');
              return const Scaffold();
            })));
  }
}
