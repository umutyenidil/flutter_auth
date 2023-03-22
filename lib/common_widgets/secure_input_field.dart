import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/string_error_constants.dart';
import 'package:flutter_auth/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef SecureInputFieldController = void Function(String value);

class SecureInputField extends StatefulWidget {
  const SecureInputField({
    Key? key,
    required this.node,
    this.nextNode,
    this.textInputAction,
    required this.hintText,
    required this.inputType,
    required this.regularExpression,
    required this.errorMessage,
    required this.svgIcon,
    required this.getValue,
  }) : super(key: key);

  final FocusNode node;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final String hintText;
  final TextInputType inputType;
  final String regularExpression;
  final String errorMessage;
  final String svgIcon;
  final SecureInputFieldController getValue;

  @override
  State<SecureInputField> createState() => _SecureInputFieldState();
}

class _SecureInputFieldState extends State<SecureInputField> {
  late bool _hasFocus;
  late bool _hasError;
  late Color _activeColor;
  late bool _isObsecured;

  @override
  void initState() {
    super.initState();

    _hasFocus = false;
    _hasError = false;
    _activeColor = Colors.red;
    _isObsecured = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(widget.node);
            // widget.node.requestFocus();
          },
          child: Container(
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
                const HorizontalSpace(8),
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
                const HorizontalSpace(8),
                Expanded(
                  child: Focus(
                    focusNode: widget.node,
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _hasFocus = hasFocus;
                      });
                    },
                    child: TextField(
                      obscureText: _isObsecured,
                      autocorrect: false,
                      keyboardType: widget.inputType,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        _hasError = !RegExp(widget.regularExpression).hasMatch(value);
                        setState(() {
                          _activeColor = _hasError ? Colors.red : Colors.green;
                        });
                        if (_hasError) {
                          widget.getValue(StringErrorConstants.error);
                        } else {
                          widget.getValue(value);
                        }
                      },
                      onSubmitted: (value) {
                        widget.node.unfocus();
                        widget.nextNode?.requestFocus();
                      },
                      textInputAction: widget.textInputAction,
                    ),
                  ),
                ),
                SizedBox.square(
                  dimension: 32,
                  child: MaterialButton(
                    minWidth: 0,
                    height: 0,
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusConstants.allCorners10,
                    ),
                    child: SvgPicture.asset(
                      _isObsecured ? IconPathConstants.eyeIcon : IconPathConstants.eyeSlashIcon,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObsecured = !_isObsecured;
                      });
                    },
                  ),
                ),
                const HorizontalSpace(8),
              ],
            ),
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
              overflow: TextOverflow.ellipsis,
              color: (_hasError) ? Colors.red : Colors.transparent,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
