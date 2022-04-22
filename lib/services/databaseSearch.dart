import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  addUserInfo(String name, String mail) {
    final userMap = {
      'name': name,
      'mail': mail,
    };
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e);
    });
  }

  getUserInfo(String mail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("mail", isEqualTo: mail)
        .get()
        .catchError((e) {
      print(e);
    });
  }

  searchByName(String searchfield) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: searchfield)
        .get();
  }

  addChatRoom(chatRoom, chatid) {
    FirebaseFirestore.instance
        .collection("chat")
        .doc(chatid)
        .set(chatRoom)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChats(chatRoomID) async {
    return FirebaseFirestore.instance
        .collection('chat')
        .doc(chatRoomID)
        .collection('conversation')
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<void> addMessage(String chatRoomID, chatMessageData) async {
    FirebaseFirestore.instance
        .collection('chat')
        .doc(chatRoomID)
        .collection('conversation')
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chat")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  getUserInfoByName(String friendName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', arrayContains: friendName)
        .snapshots();
  }

  getLastMessage(chatRoomID) async {
    return await FirebaseFirestore.instance
        .collection('chat')
        .doc(chatRoomID)
        .collection('conversation')
        .orderBy("time", descending: false)
        .snapshots()
        .last;
  }
}
