import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../enums.dart' as enums;

class SignInDialog extends StatefulWidget {
  final String accountType;
  final Function password;
  final enums.signInOptions signInOption;

  const SignInDialog(
      {Key? key,
      required this.accountType,
      required this.signInOption,
      required this.password})
      : super(key: key);

  @override
  _SignInDialogState createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('This email already exists'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.accountType == 'password'
                ? 'Would you like to link your account using ${widget.signInOption.name} login?'
                : 'After you sign in your facebook you will need to sign into your gmail to link your accounts',
          ),
          if (widget.accountType == 'password') ...[
            kSizedBoxH25,
            const Text('Enter your IUNGO password:')
          ],
          kSizedBoxH25,
          if (widget.accountType == 'password') ...[
            TextField(
              decoration: const InputDecoration(
                labelText: 'password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  widget.password(value);
                });
              },
            ),
          ],
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            return;
          },
          child: Text(
            widget.accountType == 'password' ? 'No,Cancel' : 'Cancel',
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            widget.accountType == 'password'
                ? 'Yes, Link Account'
                : 'Okay, Continue',
          ),
        ),
      ],
    );
  }
}
