import 'package:chat_app/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore.collection('user').where('id', isNotEqualTo: user.uid).snapshots();
  }

  // Save the updated information
  static Future<void> updatedUserInformation() async {
    await firestore.collection('user').doc(user.uid).update({'name': me.name, 'about': me.about});
  }
}
