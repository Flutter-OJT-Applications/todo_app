import 'package:flutter/material.dart';
/// #CommonWidget
///
/// The common widget components and it's styles
///
/// @author SaiZawMyint
class CommonWidget {

  /// The primary button style
  static ButtonStyle primaryButtonStyle() => ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.blue,
      );

  /// The secondary button style
  static ButtonStyle secondaryButtonStyle() => ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    backgroundColor: Colors.black38,
  );

  /// The basic input style
  static InputDecoration inputStyle({String? placeholder}) => InputDecoration(
    hintText: placeholder??"Enter text",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    )
  );

  /// The default title text style
  static TextStyle titleText() => const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  static TextStyle secondaryTitleText() => const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}
