import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/helper/constants.dart';
import 'package:firechat/screens/about.dart';
import 'package:firechat/screens/conversation.dart';
import 'package:firechat/screens/search.dart';
import 'package:firechat/services/auth.dart';
import 'package:firechat/services/databaseSearch.dart';
import 'package:flutter/material.dart';
import '../screens/signin.dart';
import '../helper/config.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class AllChats extends StatefulWidget {
  const AllChats({Key? key, this.name}) : super(key: key);
  final String? name;
  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  Stream<QuerySnapshot>? chatsStream;

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatsStream,
      builder: ((context, snapshot) {
        return snapshot.hasData &&
                snapshot.data!.docs.isNotEmpty &&
                !snapshot.hasError
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
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
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
                          const SizedBox(
                            width: 50.0,
                          ),
                          IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance.runTransaction(
                                    (Transaction myTransaction) async {
                                  myTransaction.delete(
                                      snapshot.data!.docs[index].reference);
                                });
                              },
                              icon: const Icon(EvilIcons.trash))
                        ],
                      ),
                    ),
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
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFF3B692), Color(0xFFEA5455)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Octicons.search),
            label: const Text("Search for Friends"),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Search())),
          ),
          drawer: Drawer(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
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
                      padding: const EdgeInsets.all(30.0),
                      child: const Icon(
                        EvilIcons.user,
                        size: 200,
                      ),
                    ),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Center(child: Text(Constants.name.toString())),
                    trailing: const Icon(EvilIcons.user),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Center(
                      child: Text(Constants.mail.toString()),
                    ),
                    trailing: const Icon(EvilIcons.envelope),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      tileColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: const Center(child: Text("Logout")),
                      trailing: const Icon(Octicons.sign_out),
                      onTap: () {
                        Authentications().signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()));
                      }),
                )
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Constants.mainAccent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(
                  Icons.whatshot_outlined,
                  color: Colors.white70,
                ),
                SizedBox(width: 5.0),
                Text(
                  "FireChat",
                  style: TextStyle(color: Colors.white70),
                )
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const About())),
                  icon: const Icon(FontAwesome.code))
            ],
          ),
          body: chatRoomsList()),
    );
  }
}
