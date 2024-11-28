import 'package:flutter/material.dart';

class logo extends StatelessWidget {
  const logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: 121,
      height: MediaQuery.of(context).size.height * 0.2,
    );
  }
}
