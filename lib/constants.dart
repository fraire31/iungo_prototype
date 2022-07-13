import 'package:flutter/material.dart';

const kScreenPadding = EdgeInsets.all(20.0);

const double kMainFontSize = 16;

const kXLargeBoldText = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w700,
);

const kXLargeText = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w500,
);

const kLargeBoldText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
);

const kLargeText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);

//use for labels sectioning off input fields as well
const kMediumBoldText = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

const kMediumText = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

const kRegularBoldText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
);

const kRegularText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const kRegularThinText = TextStyle(
  fontSize: 16,
);

const kLightGrey = Color.fromRGBO(222, 222, 224, 1);

const kButtonText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const kGreyButtonText = TextStyle(
  fontWeight: FontWeight.w600,
  letterSpacing: .25,
  color: Colors.black54,
);

const kMainTextInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(5.0),
  border: OutlineInputBorder(),
);

TextStyle kActiveOption = kButtonText.copyWith(
  color: kPrimaryColor,
);

TextStyle kOption = kButtonText.copyWith(
  color: Colors.grey,
);

const kSizedBoxH25 = SizedBox(height: 25);
const kSizedBoxH10 = SizedBox(height: 10);
const kSizedBoxW10 = SizedBox(width: 10);

Color kPrimaryColor = const Color.fromRGBO(34, 175, 254, 1);
Color kPrimaryDarkColor = const Color.fromRGBO(2, 136, 209, 1);
//2,100,209
Color kSecondaryColor = const Color.fromRGBO(213, 19, 0, 1);
