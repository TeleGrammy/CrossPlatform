import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';
import 'package:telegrammy/common/widgets/tapGesture_text_span.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/auth/presentation/view_models/cubit/signup_cubit.dart';

class AccountVerificationView extends StatefulWidget {
  const AccountVerificationView({super.key, required this.email});

  final String email;
  @override
  _AccountVerificationViewState createState() =>
      _AccountVerificationViewState();
}

class _AccountVerificationViewState extends State<AccountVerificationView> {
  late String verificationCode;
  final verificationCodeLength = 6;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              //
              const SizedBox(height: 50),
              const Text('Account\nVerification',
                  style:
                      TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              //
              Text(
                'We have sent Verification Code to ${widget.email}',
                style: const TextStyle(
                  fontSize: 22.0,
                ),
              ),
              const SizedBox(height: 40),

              //pin code field
              PinCodeTextField(
                appContext: context,
                length: verificationCodeLength,
                onCompleted: (value) {
                  verificationCode = value;
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

              //
              TapGestureTextSpan(
                  baseText: "Didn't receive code? ",
                  actionText: 'Send again',
                  onTap: () {}),

              //errors message box
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  if (state is SignUpFailure) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.errorMessage,
                        style: const TextStyle(color: errorColor, fontSize: 16),
                      ),
                    );
                  }
                  return const SizedBox
                      .shrink(); // No error, return empty widget
                },
              ),

              //verify email button
              BlocListener<SignUpCubit, SignUpState>(
                listener: (BuildContext context, SignUpState state) {
                  if (state is VerificationSuccess) {
                    //todo:navigate to the main screen of the app
                  }
                  if (state is VerificationFailure) {
                    print(state.errorMessage);
                  }
                },
                child: RoundedButton(
                    onPressed: () {
                      cubit.emailVerification(widget.email, verificationCode);
                    },
                    buttonTitle: 'Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
