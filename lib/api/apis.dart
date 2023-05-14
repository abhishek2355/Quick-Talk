import 'dart:developer';

import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // For accessinf the image storage
  static FirebaseStorage imagestorage = FirebaseStorage.instance;

  // For store the self informatio
  static late UserChat me;

  // to return current user
  static User get user => auth.currentUser!;

  // for checking user exist or not?
  static Future<bool> userexist() async {
    return (await firestore.collection('user').doc(user.uid).get()).exists;
  }

  // for get self information on prifile page
  static Future<void> getSelfInfo() async {
    await firestore.collection('user').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserChat.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // to creat new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final ChatUser = UserChat(
        id: user.uid,
        lastActive: time,
        image: user.photoURL.toString(),
        email: user.email.toString(),
        name: user.displayName.toString(),
        pushToken: '',
        createdAt: time,
        isOnline: false,
        about: 'Hey, I am using we chat. ');

    return await firestore.collection('user').doc(user.uid).set(ChatUser.toJson());
  }

  // Getting all user's who loged in
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore.collection('user').where('id', isNotEqualTo: user.uid).snapshots();
  }

  // Save the updated information
  static Future<void> updatedUserInformation() async {
    await firestore.collection('user').doc(user.uid).update({'name': me.name, 'about': me.about});
  }

  // Update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    // getting image file path
    final ext = file.path.split('.').last;
    log('Extension is: $ext');

    // Store file ref with path
    final ref = imagestorage.ref().child('Profile_picture/${user.uid}.$ext');

    // Uploding image size
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transfer: ${p0.bytesTransferred / 1000} kb');
    });

    // // Uploading image in the database
    me.image = await ref.getDownloadURL();
    await firestore.collection('user').doc(user.uid).update({
      'image': me.image,
    });
  }

  /// ******************************** Chat message screen related api ********************************************

  // Chats (collection) --> conversations_id (doc) --> messages (collection) --> message (doc)

  // Usefull for geting conversations_id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  // getting all messages of a specific conversation from the database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserChat user) {
    return firestore.collection('chats/${getConversationID(user.id)}/message/').snapshots();
  }

  // for sending the messages
  static Future<void> sendMessage(UserChat chatUser, String msg, Type type) async {
    // Doc id
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // Message to send
    final Messages messages = Messages(fromId: user.uid, sent: time, msg: msg, toId: chatUser.id, type: type, read: '');
    final ref = firestore.collection('chats/${getConversationID(chatUser.id)}/message/');
    await ref.doc(time).set(messages.toJson());
  }

  static Future<void> updateMessageReadStatus(Messages message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/message/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // Send chat image
  static Future<void> sendChatImage(UserChat chatUser, File file) async {
    // getting image file path
    final ext = file.path.split('.').last;

    // Store file ref with path
    final ref = imagestorage.ref().child('images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // Uploding image size
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transfer: ${p0.bytesTransferred / 1000} kb');
    });

    // // Uploading image in the database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }
}
