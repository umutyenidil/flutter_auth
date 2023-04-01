import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/extensions/map_extensions.dart';
import 'package:uuid/uuid.dart';

class UserModel {
  static final UserModel _shared = UserModel._sharedInstance();

  UserModel._sharedInstance();

  factory UserModel() => _shared;


  Future<bool?> create({
    required String uid,
    required String emailAddress,
  }) async {
    try {
      // get users and user_details collection reference
      CollectionReference usersColRef = FirebaseFirestore.instance.collection(UserModelTables.users);
      CollectionReference userDetailsColRef = FirebaseFirestore.instance.collection(UserModelTables.userDetails);

      String generatedUuid = (const Uuid()).v4();

      // set data for the users collection
      Map<String, dynamic> userDocData = {
        UserModelFieldsEnum.uuid.value: generatedUuid,
        UserModelFieldsEnum.createdAt.value: FieldValue.serverTimestamp(),
        UserModelFieldsEnum.updatedAt.value: FieldValue.serverTimestamp(),
        UserModelFieldsEnum.deletedAt.value: null,
        UserModelFieldsEnum.isDeleted.value: false,
        UserModelFieldsEnum.lastLogin.value: null,
        UserModelFieldsEnum.lastLogout.value: null,
      };

      // set data for the user_details collection
      Map<String, dynamic> userDetailDocData = {
        UserModelFieldsEnum.uuid.value: generatedUuid,
        UserModelFieldsEnum.emailAddress.value: emailAddress,
        UserModelFieldsEnum.avatarImage.value: null,
        UserModelFieldsEnum.username.value: null,
      };

      // create new named document for users collection with user uid
      DocumentReference newUserDocRef = usersColRef.doc(uid);
      await newUserDocRef.set(userDocData);

      // create new named document for user_details collection with user uid
      DocumentReference newUserDetailDocRef = userDetailsColRef.doc(uid);
      await newUserDetailDocRef.set(userDetailDocData);

      return true;
    } catch (exception) {
      throw GenericUserModelException(exception: exception.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> readWithUid({
    required String uid,
    bool readUuid = false,
    bool readEmailAddress = false,
    bool readUsername = false,
    bool readAvatarImage = false,
    bool readPassword = false,
    bool readCreatedAt = false,
    bool readUpdatedAt = false,
    bool readDeletedAt = false,
    bool readIsDeleted = false,
    bool readLastLogin = false,
    bool readLastLogout = false,
  }) async {
    // get users and user_details collection reference
    CollectionReference usersCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.users);
    CollectionReference userDetailsCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.userDetails);

    // read the document which in users collection
    DocumentReference userDocumentReference = usersCollectionReference.doc(uid);
    DocumentSnapshot userDocumentSnapshot = await userDocumentReference.get();
    Map<String, dynamic>? userDocumentData = userDocumentSnapshot.data() as Map<String, dynamic>?;

    if (userDocumentData == null) {
      throw UserDocumentNotFoundException();
    }

    // read the document which in user_details collection
    DocumentReference userDetailDocumentReference = userDetailsCollectionReference.doc(uid);
    DocumentSnapshot userDetailDocumentSnapshot = await userDetailDocumentReference.get();
    Map<String, dynamic>? userDetailDocumentData = userDetailDocumentSnapshot.data() as Map<String, dynamic>?;

    if (userDetailDocumentData == null) {
      throw UserDetailDocumentNotFoundException();
    }

    // merge datas of user document and user_detail document
    Map<String, dynamic>? user = {};
    user.addAll(userDocumentData);
    user.addAll(userDetailDocumentData);

    return user;
  }

  @override
  Future<List<Map<String, dynamic>?>?> readAll() async {
    // users ve user_details koleksiyonlarinin referanslarini getir
    CollectionReference usersCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.users);
    CollectionReference userDetailsCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.userDetails);

    // users tablosundaki alanlarin documentsnapshot listesini getir
    QuerySnapshot usersCollectionQuerySnapshot = await usersCollectionReference.where(UserModelFieldsEnum.isDeleted.value, isEqualTo: false).get();
    List<DocumentSnapshot> userDocumentSnapshots = usersCollectionQuerySnapshot.docs;

    // dondurmek icin bos users list'i olustur
    List<Map<String, dynamic>?> users = [];

    for (DocumentSnapshot userDocumentSnapshot in userDocumentSnapshots) {
      // current user'in uid'sini al
      String userUid = userDocumentSnapshot.id;

      // current user'in users koleksiyonundaki dokumaninda bulunan alanlari getir
      Map<String, dynamic> userData = userDocumentSnapshot.data() as Map<String, dynamic>;

      // current user'in user_details koleksiyonundaki dokumaninda bulunan alanlari getir
      DocumentReference userDetailDocumentReference = userDetailsCollectionReference.doc(userUid);
      DocumentSnapshot userDetailDocumentSnapshot = await userDetailDocumentReference.get();
      Map<String, dynamic> userDetailData = userDetailDocumentSnapshot.data() as Map<String, dynamic>;

      // users ve user_details koleksiyonlarindaki dokumanlarin alanlarini birlestir
      Map<String, dynamic>? user = {};
      user.addAll(userData);
      user.addAll(userDetailData);

      // birlestirilen alanlari users listesine ekle
      users.add(user);
    }

