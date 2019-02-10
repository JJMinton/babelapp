import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {

  static void safeAddUser(String uid, String email, String name ) async {
    final users = Firestore.instance.collection('users');
    final QuerySnapshot currentUsers = await users.where("email", isEqualTo: email).getDocuments();
    if (currentUsers.documents.isEmpty) {
      users.document().setData({
        "uid": uid,
        "email": email,
        "displayName": name,
      });
    }
  }

  static Stream<QuerySnapshot> getUsers() {
    return Firestore.instance.collection('users').snapshots();
  }

  static void createNewChat(String uid) {
    Firestore.instance.collection("chats").document().setData({
      "uid": uid,
      "count": 0,
      "createdAt": Timestamp.now()
    });
  }

  static void joinChat(String chatId, String uid) async {
    DocumentReference chatRef = Firestore.instance.collection("chats").document(chatId);
    await chatRef.updateData({"uid": uid});
  }

  static Stream<QuerySnapshot> getUsersChats(String uid) {
    return Firestore.instance.collection('chats').where("uid", isEqualTo: uid).snapshots();
  }

  static Stream<DocumentSnapshot> getMessages(String chatId) {
    return Firestore.instance.collection("chats").document(chatId).snapshots();
  }

  static void sendMessage(String uid, String chatId, String message) {
    Firestore.instance.collection("chats/$chatId/messages").add({
      "content": message, //TODO: convert message to multiple languages
      "createdAt": Timestamp.now(),
      "uid": uid,
    });
  }

}