import 'package:flutter/material.dart';
import 'package:oauth2_flutter_example/components/user_profile.dart';

class UserWidget extends StatelessWidget {
  final UserProfile? user;
  final Function? onPressedChangePass;
  final Function? onChangedPassword;

  const UserWidget(
      {required this.user,
      this.onPressedChangePass,
      this.onChangedPassword,
      final Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pictureUrl = user?.pictureUrl;
    return Container(
        constraints: const BoxConstraints(),
        alignment: Alignment.center,
        color: Theme.of(context).secondaryHeaderColor,
        child:
            // id, name, email, email verified, updated_at
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          if (pictureUrl != null)
            CircleAvatar(
              radius: 44,
              child: ClipOval(child: Image.network(pictureUrl.toString())),
            ),
          Expanded(
              child: Column(children: [
            Card(
                child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                UserEntryWidget(propertyName: 'id', propertyValue: user?.sub),
                UserEntryWidget(
                    propertyName: 'name', propertyValue: user?.name),
                UserEntryWidget(
                    propertyName: 'email', propertyValue: user?.email),
                UserEntryWidget(
                    propertyName: 'isEmailVerified',
                    propertyValue: user?.isEmailVerified.toString()),
                UserEntryWidget(
                    propertyName: 'phoneNumber',
                    propertyValue: user?.phoneNumber.toString()),
                UserEntryWidget(
                    propertyName: 'isPhoneNumberVerified',
                    propertyValue: user?.isPhoneNumberVerified.toString()),
                UserEntryWidget(
                    propertyName: 'updatedAt',
                    propertyValue: user?.updatedAt?.toIso8601String())
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                UserEntryWidget(
                    propertyName: 'address',
                    propertyValue: user?.address.toString()),
                UserEntryWidget(
                    propertyName: 'birthdate',
                    propertyValue: user?.birthdate.toString()),
                UserEntryWidget(
                    propertyName: 'customClaims',
                    propertyValue: user?.customClaims.toString()),
                UserEntryWidget(
                    propertyName: 'familyName',
                    propertyValue: user?.familyName.toString()),
                UserEntryWidget(
                    propertyName: 'gender',
                    propertyValue: user?.gender.toString()),
                UserEntryWidget(
                    propertyName: 'givenName',
                    propertyValue: user?.givenName.toString()),
                UserEntryWidget(
                    propertyName: 'locale',
                    propertyValue: user?.locale.toString()),
              ])
            ]))
          ]))
        ]));
  }
}

class UserEntryWidget extends StatelessWidget {
  final String propertyName;
  final String? propertyValue;

  const UserEntryWidget(
      {required this.propertyName, required this.propertyValue, final Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4),
        color: Theme.of(context).secondaryHeaderColor,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SelectableText(propertyName),
            SelectableText(propertyValue ?? '')
          ],
        ));
  }
}
