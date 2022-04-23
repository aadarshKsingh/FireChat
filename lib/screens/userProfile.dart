import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/services/databaseSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, this.name, this.mail}) : super(key: key);
  final String? name;
  final String? mail;
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  QuerySnapshot? _infoSnap;
  getInfo() async {
    await Database()
        .searchByName(widget.name.toString())
        .then((snapshot) async {
      setState(() {
        _infoSnap = snapshot;
      });
    });
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(FontAwesome.arrow_left),
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _infoSnap?.docs != null
            ? ListView.builder(
                itemCount: 1,
                itemBuilder: ((context, index) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(15)),
                          child: const Icon(
                            EvilIcons.user,
                            size: 400.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70.0, vertical: 10.0),
                          child: ListTile(
                              tileColor: Colors.grey[400],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              horizontalTitleGap: 50,
                              trailing: const Icon(FontAwesome5.user_circle),
                              title: Text(_infoSnap!.docs[index].get("name"))),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70.0, vertical: 10.0),
                          child: ListTile(
                              tileColor: Colors.grey[400],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              trailing: const Icon(FontAwesome5.envelope),
                              title: Text(_infoSnap!.docs[index].get("mail"))),
                        ),
                      ],
                    )),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
