import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/helper/constants.dart';
import 'package:firechat/screens/conversation.dart';
import 'package:firechat/screens/search.dart';
import 'package:firechat/screens/userProfile.dart';
import 'package:firechat/services/auth.dart';
import 'package:firechat/services/databaseSearch.dart';
import 'package:flutter/material.dart';
import '../screens/signin.dart';
import '../helper/config.dart';

class AllChats extends StatefulWidget {
  const AllChats({Key? key, this.name}) : super(key: key);
  final String? name;
  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  Stream<QuerySnapshot>? chatsStream;
  updateName() {
    setState(() {
      Constants.name = widget.name;
    });
  }

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatsStream,
      builder: ((context, snapshot) {
        print(snapshot.data!.docs);
        return snapshot.hasData || snapshot.data!.docs.isNotEmpty
            ? ListView.builder(
                itemExtent: 80,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Conversation(
                          chatID: snapshot.data!.docs[index].get("chatid"),
                          contact: snapshot.data!.docs[index]
                              .get("chatid")
                              .toString()
                              .replaceAll(Constants.name.toString(), '')
                              .replaceAll('_', ''),
                          mail: snapshot.data!.docs[index].get('chatid'),
                        ),
                      )),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Constants().generateRandomColor()),
                        height: 60,
                        width: 60,
                        child: Text(
                          snapshot.data!.docs[index]
                              .get("chatid")
                              .toString()
                              .substring(0, 1),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                          snapshot.data!.docs[index]
                              .get("chatid")
                              .toString()
                              .replaceAll("_", "")
                              .replaceAll(Constants.name.toString(), ""),
                          style: const TextStyle(fontSize: 20)),
                      // IconButton(
                      //     onPressed: () => Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => UserProfile(
                      //             name: snapshot.data!.docs[index]
                      //                 .get("chatid")
                      //                 .toString()
                      //                 .replaceAll("_", "")
                      //                 .replaceAll(
                      //                     Constants.name.toString(), ""),
                      //           ),
                      //         )),
                      //     icon: const Icon(Icons.info))
                    ],
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/sad.png",
                  ),
                  const Center(
                    child: Text("No Chats"),
                  ),
                ],
              );
      }),
    );
  }

  @override
  void initState() {
    updateName();
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.name = await SharedPreferencesConfig.getUsername();
    Constants.mail = await SharedPreferencesConfig.getMail();

    Database().getUserChats(Constants.name.toString()).then((snapshots) {
      setState(() {
        chatsStream = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.edit),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Search())),
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(children: [
                Container(
                  height: 250.0,
                  color: Colors.grey,
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(50.0),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      size: 150,
                    ),
                  ),
                )
              ]),
              ListTile(title: Center(child: Text(Constants.name.toString()))),
              ListTile(
                title: Center(
                  child: Text(Constants.mail.toString()),
                ),
              ),
              ListTile(
                  title: const Center(child: Text("Logout")),
                  trailing: const Icon(Icons.logout),
                  onTap: () {
                    Authentications().signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignIn()));
                  })
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Constants.mainAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.whatshot_outlined),
              SizedBox(width: 5.0),
              Text("FireChat")
            ],
          ),
        ),
        body: chatRoomsList());
  }
}
