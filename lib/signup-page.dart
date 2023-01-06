import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oauth2_flutter_example/api/api-helper.dart';
import 'package:oauth2_flutter_example/app-model.dart';
import 'package:oauth2_flutter_example/components/auth_button.dart';
import 'package:oauth2_flutter_example/components/auth_msg_panel.dart';
import 'package:oauth2_flutter_example/components/auth_field.dart';
import 'package:oauth2_flutter_example/components/auth_field_header.dart';
import 'package:oauth2_flutter_example/const_values.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  AppModel? model;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> signUp() async {
    dynamic user;
    model?.setSignUpError('');
    model?.setIsWaiting(true);
    if (model!.signUpEmail.isEmpty || model!.signUpPassword.isEmpty) {
      model?.setLoginError('email or password is empty');
      model?.setIsWaiting(false);
      return false;
    }
    try {
      var signRes = await model?.client?.createUser({
        "email": model!.signUpEmail,
        "connection": "Username-Password-Authentication",
        "password": model!.signUpPassword
      });
      user = await ApiHelper.logIn(
          email: model!.signUpEmail,
          password: model!.signUpPassword,
          client: model?.client);
      model?.updateUserProfile(user);
      print('test=${signRes}');
    } catch (ex) {
      model?.setSignUpError(ex.toString());
      model?.setIsWaiting(false);
      return null;
    }
    model?.setIsWaiting(false);
    model?.setIsLogged(true);
    if (!mounted) return;
    Navigator.pushNamed(context, '/user_page');
    return user;
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
                    AuthFieldHeader(header: 'SignUp'),
                    AuthField(
                        hint: 'Email',
                        onChanged: (value) {
                          model?.signUpEmail = value;
                        }),
                    AuthField(
                        hint: 'Password',
                        onChanged: (value) {
                          model?.signUpPassword = value;
                        },
                        onDone: () {
                          signUp();
                        }),
                    AuthButton(
                        text: 'Ok',
                        alignment: Alignment.center,
                        iconData: CupertinoIcons.arrow_up_circle,
                        onPressed: () async {
                          signUp();
                        }),
                    TextButton(
                      child: const Text('Back to login'),
                      onPressed: () {
                        Navigator.pop(context);
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
                        visible: model?.errorSignUp.isNotEmpty,
                        error: model?.errorSignUp),
                  ])));
    });
  }
}
