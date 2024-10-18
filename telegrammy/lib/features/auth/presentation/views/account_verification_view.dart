import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:telegrammy/common/widgets/rounded_button.dart';
import 'package:telegrammy/common/widgets/tapGesture_text_span.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

class AccountVerificationView extends StatefulWidget {
  const AccountVerificationView({super.key});

  @override
  _AccountVerificationViewState createState() =>
      _AccountVerificationViewState();
}

class _AccountVerificationViewState extends State<AccountVerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(height: 50),
              const Text('Account\nVerification',
                  style:
                      TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              const Text(
                'We have sent Verification Code to john.doe@gmail.com',
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              const SizedBox(height: 40),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) {
                  print(value);
                },
                autoDismissKeyboard: false, // Keep keyboard open for editing
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  activeColor: primaryColor,
                  inactiveColor: primaryColor,
                  selectedColor: secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 55,
                  fieldWidth: 55,
                  activeFillColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TapGestureTextSpan(
                  baseText: "Didn't receive code? ",
                  actionText: 'Send again',
                  onTap: () {}),
              RoundedButton(onPressed: () {}, buttonTitle: 'Verify'),
            ],
          ),
        ),
      ),
    );
  }
}
