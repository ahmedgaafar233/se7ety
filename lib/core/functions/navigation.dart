import 'package:flutter/material.dart';

pushTo(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

pushReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

pushNamed(BuildContext context, String routeName, {Object? arguments}) {
  Navigator.pushNamed(context, routeName, arguments: arguments);
}

pushReplacementNamed(BuildContext context, String routeName, {Object? arguments}) {
  Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
}

pushAndRemoveUntil(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}

pop(BuildContext context) {
  Navigator.pop(context);
}
