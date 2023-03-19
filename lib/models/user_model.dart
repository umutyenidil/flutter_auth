import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/extensions/map_extensions.dart';
import 'package:flutter_auth/models/base_models/firebase_model.dart';
import 'package:uuid/uuid.dart';

typedef UserModelMap = Map<String, dynamic>;

class UserModel extends FirebaseModel {
  static final UserModel _shared = UserModel._sharedInstance();

  UserModel._sharedInstance();

  factory UserModel() => _shared;

  @override
  Future<bool> create({
    required Map<String, dynamic> data,
  }) async {
    // create an user with email and password
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data[UserModelFields.emailAddress],
      password: data[UserModelFields.password],
    );

    // throw exception when the user is empty
    if (userCredential.user == null) {
      throw UserHasNotBeenCreatedException();
    }

    // get the uid of created user
    String userUid = userCredential.user!.uid;

    // get users and user_details collection reference
    CollectionReference usersCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.users);
    CollectionReference userDetailsCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.userDetails);

    String generatedUuid = (const Uuid()).v4();

    // set data for the users collection
    Map<String, dynamic> userDocumentData = {
      UserModelFields.uuid: generatedUuid,
      UserModelFields.createdAt: DateTime.now(),
      UserModelFields.updatedAt: DateTime.now(),
      UserModelFields.deletedAt: null,
      UserModelFields.isDeleted: false,
      UserModelFields.lastLogin: null,
      UserModelFields.lastLogout: null,
    };

    // set data for the user_details collection
    Map<String, dynamic> userDetailDocumentData = {
      UserModelFields.uuid: generatedUuid,
      UserModelFields.emailAddress: data[UserModelFields.emailAddress],
    };

    // create new named document for users collection with user uid
    DocumentReference newUserDocumentReference = usersCollectionReference.doc(userUid);
    await newUserDocumentReference.set(userDocumentData);

    // create new named document for user_details collection with user uid
    DocumentReference newUserDetailDocumentReference = userDetailsCollectionReference.doc(userUid);
    await newUserDetailDocumentReference.set(userDetailDocumentData);

    return true;
  }

  @override
  Future<Map<String, dynamic>?> readWithUid({
    required String uid,
  }) async {
    // get users and user_details collection reference
    CollectionReference usersCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.users);
    CollectionReference userDetailsCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.userDetails);

    // read the document which in users collection
    DocumentReference userDocumentReference = usersCollectionReference.doc(uid);
    DocumentSnapshot userDocumentSnapshot = await userDocumentReference.get();
    Map<String, dynamic>? userData = userDocumentSnapshot.data() as Map<String, dynamic>?;

    if (userData == null) {
      throw UserDocumentNotFoundException();
    }

    // read the document which in user_details collection
    DocumentReference userDetailDocumentReference = userDetailsCollectionReference.doc(uid);
    DocumentSnapshot userDetailDocumentSnapshot = await userDetailDocumentReference.get();
    Map<String, dynamic>? userDetailData = userDetailDocumentSnapshot.data() as Map<String, dynamic>?;

    if (userDetailData == null) {
      throw UserDetailDocumentNotFoundException();
    }

    // merge datas of user document and user_detail document
    Map<String, dynamic>? user = {};
    user.addAll(userData);
    user.addAll(userDetailData);

    return user;
  }

  @override
  Future<List<Map<String, dynamic>?>?> readAll() async {
    // users ve user_details koleksiyonlarinin referanslarini getir
    CollectionReference usersCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.users);
    CollectionReference userDetailsCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.userDetails);

    // users tablosundaki alanlarin documentsnapshot listesini getir
    QuerySnapshot usersCollectionQuerySnapshot = await usersCollectionReference.where(UserModelFields.isDeleted, isEqualTo: false).get();
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

  @override
  Future<bool> updateWithUid({required String uid, required Map<String, dynamic> data}) async {
    // hicbir arguman gonderilmezse false dondur
    if (data.isEmpty) {
      return false;
    }

    // alanlardan herhangi biri null ise false dondurur
    for (var value in data.values) {
      if (value == null) {
        return false;
      }
    }

    // dokumanlarin guncellenip guncellenmedigini kontrol degiskenler
    bool isUserDocumentUpdated = false;
    bool isUserDetailDocumentUpdated = false;

    // degistirilecek alanlari birlestirmek icin liste olustur
    Map<String, dynamic> userDocumentData = {};
    Map<String, dynamic> userDetailDocumentData = {};

    // null olmayan alanlari map'lere ekle
    if (data[UserModelFields.emailAddress] != null) {
      userDetailDocumentData[UserModelFields.emailAddress] = data[UserModelFields.emailAddress];
    }

    // users collection'daki dokuman'a gidecek veri varsa dokumani guncelle ve kontrol degiskenini true yap
    if (userDocumentData.isNotEmpty) {
      CollectionReference usersCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.users);
      DocumentReference userDocumentReference = usersCollectionReference.doc(uid);
      await userDocumentReference.update(userDocumentData);
      await userDocumentReference.update({UserModelFields.updatedAt: DateTime.now()});

      isUserDocumentUpdated = true;
    }

    // user_details collection'daki dokuman'a gidecek veri varsa dokumani guncelle ve kontrol degiskenini true yap
    if (userDocumentData.isNotEmpty) {
      CollectionReference userDetailsCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.userDetails);
      DocumentReference userDetailDocumentReference = userDetailsCollectionReference.doc(uid);
      await userDetailDocumentReference.update(userDetailDocumentData);
      await userDetailDocumentReference.update({UserModelFields.updatedAt: DateTime.now()});

      isUserDetailDocumentUpdated = true;
    }

    // alanlarin degistirilip degistirilmedigini dondur
    return isUserDocumentUpdated && isUserDetailDocumentUpdated;
  }

  @override
  Future<bool> deleteWithUid({required String uid}) async {
    // silinecek dokumanin uid'si ile dokumani bul ve is_deleted alanini 1 yap
    CollectionReference usersCollectionReference = FirebaseFirestore.instance.collection(UserModelTables.users);
    DocumentReference userDocumentReference = usersCollectionReference.doc(uid);

    userDocumentReference.update({
      UserModelFields.isDeleted: true,
      UserModelFields.deletedAt: DateTime.now(),
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
  Future<bool> update({required String uuid}) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> read({required String uuid}) {
    throw UnimplementedError();
  }
}

class UserModelFields {
  static const String uuid = 'uuid';
  static const String emailAddress = 'email_address';
  static const String password = 'password';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String deletedAt = 'deleted_at';
  static const String isDeleted = 'is_deleted';
  static const String lastLogin = 'last_login';
  static const String lastLogout = 'last_logout';
}

class UserModelTables {
  static const String users = 'users';
  static const String userDetails = 'user_details';
}