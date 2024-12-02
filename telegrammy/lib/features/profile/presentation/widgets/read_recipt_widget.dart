import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_state.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_state.dart';

class ReadReceiptsOption extends StatefulWidget {
  @override
  _ReadReceiptsOptionState createState() => _ReadReceiptsOptionState();
}

class _ReadReceiptsOptionState extends State<ReadReceiptsOption> {
  @override
  void initState() {
    super.initState();
    // Fetch the current read receipt status when the widget is initialized
    context.read<ReadReceiptCubit>().fetchReadReceiptSetting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReadReceiptCubit, ReadReceiptState>(
      listener: (context, state) {
        if (state is ReadReceiptsError) {
          // Handle any error state, maybe show a Snackbar or error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update read receipt setting')),
          );
        }
      },
      child: BlocBuilder<ReadReceiptCubit, ReadReceiptState>(
        builder: (context, state) {
          bool isReadReceiptsEnabled = false; // Default state
          Color switchThumbColor = Colors.grey; // Default thumb color
          Color switchTrackColor = Colors.grey.withOpacity(0.5); // Default track color

          // Check current state
          if (state is ReadReceiptsLoaded) {
            isReadReceiptsEnabled = state.isEnabled;
            // Update switch colors based on state
            switchThumbColor = isReadReceiptsEnabled ? Colors.green : Colors.grey;
            switchTrackColor = isReadReceiptsEnabled ? Colors.green.withOpacity(0.5) : Colors.grey.withOpacity(0.5);
          } else if (state is ReadReceiptsError) {
            // Handle error state (optional)
            isReadReceiptsEnabled = false;
            switchThumbColor = Colors.grey;
            switchTrackColor = Colors.grey.withOpacity(0.5);
          }

          return Column(
            children: [
              Container(
                key: const ValueKey('ReadReceiptsOption'),
                color: primaryColor,
                child: ListTile(
                  leading: Icon(Icons.check_box, color: Colors.green),
                  title: Text(
                    'Read Receipts',
                    style: textStyle17.copyWith(fontWeight: FontWeight.w400),
                  ),
                  trailing: Switch(
                    value: isReadReceiptsEnabled,
                    onChanged: (value) async {
                      // Optimistically update the UI first
                      context.read<ReadReceiptCubit>().updateReadReceiptSetting(value);

                      try {
                        // Update the read receipt setting via API
                        await context.read<ReadReceiptCubit>().fetchReadReceiptSetting();
                      } catch (e) {
                        // If there is an error, show a message and revert UI
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update read receipt setting')),
                        );
                        context.read<ReadReceiptCubit>().updateReadReceiptSetting(!value);
                        // Ensure we fetch the updated state again to reflect the changes
                        context.read<ReadReceiptCubit>().fetchReadReceiptSetting();
                      }
                    },
                    activeColor: switchThumbColor,
                    inactiveThumbColor: switchThumbColor,
                    inactiveTrackColor: switchTrackColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
