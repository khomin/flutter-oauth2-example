import 'package:flutter/material.dart';
import 'package:oauth2_flutter_example/app-model.dart';
import 'package:oauth2_flutter_example/components/auth_button.dart';
import 'package:oauth2_flutter_example/components/auth_msg_panel.dart';
import 'package:oauth2_flutter_example/components/auth_field.dart';
import 'package:provider/provider.dart';

class MfaDialog extends StatefulWidget {
  const MfaDialog({super.key});

  @override
  State<MfaDialog> createState() => _MfaDialogState();
}

class _MfaDialogState extends State<MfaDialog> {
  AppModel? model;

  @override
  void initState() {
    super.initState();
  }

  void mfaAssociateRequest(String number) async {
    model?.setDialogStatus('');
    try {
      var res = await model!.client!
          .mfaAssociateRequest(token: model!.userProfile!.mfaToken!, params: {
        'authenticator_types': ['oob'],
        'oob_channels': ["sms"],
        'phone_number': number,
      });
      print('test=${res}');
      model?.setDialogStatus('Code was sent');
      // keep oob_code needed for verification
      model?.oob_code = res['oob_code'];
    } catch (ex) {
      model?.setDialogStatus(ex.toString());
    }
  }

  void verifyCodeWithMFA(String code) async {
    try {
      var res = await model!.client!.verifyWithMfa(
          mfaToken: model!.userProfile!.mfaToken!,
          oobCode: model!.oob_code,
          bindingCode: code);
      model!.setDialogStatus('Sucess!');
      print('test=${res}');
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (ex) {
      model?.setDialogStatus(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      model = Provider.of<AppModel>(context, listen: true);
      String code = '';
      String phone = '';
      return Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(maxWidth: 450, maxHeight: 350),
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AuthField(
                hint: 'Enter phone number',
                onChanged: (value) {
                  phone = value;
                },
              ),
              AuthButton(
                text: 'Ok',
                onPressed: () {
                  mfaAssociateRequest(phone);
                },
              ),
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
              ),
              AuthMsgPanel(
                  error: model?.dialogMsg, visible: model?.dialogMsg.isNotEmpty)
            ],
          ));
    });
  }
}
