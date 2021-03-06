import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/helper/config.dart';
import 'package:firechat/helper/constants.dart';
import 'package:firechat/services/databaseSearch.dart';
import 'package:flutter/material.dart';
import 'conversation.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _searchContr;
  final Database _dbObj = Database();
  QuerySnapshot? _querySnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;

  @override
  void initState() {
    _searchContr = TextEditingController();
    initiateSearch();
    super.initState();
  }

  initiateSearch() async {
    if (_searchContr.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await _dbObj.searchByName(_searchContr.text).then((snapshot) {
        _querySnapshot = snapshot;

        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  sendMessage(String username) {
    String id = Constants().getChatID(Constants.name.toString(), username);
    List<String> users = [Constants.name.toString(), username];
    Map<String, dynamic> chatRoom = {"users": users, "chatid": id};

    _dbObj.addChatRoom(chatRoom, id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Conversation(
          chatID: id,
          contact: username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.mainAccent,
        elevation: 0,
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchContr,
              onChanged: (value) => initiateSearch(),
              decoration: const InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          _querySnapshot != null
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _querySnapshot!.docs.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      title: Text(_querySnapshot!.docs[index].get("name")),
                      subtitle: Text(_querySnapshot!.docs[index].get("mail")),
                      trailing: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[350],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: IconButton(
                          onPressed: () async {
                            if (await SharedPreferencesConfig.getUsername() ==
                                _querySnapshot!.docs[index].get("name")) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("You can't message yourself")));
                            } else {
                              sendMessage(
                                _querySnapshot!.docs[index].get('name'),
                              );
                            }
                          },
                          icon: const Icon(EvilIcons.comment),
                        ),
                      ),
                    ),
                  ),
                )
              : Column(
                  children: const [
                    Icon(
                      EvilIcons.exclamation,
                      size: 130,
                    ),
                    Text("Nothing Found", style: TextStyle(fontSize: 25)),
                  ],
                )
        ],
      ),
    );
  }
}
