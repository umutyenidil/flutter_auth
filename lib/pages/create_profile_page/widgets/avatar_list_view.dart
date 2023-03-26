import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/image_path_constants.dart';
import 'package:flutter_auth/extensions/bool_extensions.dart';
import 'package:flutter_auth/mixins/image_storage_mixin.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/pages/create_profile_page/widgets/select_button.dart';
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

class _AvatarListViewState extends State<AvatarListView> with ImageStorage {
  late PageController _pageController;
  late final List<String> avatarImages;
  late int selectedIndex;
  Uint8List? currentPhoto;

  @override
  void initState() {
    super.initState();
    widget.getImageAsByteList(null);

    avatarImages = [
      IconPathConstants.cameraIcon,
      IconPathConstants.galleryIcon,
      IconPathConstants.circleUserIcon,
      ImagePathConstants.avatar1Image,
      ImagePathConstants.avatar2Image,
      ImagePathConstants.avatar3Image,
      ImagePathConstants.avatar4Image,
      ImagePathConstants.avatar5Image,
      ImagePathConstants.avatar6Image,
      ImagePathConstants.avatar7Image,
      ImagePathConstants.avatar8Image,
      ImagePathConstants.avatar9Image,
      ImagePathConstants.avatar10Image,
      ImagePathConstants.avatar11Image,
      ImagePathConstants.avatar12Image,
      ImagePathConstants.avatar13Image,
      ImagePathConstants.avatar14Image,
      ImagePathConstants.avatar15Image,
      ImagePathConstants.avatar16Image,
      ImagePathConstants.avatar17Image,
      ImagePathConstants.avatar18Image,
      ImagePathConstants.avatar19Image,
      ImagePathConstants.avatar20Image,
      ImagePathConstants.avatar21Image,
      ImagePathConstants.avatar22Image,
      ImagePathConstants.avatar23Image,
      ImagePathConstants.avatar24Image,
      ImagePathConstants.avatar25Image,
      ImagePathConstants.avatar26Image,
      ImagePathConstants.avatar27Image,
      ImagePathConstants.avatar28Image,
      ImagePathConstants.avatar29Image,
      ImagePathConstants.avatar30Image,
      ImagePathConstants.avatar31Image,
      ImagePathConstants.avatar32Image,
      ImagePathConstants.avatar33Image,
      ImagePathConstants.avatar34Image,
      ImagePathConstants.avatar35Image,
      ImagePathConstants.avatar36Image,
      ImagePathConstants.avatar37Image,
      ImagePathConstants.avatar38Image,
      ImagePathConstants.avatar39Image,
      ImagePathConstants.avatar40Image,
      ImagePathConstants.avatar41Image,
      ImagePathConstants.avatar42Image,
      ImagePathConstants.avatar43Image,
      ImagePathConstants.avatar44Image,
      ImagePathConstants.avatar45Image,
      ImagePathConstants.avatar46Image,

    ];
    selectedIndex = 2;
    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: 2,
    );
  }

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
            child: PageView.builder(
              onPageChanged: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              itemCount: avatarImages.length,
              controller: _pageController,
              itemBuilder: (BuildContext context, int index) {
                Widget? listItem;
                if ([0, 1].contains(index)) {
                  listItem = Container(
                    width: 100,
                    height: 100,
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(avatarImages[index]),
                  );
                } else if (index == 2) {
                  listItem = (currentPhoto == null)
                      ? SvgPicture.asset(avatarImages[2])
                      : SizedBox.square(
                          dimension: 120,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            foregroundImage: MemoryImage(currentPhoto!),
                          ),
                        );
                } else {
                  listItem = SizedBox.square(
                    dimension: 120,
                    child: Image.asset(
                      avatarImages[index],
                    ),
                  );
                }

                double _scale = selectedIndex == index ? 1.0 : 0.7;
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 200),
                  tween: Tween(begin: _scale, end: _scale),
                  curve: Curves.ease,
                  builder: (BuildContext context, double value, Widget? child) {
                    return Transform.scale(
                      scale: value,
                      child: listItem,
                    );
                  },
                );
              },
            ),
          ),
          VerticalSpace(8),
          SizedBox(
            height: 32,
            child: selectedIndex != 2
                ? SelectButton(
                    onPressed: () async {
                      if (_pageController.page == 0) {
                        Uint8List photoBytes = await getPhotoBytesFromCamera();
                        _pageController.jumpToPage(2);
                        setState(() {
                          currentPhoto = photoBytes;
                        });
                      } else if (selectedIndex == 1) {
                        Uint8List imageBytes = await getImageBytesFromGallery();
                        _pageController.jumpToPage(2);
                        setState(() {
                          currentPhoto = imageBytes;
                        });
                      } else {
                        String assetPath = avatarImages[_pageController.page!.toInt()];
                        Uint8List imageBytes = await getImageBytesFromAssets(assetPath: assetPath);
                        _pageController.jumpToPage(2);
                        setState(() {
                          currentPhoto = imageBytes;
                        });
                      }
                      widget.getImageAsByteList(currentPhoto);
                    },
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
