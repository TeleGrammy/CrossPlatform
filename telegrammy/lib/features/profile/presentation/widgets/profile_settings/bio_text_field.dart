import 'package:flutter/material.dart';

class BioTextField extends StatefulWidget {
  const BioTextField({super.key, required this.controller, this.valueKey});
  final TextEditingController controller;
  final ValueKey<String>? valueKey;

  @override
  State<BioTextField> createState() => _BioTextFieldState();
}

class _BioTextFieldState extends State<BioTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.valueKey,
      controller: widget.controller,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Bio',
        counterText: '', //'${_bioController.text.length}/100',
        suffix: Text(
          '${widget.controller.text.length}/100',
          style: TextStyle(
            color:
                widget.controller.text.length > 100 ? Colors.red : Colors.grey,
          ),
        ),
        labelStyle: TextStyle(color: Colors.grey[400]),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // White underline when enabled
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white), // White underline when focused
        ),
      ),
      maxLength: 100,
      maxLines: 2,
      onChanged: (value) {
        setState(() {}); // Refresh to update counter
      },
      validator: (value) {
        if (value != null && value.length > 100) {
          return 'Bio cannot exceed 100 characters';
        }
        return null;
      },
    );
  }
}
