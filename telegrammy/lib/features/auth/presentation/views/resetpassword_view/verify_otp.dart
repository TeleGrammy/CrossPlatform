import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerificationPage extends StatefulWidget {
  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  TextEditingController otpController = TextEditingController();
  int secondsRemaining = 60;
  bool enableResend = false;

  void startTimer() {
    if (secondsRemaining > 0) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          secondsRemaining--;
          if (secondsRemaining == 0) {
            enableResend = true;
          }
        });
        startTimer();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void resendCode() {
    setState(() {
      secondsRemaining = 60;
      enableResend = false;
    });
    startTimer();
    // Logic for resending the code goes here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            // Mail icon or image
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.mail_outline, size: 50, color: Colors.blue),
            ),
            SizedBox(height: 20),
            Text(
              "Check your mail",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "We just sent an OTP to your registered\nemail address",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 40),
            // OTP input fields
            PinCodeTextField(
              appContext: context,
              length: 5,
              controller: otpController,
              onChanged: (value) {},
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                activeColor: Colors.blue,
                selectedColor: Colors.blue,
                inactiveColor: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            // Countdown timer and resend option
            Text(
              "00:${secondsRemaining.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: enableResend ? resendCode : null,
              child: Text(
                "Didn’t get a code? Resend",
                style: TextStyle(
                  color: enableResend ? Colors.blue : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
            // Verify button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle OTP verification logic here
                },
                child: Text("Verify OTP"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
