import 'package:flutter/material.dart';

Color bgColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Theme.of(context).colorScheme.surface
      : const Color(0xFFFAFAFA);
}
