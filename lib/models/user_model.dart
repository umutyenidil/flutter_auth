import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:uuid/uuid.dart';

class UserModel {
  UserModel._privateConstructor();

  static final UserModel instance = UserModel._privateConstructor();

  Future<bool> create({
    required String uid,
    required String emailAddress,
  }) async {
    try {
      CollectionReference usersColRef = FirebaseFirestore.instance.collection(UsersTable.name);
      CollectionReference userDetailsColRef = FirebaseFirestore.instance.collection(UserDetailsTable.name);

      String generatedUuid = (const Uuid()).v4();

      UserModelMap userDocData = {
        UserModelField.uuid: generatedUuid,
        UserModelField.createdAt: FieldValue.serverTimestamp(),
        UserModelField.updatedAt: FieldValue.serverTimestamp(),
        UserModelField.deletedAt: null,
        UserModelField.isDeleted: false,
        UserModelField.lastLogin: null,
        UserModelField.lastLogout: null,
      };

      UserModelMap userDetailDocData = {
        UserModelField.uuid: generatedUuid,
        UserModelField.emailAddress: emailAddress,
        UserModelField.avatarImage: null,
        UserModelField.username: null,
      };

      DocumentReference userDocRef = usersColRef.doc(uid);
      await userDocRef.set(userDocData.toMapStringDynamic);

      DocumentReference userDetailDocRef = userDetailsColRef.doc(uid);
      await userDetailDocRef.set(userDetailDocData.toMapStringDynamic);

      return true;
    } on Exception catch (e) {
      throw GenericUserModelException(
        methodName: 'create()',
      );
    }
  }

  Future<UserModelMap?> readWithUid({
    required String uid,
    List<UserModelField> fields = const [
      ...UsersTable.fields,
      ...UserDetailsTable.fields,
    ],
  }) async {
    UserModelMap? userData = {};
    try {
      CollectionReference usersColRef = FirebaseFirestore.instance.collection(UsersTable.name);

      DocumentReference userDocRef = usersColRef.doc(uid);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      UserModelMap userDocData = {};
      for (UserModelField field in fields) {
        if (UsersTable.fields.contains(field)) {
          userDocData[field] = userDocSnapshot.get(field.value);
        }
      }
      if (userDocData.isNotEmpty) {
        userData.addAll(userDocData);
      }

      CollectionReference userDetailsColRef = FirebaseFirestore.instance.collection(UserDetailsTable.name);

      DocumentReference userDetailDocRef = userDetailsColRef.doc(uid);
      DocumentSnapshot userDetailDocSnapshot = await userDetailDocRef.get();

      UserModelMap userDetailDocData = {};
      for (UserModelField field in fields) {
        if (UserDetailsTable.fields.contains(field)) {
          userDetailDocData[field] = userDetailDocSnapshot.get(field.value);
        }
      }
      if (userDetailDocData.isNotEmpty) {
        userData.addAll(userDetailDocData);
      }
    } on Exception catch (e) {
      throw GenericUserModelException(
        methodName: 'readWithUid()',
      );
    }

    if (userData.isEmpty) {
      return null;
    }

    return userData;
  }

  Future<List<UserModelMap>> readAll({
    List<UserModelField> fields = const [
      ...UsersTable.fields,
      ...UserDetailsTable.fields,
    ],
  }) async {
    List<UserModelMap> users = [];

    try {
      CollectionReference usersColRef = FirebaseFirestore.instance.collection(UsersTable.name);

      QuerySnapshot usersColQuerySnapshot = await usersColRef
          .where(
            UserModelField.isDeleted.value,
            isEqualTo: false,
          )
          .get();

      List<DocumentSnapshot> usersDocSnapshot = usersColQuerySnapshot.docs;

      for (DocumentSnapshot userDocSnapshot in usersDocSnapshot) {
        String userUid = userDocSnapshot.id;

        UserModelMap? userData = await readWithUid(
          uid: userUid,
          fields: fields,
        );

        if (userData == null) {
          continue;
        }

        users.add(userData);
      }
    } on GenericUserModelException {
      rethrow;
    } on Exception catch (e) {
      throw GenericUserModelException(
        methodName: 'readAll()',
      );
    }

    if (users.isEmpty) {
      throw UsersNotFetchedException();
    }

    return users;
  }

