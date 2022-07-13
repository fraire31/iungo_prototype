import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';

class MedWhiteIconButton extends StatelessWidget {
  final IconData faIcon;
  final Color iconColor;
  final String label;
  final Function onPress;

  const MedWhiteIconButton({
    Key? key,
    required this.faIcon,
    required this.iconColor,
    required this.label,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        maximumSize: MaterialStateProperty.all(
          Size((MediaQuery.of(context).size.width * .75), double.infinity),
        ),
      ),
      onPressed: () {
        onPress();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: FaIcon(
                faIcon,
                color: iconColor,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: kGreyButtonText,
              ),
            )
          ],
        ),
      ),
    );
  }
}
