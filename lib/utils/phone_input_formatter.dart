import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText =newValue.text.replaceAll(RegExp(r'\D'), '');

    const mask = '(***) ***-**-**';
    final buffer = StringBuffer();
    int maskPosition = 0;
    int newValuePosition = 0;
    int textLengthBefore = oldValue.text.replaceAll(RegExp(r'\D'), '').length;
    int textLengthAfter = newText.length;
    bool backspace =textLengthBefore >textLengthAfter;

    while (maskPosition < mask.length && newValuePosition < newText.length) {
      if (mask[maskPosition] == '*') {
        buffer.write(newText[newValuePosition]);
        newValuePosition++;
      } else {
        buffer.write(mask[maskPosition]);
      }
      maskPosition++;
    }

    if (newValuePosition < mask.length) {
      buffer.write(mask.substring(maskPosition));
    }

    int selectionIndex;
    if (backspace) {
      selectionIndex = buffer.toString().lastIndexOf(newText.substring(0, newValuePosition)) + newValuePosition;
    } else {
      selectionIndex = buffer.toString().indexOf('*', newValuePosition);
      if (selectionIndex == -1) selectionIndex = mask.length;
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  bool isPhoneValid(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    return digitsOnly.length == 10;
  }
}