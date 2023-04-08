import 'package:chat_app/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for checking user exist or not?
  static Future<bool> userexist() async {
    return (await firestore.collection('user').doc(auth.currentUser!.uid).get()).exists;
  }

  // to creat new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final ChatUser = UserChat(
        id: auth.currentUser!.uid,
        lastActive: time,
        image: auth.currentUser!.photoURL.toString(),
        email: auth.currentUser!.email.toString(),
        name: auth.currentUser!.displayName.toString(),
        pushToken: '',
        createdAt: time,
        isOnline: false,
        about: 'Hey, I am using we chat. ');

    return await firestore.collection('user').doc(auth.currentUser!.uid).set(ChatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore.collection('user').where('id', isNotEqualTo: auth.currentUser!.uid).snapshots();
  }
}
