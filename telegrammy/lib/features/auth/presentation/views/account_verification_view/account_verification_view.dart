import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/widgets/tapgesture_text_span.dart';
import 'package:telegrammy/features/auth/presentation/view_models/signup_cubit/signup_cubit.dart';

class AccountVerificationView extends StatefulWidget {
  const AccountVerificationView({super.key});

  @override
  _AccountVerificationViewState createState() =>
      _AccountVerificationViewState();
}

class _AccountVerificationViewState extends State<AccountVerificationView> {
  late String verificationCode;
  final verificationCodeLength = 6;
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final emailValue = await getit.get<TokenStorageService>().getEmail();
    setState(() {
      email = emailValue!;
      print(email);
    });
  }

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
                'We have sent Verification Code to ${email}',
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
              BlocListener<SignUpCubit, SignUpState>(
                listener: (context, state) {},
                child: TapGestureTextSpan(
                    baseText: "Didn't receive code? ",
                    actionText: 'Send again',
                    onTap: () {
                      context
                          .read<SignUpCubit>()
                          .resendEmailVerification(email);
                    }),
              ),

              //errors message box
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  if (state is VerificationFailure) {
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
                    cubit.emailVerification(email, verificationCode);
                  },
                  buttonTitle: 'Verify',
                  buttonKey: Key('AccountVerificationButton'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
