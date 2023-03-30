import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/mixins/image_storage_mixin.dart';
import 'package:flutter_auth/extensions/color_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef Fonksiyon = void Function(dynamic currentPhoto);

class AvatarListView extends StatefulWidget {
  const AvatarListView({
    super.key,
    required this.getCurrentPhoto,
  });

  final Fonksiyon getCurrentPhoto;

  @override
  State<AvatarListView> createState() => _AvatarListViewState();
}

class _AvatarListViewState extends State<AvatarListView> with ImageStorage {
  late PageController _pageController;
  late int selectedIndex;
  dynamic currentPhoto;
  late Map<String, dynamic> avatarImageUrlMap;

  @override
  void initState() {
    super.initState();

    widget.getCurrentPhoto(null);

    selectedIndex = 2;
    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteStorageBloc, RemoteStorageState>(
      builder: (context, state) {
        avatarImageUrlMap = (state as StateSuccessfulGetAvatarImageUrlList).avatarImageUrlMap;
        return SizedBox(
          width: double.infinity,
          height: 128 + 8 + 35 + 4 + 4,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 136,
                child: PageView.builder(
                  onPageChanged: (int index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  itemCount: avatarImageUrlMap.length + 2,
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    Widget? listItem;
                    if (index == 0) {
                      listItem = openGalleryButton();
                    } else if (index == 1) {
                      listItem = openCameraButton();
                    } else if (index == 2) {
                      listItem = selectedImage();
                    } else {
                      listItem = avatarImageFromRemoteStorage(
                        url: (avatarImageUrlMap.values.toList())[index - 2],
                      );
                    }

                    double scale = selectedIndex == index ? 1.0 : 0.7;
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 200),
                        tween: Tween(begin: scale, end: scale),
                        curve: Curves.ease,
                        builder: (BuildContext context, double value, Widget? child) {
                          return Transform.scale(
                            scale: value,
                            child: listItem,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const VerticalSpace(8),
              SizedBox(
                child: selectButton(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget selectButton() {
    if (selectedIndex == 2) {
      if (currentPhoto != null) {
        return SizedBox(
          height: 35,
          width: 80,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadiusConstants.allCorners10,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Selected',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } else if (selectedIndex > 2) {
      return SizedBox(
        height: 35,
        width: 80,
        child: MaterialButton(
          onPressed: () async {
            currentPhoto = avatarImageUrlMap.values.toList()[selectedIndex - 2];
            widget.getCurrentPhoto(currentPhoto);

            _pageController.animateToPage(2, duration: Duration(milliseconds: 300 * (selectedIndex - 2)), curve: Curves.ease);
          },
          color: Colors.grey.shade300,
          minWidth: 0,
          height: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusConstants.allCorners10,
          ),
          child: const FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'Select',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: 35,
      width: 80,
    );
  }

  Widget selectedImage() {
    if (currentPhoto is File) {
      return SizedBox.square(
        dimension: 120,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffffffff).randomColor,
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              image: FileImage(currentPhoto),
            ),
          ),
        ),
      );
    }
    if (currentPhoto is String) {
      return SizedBox.square(
        dimension: 120,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffffffff).randomColor,
            image: DecorationImage(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              image: CachedNetworkImageProvider(currentPhoto),
            ),
          ),
        ),
      );
    }

    return SizedBox.square(
      dimension: 120,
      child: SvgPicture.asset(
        IconPathConstants.circleUserIcon,
        color: Color(0xffffffff).randomColor,
      ),
    );
  }

  Widget avatarImageFromRemoteStorage({required String url}) {
    return SizedBox.square(
      dimension: 120,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffffffff).randomColor,
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (BuildContext context, String url) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1,
              ),
            );
          },
          errorWidget: (context, url, error) {
            return SvgPicture.asset(
              IconPathConstants.cancelIcon,
              color: Colors.red,
            );
          },
        ),
      ),
    );
  }

  Widget openCameraButton() {
    return SizedBox.square(
      dimension: 120,
      child: MaterialButton(
        hoverElevation: 4,
        disabledElevation: 2,
        highlightElevation: 1,
        focusElevation: 1,
        onPressed: () async {
          File? photoFile = await getPhotoFileFromCamera();

          if (photoFile == null) {
            PopUpMessage.danger(title: 'Kamera Hatasi', message: 'Bir hata olustu').show(context);
          }

          setState(() {
            currentPhoto = photoFile;
          });
          widget.getCurrentPhoto(currentPhoto);

          _pageController.animateToPage(
            2,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        shape: const CircleBorder(),
        color: Color(0xffffffff).randomColor,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SvgPicture.asset(
            IconPathConstants.cameraIcon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget openGalleryButton() {
    return SizedBox.square(
      dimension: 120,
      child: MaterialButton(
        hoverElevation: 4,
        disabledElevation: 2,
        highlightElevation: 1,
        focusElevation: 1,
        onPressed: () async {
          File? photoFile = await getPhotoFileFromGallery();

          if (photoFile == null) {
            PopUpMessage.danger(title: 'Galeri Hatasi', message: 'Bir hata olustu').show(context);
          }

          setState(() {
            currentPhoto = photoFile;
          });
          widget.getCurrentPhoto(currentPhoto);

          _pageController.animateToPage(
            2,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        shape: const CircleBorder(),
        color: Color(0xffffffff).randomColor,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SvgPicture.asset(
            IconPathConstants.galleryIcon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
