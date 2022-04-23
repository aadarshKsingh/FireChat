import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/helper/constants.dart';
import 'package:firechat/screens/userProfile.dart';
import 'package:firechat/services/databaseSearch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Conversation extends StatefulWidget {
  const Conversation({Key? key, this.chatID, this.contact, this.mail})
      : super(key: key);
  final String? contact;
  final String? chatID;
  final String? mail;

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  late TextEditingController _msgController;
  Stream<QuerySnapshot>? conversationStream;
  final f = DateFormat('hh:mm dd-MM-yyyy');

  Widget conversationsListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: conversationStream,
      builder: (context, snapshot) => snapshot.hasData
          ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment:
                      snapshot.data!.docs[index].get("sentBy") == Constants.name
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: snapshot.data!.docs[index].get("sentBy") ==
                              Constants.name
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0))
                          : const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                    ),
                    color: snapshot.data!.docs[index].get("sentBy") ==
                            Constants.name
                        ? Constants.senderAccent
                        : Constants.receiverAccent,
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.docs[index].get('message'),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            f.format(DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data!.docs[index].get("time"))),
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.end,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            )
          : const CircularProgressIndicator(),
    );
  }

  sendMessage() {
    if (_msgController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": _msgController.text,
        "sentBy": Constants.name,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      Database().addMessage(widget.chatID.toString(), messageMap);
      setState(() {
        _msgController.clear();
      });
    }
  }

  @override
  void initState() {
    Database().getChats(widget.chatID.toString()).then((value) {
      setState(() {
        conversationStream = value;
      });
    });

    _msgController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(13.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constants().generateRandomColor()),
                child:
                    Text(widget.contact.toString().substring(0, 1).toString()),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(widget.contact.toString()),
              IconButton(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            name: widget.contact,
                            mail: widget.mail,
                          ),
                        ),
                      ),
                  icon: const Icon(Icons.info_outline))
            ],
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfile(
                        name: widget.contact,
                      ))),
        ),
        backgroundColor: Constants.mainAccent,
        elevation: 0,
      ),
      body: Stack(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(color: Color(0xFF34495E)),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height - 160,
                  width: MediaQuery.of(context).size.width,
                  child: conversationsListView()),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: size.width,
              decoration: const BoxDecoration(
                color: Color(0xFF1a252f),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _msgController,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Enter a message",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => sendMessage(),
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ]),
    );
  }
}
