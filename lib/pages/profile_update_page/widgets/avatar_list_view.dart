import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/image_path_constants.dart';
import 'package:flutter_auth/mixins/image_storage_mixin.dart';
import 'package:flutter_auth/pages/create_profile_page/widgets/select_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          SizedBox(
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
                    padding: const EdgeInsets.all(32),
                    decoration: const BoxDecoration(
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

                double scale = selectedIndex == index ? 1.0 : 0.7;
                return TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 200),
                  tween: Tween(begin: scale, end: scale),
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
          const VerticalSpace(8),
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
