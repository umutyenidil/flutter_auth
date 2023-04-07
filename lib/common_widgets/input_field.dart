import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/input_values/input_field_value.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef InputFieldController = void Function(InputFieldValue? value);

class InputField extends StatefulWidget {
  const InputField({
    Key? key,
    required this.node,
    this.nextNode,
    this.textInputAction,
    required this.hintText,
    required this.inputType,
    required this.regularExpression,
    required this.errorMessage,
    this.svgIcon,
    required this.getValue,
    this.initialValue,
  }) : super(key: key);

  final FocusNode node;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final String hintText;
  final TextInputType inputType;
  final String regularExpression;
  final String errorMessage;
  final String? svgIcon;
  final InputFieldController getValue;
  final String? initialValue;

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
    _activeColor = Colors.red;
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
          },
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: Material(
              color: Colors.grey.shade300,
              shape: StadiumBorder(
                side: BorderSide(
                  color: (_hasFocus ? _activeColor : Colors.transparent),
                ),
              ),
              child: Row(
                children: [
                  const HorizontalSpace(16),
                  (widget.svgIcon == null)
                      ? const SizedBox()
                      : SizedBox.square(
                          dimension: 32,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SvgPicture.asset(
                              widget.svgIcon!,
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
                      child: TextFormField(
                        initialValue: widget.initialValue,
                        key: widget.key,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
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
                            widget.getValue(
                              InputFieldValue(
                                value: value,
                                status: InputFieldStatusEnum.notMatched,
                              ),
                            );
                          } else {
                            widget.getValue(
                              InputFieldValue(
                                value: value,
                                status: InputFieldStatusEnum.matched,
                              ),
                            );
                          }
                        },
                        onFieldSubmitted: (value) {
                          widget.node.unfocus();
                          widget.nextNode?.requestFocus();
                        },
                        textInputAction: widget.textInputAction,
                      ),
                    ),
                  ),
                  const HorizontalSpace(16),
                ],
              ),
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
              color: (_hasError) ? Colors.red : Colors.transparent,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
