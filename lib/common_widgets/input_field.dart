import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/string_error_constants.dart';
import 'package:flutter_auth/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef InputFieldController = void Function(String value);

class InputField extends StatefulWidget {
  const InputField({
    Key? key,
    required this.node,
    required this.hintText,
    required this.inputType,
    required this.regularExpression,
    required this.errorMessage,
    required this.svgIcon,
    required this.getValue,
  }) : super(key: key);

  final FocusNode node;
  final String hintText;
  final TextInputType inputType;
  final String regularExpression;
  final String errorMessage;
  final String svgIcon;
  final InputFieldController getValue;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _hasFocus;
  late bool _hasError;
  late Color _activeColor;

  @override
  void initState() {
    super.initState();

    _hasFocus = false;
    _hasError = false;
    _activeColor = Colors.green;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadiusConstants.allCorners10,
            border: Border.all(
              color: (_hasFocus ? _activeColor : Colors.transparent),
            ),
          ),
          child: Row(
            children: [
              HorizontalSpace(8),
              SizedBox.square(
                dimension: 32,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SvgPicture.asset(
                    widget.svgIcon,
                    color: _hasFocus ? _activeColor : Colors.grey,
                  ),
                ),
              ),
              HorizontalSpace(8),
              Expanded(
                child: Focus(
                  focusNode: widget.node,
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _hasFocus = hasFocus;
                    });
                  },
                  child: TextField(
                    keyboardType: widget.inputType,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _hasError = !RegExp(widget.regularExpression).hasMatch(value);
                      print('$_hasError');
                      setState(() {
                        _activeColor = _hasError ? Colors.red : Colors.green;
                      });
                      if (_hasError) {
                        widget.getValue(StringErrorConstants.error);
                      } else {
                        widget.getValue(value);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const VerticalSpace(4),
        Container(
          width: double.infinity,
          height: 25,
          padding: const EdgeInsets.only(left: 8),
          alignment: Alignment.topLeft,
          child: Text(
            widget.errorMessage,
            maxLines: 2,
            style: TextStyle(
              color: (_hasError) ? Colors.red : Colors.transparent,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
