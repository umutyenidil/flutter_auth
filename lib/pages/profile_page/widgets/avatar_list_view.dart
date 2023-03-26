import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class AvatarListView extends StatefulWidget {
  const AvatarListView({
    super.key,
    required this.getImageAsByteList,
  });

  final Function getImageAsByteList;

  @override
  State<AvatarListView> createState() => _AvatarListViewState();
}

class _AvatarListViewState extends State<AvatarListView> {
  late final List<String> avatarImages;
  late int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 128 + 8 + 32,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 128,
            color: Colors.blue.withOpacity(0.5),
            child: PageView.builder(
              onPageChanged: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              itemCount: avatarImages.length,
              controller: PageController(
                viewportFraction: 0.5,
                initialPage: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                var image = avatarImages[index];
                double _scale = selectedIndex == index ? 1.0 : 0.7;
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 200),
                  tween: Tween(begin: _scale, end: _scale),
                  curve: Curves.ease,
                  builder: (BuildContext context, double value, Widget? child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        key: UniqueKey(),
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          image,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          VerticalSpace(8),
          SizedBox(
            height: 32,
            child: MaterialButton(
              onPressed: () async {
                if (selectedIndex == 0) {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                  Uint8List imageAsBytes = await photo!.readAsBytes();
                  widget.getImageAsByteList(imageAsBytes);
                } else if (selectedIndex == 1) {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                } else if (selectedIndex == 2) {
                  print('profil fotografini sil');
                } else {
                  print('avatar image');
                  ;
                }
              },
              minWidth: 0,
              height: 0,
              color: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusConstants.allCorners10,
              ),
              child: Text(
                'Select',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    avatarImages = [
      IconPathConstants.cameraIcon,
      IconPathConstants.galleryIcon,
      IconPathConstants.userIcon,
      IconPathConstants.twitterLogoIcon,
      IconPathConstants.facebookLogoIcon,
      IconPathConstants.googleLogoIcon,
    ];
    selectedIndex = 2;
  }
}
