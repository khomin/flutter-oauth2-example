import 'package:flutter/material.dart';
import 'package:oauth2_flutter_example/app-model.dart';
import 'package:oauth2_flutter_example/components/auth_button.dart';
import 'package:oauth2_flutter_example/components/auth_msg_panel.dart';
import 'package:oauth2_flutter_example/components/auth_field.dart';
import 'package:oauth2_flutter_example/const_values.dart';
import 'package:provider/provider.dart';

class LoginMfaTryPage extends StatefulWidget {
  const LoginMfaTryPage({super.key});

  @override
  State<LoginMfaTryPage> createState() => _LoginMfaTryPageState();
}

class _LoginMfaTryPageState extends State<LoginMfaTryPage> {
  AppModel? model;
  String? mfaToken;
  String? oobCode;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      mfaToken = args['mfa_token'] ?? '';
      oobCode = args['oob_code'] ?? '';
    });
  }

  void verifyCodeWithMFA(String code) async {
    try {
      var userAuth = await model!.client!.verifyWithMfa(
          mfaToken: mfaToken!, oobCode: oobCode!, bindingCode: code);
      var user = await model?.client
          ?.getUserInfo({'access_token': userAuth.accessToken});
      model?.setIsWaiting(false);
      model?.setIsLogged(true);
      user['accessToken'] = userAuth.accessToken;
      user['mfaToken'] = mfaToken;
      user['refreshToken'] = userAuth.refreshToken;
      model?.updateUserProfile(user);
      if (mounted) {
        Navigator.pushNamed(context, '/user_page');
      }
    } catch (ex) {
      model?.setDialogStatus(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String code = '';
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
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AuthField(
                            hint: 'Enter code',
                            onChanged: (value) {
                              code = value;
                            },
                          ),
                          AuthButton(
                            text: 'Ok',
                            onPressed: () {
                              verifyCodeWithMFA(code);
                            },
                          )
                        ]),
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
