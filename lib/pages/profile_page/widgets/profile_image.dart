import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_auth/models/user_model.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    super.key,
  });

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 128,
      child: GestureDetector(
        onTap: () async {},
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 3),
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