  Future<void> updateWithUid({
    required String uid,
    required UserModelMap data,
  }) async {
    if (data.isEmpty) {
      throw UserNotUpdatedException();
    }
    try {
      UserModelMap userDocData = {};
      UserModelMap userDetailDocData = {};
      bool isUserDocDataUpdated = false;
      bool isUserDetailDocDataUpdated = false;

      for (UserModelField field in data.keys.toList()) {
        if (UsersTable.fields.contains(field)) {
          userDocData[field] = data[field];
        }
        if (UserDetailsTable.fields.contains(field)) {
          userDetailDocData[field] = data[field];
        }
      }

      if (userDocData.isNotEmpty) {
        for (UserModelField uniqueField in UsersTable.uniqueFields) {
          if (userDocData.keys.toList().contains(uniqueField)) {
            bool isFieldUnique = await _isFieldUnique(
              field: uniqueField,
              value: userDetailDocData[uniqueField],
              collectionName: UsersTable.name,
            );

            if (!isFieldUnique) {
              throw UniqueFieldException(
                fieldName: uniqueField.value,
              );
            }
          }
        }

        CollectionReference usersColRef = FirebaseFirestore.instance.collection(UsersTable.name);

        DocumentReference userDocRef = usersColRef.doc(uid);

        await userDocRef.update(userDocData.toMapStringDynamic);
        isUserDocDataUpdated = true;
      }

      if (userDetailDocData.isNotEmpty) {
        for (UserModelField uniqueField in UserDetailsTable.uniqueFields) {
          if (userDetailDocData.keys.toList().contains(uniqueField)) {
            bool isFieldUnique = await _isFieldUnique(
              field: uniqueField,
              value: userDetailDocData[uniqueField],
              collectionName: UserDetailsTable.name,
            );

            if (!isFieldUnique) {
              throw UniqueFieldException(
                fieldName: uniqueField.value,
              );
            }
          }
        }

        CollectionReference userDetailsColRef = FirebaseFirestore.instance.collection(UserDetailsTable.name);
        DocumentReference userDetailDocRef = userDetailsColRef.doc(uid);
        await userDetailDocRef.update(userDetailDocData.toMapStringDynamic);
        isUserDetailDocDataUpdated = true;
      }

      if (isUserDocDataUpdated || isUserDetailDocDataUpdated) {
        CollectionReference usersColRef = FirebaseFirestore.instance.collection(UsersTable.name);
        DocumentReference userDocRef = usersColRef.doc(uid);
        await userDocRef.update({UserModelField.updatedAt: FieldValue.serverTimestamp()}.toMapStringDynamic);
      }
    } on UniqueFieldException {
      rethrow;
    } on Exception catch (e) {
      throw GenericUserModelException(
        methodName: 'updateWithUid()',
      );
    }
  }

  Future<bool> _isFieldUnique({
    required UserModelField field,
    required dynamic value,
    required String collectionName,
  }) async {
    CollectionReference usersColRef = FirebaseFirestore.instance.collection(collectionName);

    Query uniqueFieldQuery = usersColRef.where(field.value, isEqualTo: value);
    QuerySnapshot uniqueQuerySnapshot = await uniqueFieldQuery.get();
    if (uniqueQuerySnapshot.size >= 1) {
      return false;
    }

    return true;
  }

  /// uid'si verilen kullaniciyi veritabaninda is_deleted alanini true yapar
  ///
  /// throws GenericUserModelException
  Future<void> deleteWithUid({required String uid}) async {
    try {
      await updateWithUid(
        uid: uid,
        data: {
          UserModelField.isDeleted: true,
          UserModelField.deletedAt: FieldValue.serverTimestamp(),
        },
      );
    } on Exception {
      throw GenericUserModelException(
        methodName: 'deleteWithUid()',
      );
    }
  }
}

enum UserModelField {
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

extension GetValue on UserModelField {
  String get value {
    switch (this) {
      case UserModelField.uuid:
        return 'uuid';
      case UserModelField.emailAddress:
        return 'email_address';
      case UserModelField.username:
        return 'username';
      case UserModelField.avatarImage:
        return 'avatar_image';
      case UserModelField.password:
        return 'password';
      case UserModelField.createdAt:
        return 'created_at';
      case UserModelField.updatedAt:
        return 'updated_at';
      case UserModelField.deletedAt:
        return 'deleted_at';
      case UserModelField.isDeleted:
        return 'is_deleted';
      case UserModelField.lastLogin:
        return 'last_login';
      case UserModelField.lastLogout:
        return 'last_logout';
    }
  }
}

typedef UserModelMap = Map<UserModelField, dynamic>;

extension ToMap on UserModelMap {
  Map<String, dynamic> get toMapStringDynamic {
    Map<String, dynamic> data = {};

    forEach((key, value) {
      data[key.value] = value;
    });

    return data;
  }
}

class UsersTable {
  UsersTable._();

  static const String name = 'users';

  static const List<UserModelField> uniqueFields = [
    UserModelField.uuid,
  ];
  static const List<UserModelField> fields = [
    UserModelField.uuid,
    UserModelField.createdAt,
    UserModelField.updatedAt,
    UserModelField.deletedAt,
    UserModelField.isDeleted,
    UserModelField.lastLogin,
    UserModelField.lastLogout,
  ];
}

class UserDetailsTable {
  UserDetailsTable._();

  static const String name = 'user_details';

  static const List<UserModelField> uniqueFields = [
    UserModelField.uuid,
    UserModelField.username,
  ];

  static const List<UserModelField> fields = [
    UserModelField.uuid,
    UserModelField.emailAddress,
    UserModelField.username,
    UserModelField.avatarImage,
  ];
}
