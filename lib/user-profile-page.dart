import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:oauth2_flutter_example/app-model.dart';
import 'package:oauth2_flutter_example/components/auth_button.dart';
import 'package:oauth2_flutter_example/components/user.dart';
import 'package:oauth2_flutter_example/const_values.dart';
import 'package:oauth2_flutter_example/mfa_dialog.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  AppModel? model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFactors();
      getMetadata();
    });
  }

  void getFactors() async {
    var factors =
        await model?.client?.getAuthenticators(model!.userProfile!.mfaToken!);
    model?.updateFactors(factors);
  }

  void getMetadata() async {
    var meta = await model?.client?.getUser(
        id: model!.userProfile!.sub, token: model!.userProfile!.accessToken!);
    model?.updateUserProfile(meta);
  }

  void setMfa(bool value) async {
    var userProfile = await model?.client?.updateUser(
        id: model!.userProfile!.sub,
        token: model!.userProfile!.accessToken!,
        metadata: {'use_mfa': value});
    model?.setUseMfa(value);
    model?.updateUserProfile(userProfile);
  }

  void deleteMfa(Map<String, dynamic> mfa) async {
    await model?.client?.delAuthenticator(
        token: model!.userProfile!.mfaToken!, authId: mfa['id']);
    getFactors();
  }

  void logOut() {
    model?.client?.logout();
    model?.logOut();
  }

  String mapToText(Map<String, dynamic> map) {
    var res = '';
    map.forEach((key, value) {
      if (res.isNotEmpty) {
        res += ',      ';
      }
      res += '$key=${value.toString()}';
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      model = Provider.of<AppModel>(context, listen: true);
      return Scaffold(
          body: Container(
              color: Theme.of(context).colorScheme.background,
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                  child: Column(children: [
                model?.userProfile != null
                    ? UserWidget(user: model?.userProfile)
                    : Container(),
                // MFA factors
                model?.isMfaPhoneAvail == false
                    ? Column(children: [
                        Container(
                            constraints: const BoxConstraints(),
                            alignment: Alignment.center,
                            color: Theme.of(context).secondaryHeaderColor,
                            padding: const EdgeInsets.all(4),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Use MFA'),
                                  FlutterSwitch(
                                      width: 60.0,
                                      height: 30.0,
                                      valueFontSize: 12.0,
                                      toggleSize: 20.0,
                                      value: model?.isMfa ?? false,
                                      borderRadius: 90.0,
                                      activeTextFontWeight: FontWeight.w300,
                                      inactiveTextFontWeight: FontWeight.w300,
                                      padding: 4,
                                      activeText: 'On',
                                      inactiveText: 'Off',
                                      showOnOff: true,
                                      onToggle: (enabled) {
                                        setMfa(enabled);
                                      })
                                ])),
                        const Align(
                            alignment: Alignment.centerLeft,
                            heightFactor: 2,
                            child: Text('Authenticators',
                                textAlign: TextAlign.start)),
                        Card(
                          color: Theme.of(context).secondaryHeaderColor,
                          child: Consumer<AppModel>(builder: (ctx, model_, _) {
                            return ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: model_.factors.length,
                                itemBuilder: (context, index) {
                                  return showMapItem(
                                      mapToText(model_.factors[index]),
                                      onDelete: () {
                                    deleteMfa(model_.factors[index]);
                                  });
                                });
                          }),
                        ),
                        const Align(
                            alignment: Alignment.centerLeft,
                            heightFactor: 2,
                            child:
                                Text('Metadata', textAlign: TextAlign.start)),
                        Card(
                          color: Theme.of(context).secondaryHeaderColor,
                          child: Consumer<AppModel>(builder: (ctx, model_, _) {
                            return ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: model_.meta.length,
                                itemBuilder: (context, index) {
                                  return showMapItem(
                                      mapToText(model_.meta[index]));
                                });
                          }),
                        )
                      ])
                    : Container(),
                AuthButton(
                  text: 'Add MFA',
                  alignment: Alignment.center,
                  iconData: CupertinoIcons.add,
                  onPressed: () {
                    showAddMfaDialog(context);
                  },
                ),
                AuthButton(
                    text: 'Logout',
                    alignment: Alignment.bottomCenter,
                    iconData: CupertinoIcons.arrow_left_square,
                    onPressed: () {
                      logOut();
                      Navigator.popUntil(
                          context, ModalRoute.withName('/login'));
                    }),
                const SizedBox(height: 40),
              ]))));
    });
  }

  Widget showMapItem(String factors, {Function? onDelete}) {
    return Container(
        height: ConstValues.lineHeight,
        color: Theme.of(context).secondaryHeaderColor,
        child: Row(children: [
          Expanded(
              child: SelectableText(factors,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      backgroundColor: Theme.of(context).dividerColor))),
          if (onDelete != null)
            AuthButton(
              alignment: Alignment.center,
              text: 'Delete',
              onPressed: () {
                onDelete.call();
              },
            )
        ]));
  }

  void showAddMfaDialog(BuildContext context) {
    model?.setDialogStatus('Enter values');
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
            contentPadding: EdgeInsets.zero, content: MfaDialog());
      },
    );
  }
}
