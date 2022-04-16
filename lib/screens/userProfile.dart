import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, this.name, this.mail, this.bio})
      : super(key: key);
  final String? name;
  final String? mail;
  final String? bio;
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 500,
        height: 500,
        child: ListView(
          children: [
            ListTile(
              title: const Icon(Icons.person_pin_circle_outlined),
              trailing: Text(widget.name.toString()),
            ),
            ListTile(
              title: const Icon(Icons.mail),
              trailing: Text(widget.mail.toString()),
            ),
            ListTile(
              title: const Icon(Icons.abc_outlined),
              trailing: Text(widget.bio.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
