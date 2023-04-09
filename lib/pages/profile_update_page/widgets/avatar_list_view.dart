import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/color_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/input_values/avatar_image_value.dart';
import 'package:flutter_auth/mixins/image_storage_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef Fonksiyon = void Function(AvatarImageValue value);

class AvatarListView extends StatefulWidget {
  const AvatarListView({
    super.key,
    required this.getAvatarImage,
    required this.initialAvatarImageValue,
  });

  final Fonksiyon getAvatarImage;
  final AvatarImageValue initialAvatarImageValue;

  @override
  State<AvatarListView> createState() => _AvatarListViewState();
}

class _AvatarListViewState extends State<AvatarListView> with ImageStorage {
  late PageController _pageController;
  late int selectedIndex;
  late AvatarImageValue avatarImage;
  late List<String> avatarImageUrlList;

  @override
  void initState() {
    super.initState();
    avatarImage = AvatarImageValue(
      value: null,
      status: AvatarImageStatus.initial,
    );

    widget.getAvatarImage(avatarImage);

    selectedIndex = 2;
    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RemoteStorageBloc, RemoteStorageState>(
      listener: listenerRemoteStorageBloc,
      listenWhen: listenWhenRemoteStorageBloc,
      buildWhen: buildWhenRemoteStorageBloc,
      builder: (context, state) {
        if (state is StateSuccessfulGetAvatarImageUrlList) {
          avatarImageUrlList = state.avatarImageUrlList;
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
                    itemCount: avatarImageUrlList.length + 2,
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
                        listItem = avatarImageFromUrl(
                          url: avatarImageUrlList[index - 2],
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
        }
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
                  itemCount: 3,
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    Widget? listItem;
                    if (index == 0) {
                      listItem = openGalleryButton();
                    } else if (index == 1) {
                      listItem = openCameraButton();
                    } else if (index == 2) {
                      listItem = selectedImage();
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
    if (selectedIndex > 2) {
      return SizedBox(
        height: 35,
        width: 80,
        child: MaterialButton(
          onPressed: () async {
            setState(() {
              avatarImage = AvatarImageValue(
                value: avatarImageUrlList[selectedIndex - 2],
                status: AvatarImageStatus.fromAvatars,
              );
            });

            widget.getAvatarImage(avatarImage);
            _pageController.animateToPage(2, duration: Duration(milliseconds: 300 * (selectedIndex - 2)), curve: Curves.easeIn);
          },
          color: Colors.grey.shade300,
          minWidth: 0,
          height: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          shape: const StadiumBorder(),
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
    if(selectedIndex == 2){
      if(avatarImage.status != AvatarImageStatus.initial){
        return SizedBox(
          height: 35,
          width: 80,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(35 / 2),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
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
    }
    return const SizedBox(
      height: 35,
      width: 80,
    );
  }

  Widget selectedImage() {
    if ([
      AvatarImageStatus.fromCamera,
      AvatarImageStatus.fromGallery,
    ].contains(avatarImage.status)) {
      return SizedBox.square(
        dimension: 120,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConstants.randomColor(),
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              image: FileImage(
                avatarImage.value,
              ),
            ),
          ),
        ),
      );
    }
    if (avatarImage.status == AvatarImageStatus.fromAvatars) {
      return SizedBox.square(
        dimension: 120,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConstants.randomColor(),
            image: DecorationImage(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              image: CachedNetworkImageProvider(
                avatarImage.value,
              ),
            ),
          ),
        ),
      );
    }

    return avatarImageFromUrl(
      url: widget.initialAvatarImageValue.value,
    );
  }

  Widget avatarImageFromUrl({required String url}) {
    return SizedBox.square(
      dimension: 120,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.randomColor(),
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (BuildContext context, String url) {
            return const Center(
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
            if (context.mounted) {
              await PopUpMessage.danger(
                title: 'Camera error',
                message: 'There was a camera error. Please try again',
              ).show(context);
              return;
            }
          }
          setState(() {
            avatarImage = AvatarImageValue(
              value: photoFile,
              status: AvatarImageStatus.fromCamera,
            );
          });
          widget.getAvatarImage(avatarImage);
          _pageController.animateToPage(
            2,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        shape: const CircleBorder(),
        color: ColorConstants.randomColor(),
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
          File? imageFile = await getPhotoFileFromGallery();
          if (imageFile == null) {
            if (context.mounted) {
              await PopUpMessage.danger(
                title: 'Gallery error',
                message: 'There was a gallery error. Please try again',
              ).show(context);
              return;
            }
          }
          setState(() {
            avatarImage = AvatarImageValue(
              value: imageFile,
              status: AvatarImageStatus.fromGallery,
            );
          });
          widget.getAvatarImage(avatarImage);
          _pageController.animateToPage(
            2,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        shape: const CircleBorder(),
        color: ColorConstants.randomColor(),
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

  bool buildWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    if (previous is StateLoadingGetUserProfile || current is StateSuccessfulGetUserProfile) {
      return true;
    }
    if (previous is StateLoadingGetAvatarImageUrlList || current is StateSuccessfulGetAvatarImageUrlList) {
      return true;
    }
    return false;
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) {}

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    return true;
  }
}
