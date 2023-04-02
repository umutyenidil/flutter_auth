import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
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
      CollectionReference usersColRef = FirebaseFirestore.instance.collection(UsersTable.name);
      CollectionReference userDetailsColRef = FirebaseFirestore.instance.collection(UserDetailsTable.name);

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

  Future<UserModelMap?> readWithUid({
    required String uid,
    List<UserModelFieldsEnum> fields = const [
      ...UsersTable.fields,
      ...UserDetailsTable.fields,
    ],
  }) async {
    UserModelMap userData = {};
    try {
      // get users and user_details collection reference
      CollectionReference usersColRef = FirebaseFirestore.instance.collection(UsersTable.name);
      CollectionReference userDetailsColRef = FirebaseFirestore.instance.collection(UserDetailsTable.name);

      // read the document which in users collection
      DocumentReference userDocRef = usersColRef.doc(uid);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      UserModelMap userDocData = {};
      for (UserModelFieldsEnum field in fields) {
        if (UsersTable.fields.contains(field)) {
          userDocData[field] = userDocSnapshot.get(field.value);
        }
      }

      // read the document which in user_details collection
      // read the document which in users collection
      DocumentReference userDetailDocRef = userDetailsColRef.doc(uid);
      DocumentSnapshot userDetailDocSnapshot = await userDetailDocRef.get();

      UserModelMap userDetailDocData = {};
      for (UserModelFieldsEnum field in fields) {
        if (UserDetailsTable.fields.contains(field)) {
          userDetailDocData[field] = userDetailDocSnapshot.get(field.value);
        }
      }

      // merge datas of user document and user_detail document
      if (userDocData.isNotEmpty) {
        userData.addAll(userDocData);
      }

      if (userDetailDocData.isNotEmpty) {
        userData.addAll(userDetailDocData);
      }
    } catch (exception) {
      throw GenericUserModelException(exception: exception.toString());
    }

    if (userData.isEmpty) {
      return null;
    }
    return userData;
  }

  Future<List<UserModelMap?>?> readAll({
    List<UserModelFieldsEnum> fields = const [
      ...UsersTable.fields,
      ...UserDetailsTable.fields,
    ],
  }) async {
    // users ve user_details koleksiyonlarinin referanslarini getir
    CollectionReference usersColRef = FirebaseFirestore.instance.collection(UsersTable.name);
    CollectionReference userDetailsColRef = FirebaseFirestore.instance.collection(UserDetailsTable.name);

    // users tablosundaki alanlarin documentsnapshot listesini getir
    QuerySnapshot usersColQuerySnapshot = await usersColRef.where(UserModelFieldsEnum.isDeleted.value, isEqualTo: false).get();
    List<DocumentSnapshot> userDocSnapshots = usersColQuerySnapshot.docs;

    // dondurmek icin bos users list'i olustur
    List<UserModelMap?> users = [];

    for (DocumentSnapshot userDocSnapshot in userDocSnapshots) {
      // current user'in uid'sini al
      String userUid = userDocSnapshot.id;

      UserModelMap? userData = await readWithUid(uid: userUid, fields: fields);

      if (userData == null) {
        continue;
      }

      users.add(userData);
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

  Future<bool> deleteWithUid({required String uid}) async {
    // silinecek dokumanin uid'si ile dokumani bul ve is_deleted alanini 1 yap
    updateWithUid(
      uid: uid,
      data: {
        UserModelFieldsEnum.isDeleted: true,
        UserModelFieldsEnum.deletedAt: FieldValue.serverTimestamp(),
      },
    );

    return true;
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
