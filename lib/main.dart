import 'package:firechat/helper/config.dart';
import 'package:firechat/screens/allchats.dart';
import 'package:firechat/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FireChat());
}

class FireChat extends StatefulWidget {
  const FireChat({Key? key}) : super(key: key);

  @override
  State<FireChat> createState() => _FireChatState();
}

class _FireChatState extends State<FireChat> {
  bool isLoggedIn = false;
  @override
  void initState() {
    isUserLoggedIn();
    super.initState();
  }

  isUserLoggedIn() async {
    await SharedPreferencesConfig.getStatus().then((value) {
      setState(() {
        isLoggedIn = value.toString() == 'true' ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FireChat',
        theme: ThemeData(
            primarySwatch: Colors.amber,
            visualDensity: VisualDensity.comfortable,
            textTheme: GoogleFonts.poppinsTextTheme()),
        darkTheme: ThemeData(
            primaryColor: Colors.amber,
            visualDensity: VisualDensity.comfortable),
        home: isLoggedIn != null
            ? isLoggedIn
                ? const AllChats()
                : const SignIn()
            : const Center(
                child: SignIn(),
              ));
  }
}
