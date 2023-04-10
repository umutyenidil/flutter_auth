import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up.dart';
import 'package:flutter_auth/common_widgets/secure_input_field.dart';
import 'package:flutter_auth/constants/color_constants.dart';
import 'package:flutter_auth/constants/error_text_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/regular_expression_constants.dart';

class PopUpInput extends StatefulWidget implements PopUp {
  const PopUpInput({Key? key}) : super(key: key);

  @override
  State<PopUpInput> createState() => _PopUpInputState();
}

class _PopUpInputState extends State<PopUpInput> {
  late SecureInputFieldValue value;

  @override
  void initState() {
    super.initState();

    value = SecureInputFieldValue(
      value: '',
      status: SecureInputFieldStatusEnum.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
        width: 256,
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SecureInputField(
              node: FocusNode(),
              hintText: 'Your password to confirm',
              inputType: TextInputType.text,
              regularExpression: RegularExpressionConstants.everything,
              errorMessage: ErrorTextConstants.emptyErrorText,
              svgIcon: IconPathConstants.lockIcon,
              getValue: (SecureInputFieldValue value) {
                this.value = value;
              },
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Colors.green,
                child: Text('Accept'),
                onPressed: () {
                  Navigator.of(context).pop(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<SecureInputFieldValue> showPopUpInput(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: ColorConstants.popUpBarrierColor,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 2,
          sigmaX: 2,
        ),
        child: const Center(
          child: PopUpInput(),
        ),
      );
    },
  );
}
