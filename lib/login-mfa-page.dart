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

class LoginMfaPage extends StatefulWidget {
  const LoginMfaPage({super.key});

  @override
  State<LoginMfaPage> createState() => _LoginMfaPageState();
}

class _LoginMfaPageState extends State<LoginMfaPage> {
  AppModel? model;
  String? mfaToken;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      mfaToken = args['mfa_token'] ?? '';
      () async {
        var factors = await model?.client?.getAuthenticators(mfaToken!);
        factors = factors as List<dynamic>;
        factors.removeWhere((element) => element['active'] == false);
        model?.updateFactors(factors);
      }();
    });
  }

  void mfaChallenge(String type, String id) async {
    try {
      var res = await model!.client?.mfaChallenge(
          mfaToken: mfaToken!, challengeType: type, authenticatorId: id);
      print('test=${res}');
      if (mounted) {
        Navigator.pushNamed(context, '/login_mfa_try',
            arguments: {'oob_code': res['oob_code'], 'mfa_token': mfaToken});
      }
    } catch (ex) {
      model?.setDialogStatus(ex.toString());
    }
  }

  void verifyCodeWithMFA(String code) async {
    try {
      var res = await model!.client!.verifyWithMfa(
          mfaToken: mfaToken!, oobCode: model!.oob_code, bindingCode: code);
      model!.setDialogStatus('Sucess!');
      print('test=${res}');
    } catch (ex) {
      model?.setDialogStatus(ex.toString());
    }
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
                    AuthFieldHeader(header: 'Login with MFA'),
                    Card(
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Consumer<AppModel>(builder: (ctx, model_, _) {
                        return ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: model_.factors.length,
                            itemBuilder: (context, index) {
                              return AuthButton(
                                  alignment: Alignment.center,
                                  text:
                                      '${model_.factors[index]['oob_channel']}  ${model_.factors[index]['name']}',
                                  onPressed: () {
                                    mfaChallenge(
                                        model_.factors[index]
                                            ['authenticator_type'],
                                        model_.factors[index]['id']);
                                  });
                            });
                      }),
                    ),
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
