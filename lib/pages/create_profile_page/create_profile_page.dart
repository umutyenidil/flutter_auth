import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/input_field.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/constants/string_error_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/pages/create_profile_page/widgets/avatar_list_view.dart';
import 'package:flutter_auth/pages/create_profile_page/widgets/save_button.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({Key? key}) : super(key: key);

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  late Uint8List? profilePhotoBytes;

  late FocusNode _usernameInputNode;
  late String _usernameInputValue;

  @override
  void initState() {
    super.initState();
    _usernameInputNode = FocusNode();

    _usernameInputValue = StringErrorConstants.error;
  }

  @override
  void dispose() {
    _usernameInputNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RemoteStorageBloc, RemoteStorageState>(
      listener: listenerRemoteStorageBloc,
      listenWhen: listenWhenRemoteStorageBloc,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                width: context.screenWidth,
                height: context.safeAreaHeight,
                child: Column(
                  children: [
                    const VerticalSpace(32),
                    AvatarListView(
                      getImageAsByteList: (Uint8List? bytes) async {
                        profilePhotoBytes = bytes;
                      },
                    ),
                    const VerticalSpace(32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InputField(
                        node: _usernameInputNode,
                        hintText: 'Kullanici adi giriniz',
                        inputType: TextInputType.text,
                        regularExpression: r'[A-Za-z0-9]{8,}',
                        errorMessage: 'Kullanici adi minimum 8 karakterli olmalidir. Sadece rakam ve harf icerebilir',
                        getValue: (value) {
                          _usernameInputValue = value;
                        },
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SaveButton(
                        onPressed: () {
                          context.dismissKeyboard();

                          if (profilePhotoBytes == null) {
                            PopUpMessage.danger(
                              title: 'Profil fotografi',
                              message: 'profil fotografi secmelisiniz',
                            ).show(context);
                            return;
                          }
                          if (_usernameInputValue == StringErrorConstants.error) {
                            PopUpMessage.danger(
                              title: 'Kullanici adi girmelisiniz',
                              message: 'Kullanici adi girmelisiniz',
                            ).show(context);
                            return;
                          }
                          Map<String, dynamic> userData = {
                            UserModelFields.username: _usernameInputValue,
                            UserModelFields.avatarImage: Blob(profilePhotoBytes!),
                          };

                          BlocProvider.of<RemoteStorageBloc>(context).add(
                            EventCreateUserProfile(
                              userData: userData,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {
    if (state is StateLoadingCreateUserProfile) {
      const PopUpLoading().show(context);
    }
    if (state is StateSuccessfulCreateUserProfile) {
      await PopUpMessage.success(
        title: 'Hazirsin!',
        message: 'Profiliniz basariyla olusturuldu. Artik uygulamayi kullanabilirsiniz :)',
      ).show(context);
      context.pageTransitionFade(
        page: const HomePage(),
      );
    }
    if (state is StateFailedCreateUserProfile) {
      PopUpMessage.danger(
        title: 'Ah!',
        message: 'Profilinizi olusturmaya calisirken bir sorunla karsilastik.',
      ).show(context);
    }
  }

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    if (previous is StateLoadingCreateUserProfile && current is! StateLoadingCreateUserProfile) {
      Navigator.of(context).pop();
    }
    return true;
  }
}
