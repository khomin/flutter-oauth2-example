import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oauth2_flutter_example/api/api-helper.dart';
import 'package:oauth2_flutter_example/app-model.dart';
import 'package:oauth2_flutter_example/components/auth_button.dart';
import 'package:oauth2_flutter_example/components/auth_msg_panel.dart';
import 'package:oauth2_flutter_example/components/auth_field.dart';
import 'package:oauth2_flutter_example/components/auth_field_header.dart';
import 'package:auth0/auth0.dart';
import 'package:oauth2_flutter_example/const_values.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AppModel? model;

  @override
  void initState() {
    super.initState();
  }

  void login() async {
    try {
      model?.setLoginError('');
      model?.setIsWaiting(true);
      if (model!.loginEmail.isEmpty || model!.loginPassword.isEmpty) {
        model?.setLoginError('email or password is empty');
        model?.setIsWaiting(false);
        return;
      }
      var user = await ApiHelper.logIn(
          email: model!.loginEmail,
          password: model!.loginPassword,
          client: model?.client);
      model?.updateUserProfile(user);
    } catch (ex) {
      if (ex is AuthException && ex.name == 'mfa_required') {
        if (!mounted) return;
        Navigator.pushNamed(context, '/login_mfa_select',
            arguments: {'mfa_token': ex.optional});
      } else {
        model?.setLoginError(ex.toString());
      }
      model?.setIsWaiting(false);
      return;
    }
    model?.setIsWaiting(false);
    model?.setIsLogged(true);
    if (!mounted) return;
    Navigator.pushNamed(context, '/user_page');
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      model = Provider.of<AppModel>(context);
      return Scaffold(
          body: Container(
              color: Theme.of(context).colorScheme.background,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Column(children: [
                      Container(
                          height: ConstValues.logoSize,
                          width: ConstValues.logoSize,
                          padding: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: Center(
                            child: Image.asset('assets/flutter-logo.png'),
                          )),
                    ]),
                    const Spacer(),
                    //
                    // email/user
                    AuthFieldHeader(header: 'Login'),
                    AuthField(
                        hint: 'Email',
                        onChanged: (value) {
                          model?.loginEmail = value;
                        }),
                    AuthField(
                        hint: 'Password',
                        onChanged: (value) {
                          model?.loginPassword = value;
                        },
                        onDone: () {
                          login();
                        }),
                    AuthButton(
                        text: 'Log-in',
                        alignment: Alignment.center,
                        iconData: CupertinoIcons.arrow_up_circle,
                        onPressed: () async {
                          login();
                        }),
                    TextButton(
                      child: const Text('Create account'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_up');
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      height: 40,
                      alignment: Alignment.center,
                      child: model?.isWaitingForResponse == true
                          ? CircularProgressIndicator(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer)
                          : Container(),
                    ),
                    AuthMsgPanel(
                        visible: model?.errorLogIn.isNotEmpty,
                        error: model?.errorLogIn)
                  ])));
    });
  }
}
