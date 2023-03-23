import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef VoidFunctionWithNoParameter = void Function();

class PopUpAcceptable extends StatelessWidget implements PopUp {
  const PopUpAcceptable({
    Key? key,
    required this.svgIcon,
    required this.color,
    required this.title,
    required this.description,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.leftButtonOnPressed,
    required this.rightButtonOnPressed,
  }) : super(key: key);

  final String svgIcon;
  final Color color;
  final String title;
  final String description;
  final String leftButtonText;
  final String rightButtonText;
  final VoidFunctionWithNoParameter leftButtonOnPressed;
  final VoidFunctionWithNoParameter rightButtonOnPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 256,
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 80,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: SizedBox.square(
                    dimension: 56,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SvgPicture.asset(
                        svgIcon,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const VerticalSpace(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            leftButtonOnPressed();
                          },
                          height: 0,
                          minWidth: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: color,
                            ),
                          ),
                          child: Text(
                            leftButtonText,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                        const HorizontalSpace(8),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              rightButtonOnPressed();
                            },
                            height: 0,
                            minWidth: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            color: color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              rightButtonText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