    // users listesini dondur
    return users;
  }

  Future<bool?> updateWithUid({
    required String uid,
    required UserModelMap data,
  }) async {
    try {
      // hicbir arguman gonderilmezse false dondur
      if (data.isEmpty) {
        return false;
      }

      // dokumanlarin guncellenip guncellenmedigini kontrol degiskenler
      bool isUserDocUpdated = false;
      bool isUserDetailDocUpdated = false;

      // degistirilecek alanlari birlestirmek icin liste olustur
      Map<String, dynamic> userDocData = {};
      Map<String, dynamic> userDetailDocData = {};

      for (UserModelFieldsEnum field in data.keys.toList()) {
        if (UsersTable.fields.contains(field)) {
          userDocData[field.value] = data[field];
        }
        if (UserDetailsTable.fields.contains(field)) {
          userDetailDocData[field.value] = data[field];
        }
      }

      // users collection'daki dokuman'a gidecek veri varsa dokumani guncelle ve kontrol degiskenini true yap
      if (userDocData.isNotEmpty) {
        CollectionReference usersColRef = FirebaseFirestore.instance.collection(UsersTable.name);
        DocumentReference userDocRef = usersColRef.doc(uid);
        userDocData.addAll({
          UserModelFieldsEnum.updatedAt.value: FieldValue.serverTimestamp(),
        });
        await userDocRef.update(userDocData);
        isUserDocUpdated = true;
      }

      // user_details collection'daki dokuman'a gidecek veri varsa dokumani guncelle ve kontrol degiskenini true yap
      if (userDetailDocData.isNotEmpty) {
        CollectionReference userDetailsCollectionReference = FirebaseFirestore.instance.collection(UserDetailsTable.name);
        DocumentReference userDetailDocumentReference = userDetailsCollectionReference.doc(uid);
        userDetailDocData.addAll({
          UserModelFieldsEnum.updatedAt.value: FieldValue.serverTimestamp(),
        });
        await userDetailDocumentReference.update(userDetailDocData);
        isUserDetailDocUpdated = true;
      }

      // alanlarin degistirilip degistirilmedigini dondur
      return isUserDocUpdated && isUserDetailDocUpdated;
    } catch (exception) {
      throw GenericUserModelException(exception: exception.toString());
    }
  }

  @override
  Future<bool> deleteWithUid({required String uid}) async {
    // silinecek dokumanin uid'si ile dokumani bul ve is_deleted alanini 1 yap
    CollectionReference usersCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.users);
    DocumentReference userDocumentReference = usersCollectionReference.doc(uid);

    userDocumentReference.update({
      UserModelFieldsEnum.isDeleted.value: true,
      UserModelFieldsEnum.deletedAt.value: FieldValue.serverTimestamp(),
    });

    return true;
  }

  Future<String> toJson({required String uid}) async {
    Map<String, dynamic>? user = await readWithUid(uid: uid);

    return user!.toPrettyJson();
  }

  @override
  Future<bool> delete({required String uuid}) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> read({required String uuid}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> update({required String uuid}) {
    throw UnimplementedError();
    UserModelFieldsEnum.avatarImage.toString();
  }
}

enum UserModelFieldsEnum {
  uuid,
  emailAddress,
  username,
  avatarImage,
  password,
  createdAt,
  updatedAt,
  deletedAt,
  isDeleted,
  lastLogin,
  lastLogout,
}

extension GetValue on UserModelFieldsEnum {
  String get value {
    switch (this) {
      case UserModelFieldsEnum.uuid:
        return 'uuid';
      case UserModelFieldsEnum.emailAddress:
        return 'email_address';
      case UserModelFieldsEnum.username:
        return 'username';
      case UserModelFieldsEnum.avatarImage:
        return 'avatar_image';
      case UserModelFieldsEnum.password:
        return 'password';
      case UserModelFieldsEnum.createdAt:
        return 'created_at';
      case UserModelFieldsEnum.updatedAt:
        return 'updated_at';
      case UserModelFieldsEnum.deletedAt:
        return 'deleted_at';
      case UserModelFieldsEnum.isDeleted:
        return 'is_deleted';
      case UserModelFieldsEnum.lastLogin:
        return 'last_login';
      case UserModelFieldsEnum.lastLogout:
        return 'last_logout';
    }
  }
}

typedef UserModelMap = Map<UserModelFieldsEnum, dynamic>;

//
// class UserModelFields {
//   static const String uuid = 'uuid';
//   static const String emailAddress = 'email_address';
//   static const String username = 'username';
//   static const String avatarImage = 'avatar_image';
//   static const String password = 'password';
//   static const String createdAt = 'created_at';
//   static const String updatedAt = 'updated_at';
//   static const String deletedAt = 'deleted_at';
//   static const String isDeleted = 'is_deleted';
//   static const String lastLogin = 'last_login';
//   static const String lastLogout = 'last_logout';
// }

class UsersTable {
  UsersTable._();

  static const String name = 'users';
  static const List<UserModelFieldsEnum> fields = [
    UserModelFieldsEnum.uuid,
    UserModelFieldsEnum.createdAt,
    UserModelFieldsEnum.updatedAt,
    UserModelFieldsEnum.deletedAt,
    UserModelFieldsEnum.isDeleted,
    UserModelFieldsEnum.lastLogin,
    UserModelFieldsEnum.lastLogout,
  ];
}

class UserDetailsTable {
  UserDetailsTable._();

  static const String name = 'user_details';
  static const List<UserModelFieldsEnum> fields = [
    UserModelFieldsEnum.uuid,
    UserModelFieldsEnum.emailAddress,
    UserModelFieldsEnum.username,
    UserModelFieldsEnum.avatarImage,
  ];
}
