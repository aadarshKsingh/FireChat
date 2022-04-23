import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/screens/allchats.dart';
import 'package:firechat/screens/signup.dart';
import 'package:firechat/services/auth.dart';
import 'package:firechat/services/databaseSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../helper/config.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  final Function? toggle;
  const SignIn({Key? key, this.toggle}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //textfield controllers
  late TextEditingController _emailContr;
  late TextEditingController _passContr;

  final Authentications _auth = Authentications();
  bool isLoading = false;
  final _signInKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailContr = TextEditingController();
    _passContr = TextEditingController();
    super.initState();
  }

  signIn() async {
    if (_signInKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        print("validated");
      });

      await _auth
          .mailSignIn(_emailContr.text, _passContr.text)
          .then((value) async {
        if (value != null) {
          QuerySnapshot userInfoSnapshot =
              await Database().getUserInfo(_emailContr.text);
          SharedPreferencesConfig.storeStatus(true);
          await SharedPreferencesConfig.storeUsername(
              userInfoSnapshot.docs[0].get('name'));
          await SharedPreferencesConfig.storeMail(
              userInfoSnapshot.docs[0].get('mail'));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AllChats()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(children: [
      Image.asset(
        "assets/images/bg.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fitHeight,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Welcome to FireChat",
            style: GoogleFonts.roboto(fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? Container(
                child: const Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          clipBehavior: Clip.antiAlias,
                          child: SvgPicture.asset('assets/images/fire.svg',
                              height: size.height * 0.2,
                              width: size.width * 0.2,
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Form(
                        key: _signInKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8.0),
                              child: TextFormField(
                                validator: (value) {
                                  return value!.contains('@')
                                      ? null
                                      : "Invalid mail";
                                },
                                controller: _emailContr,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.mail),
                                  labelText: "Email",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8.0),
                              child: TextFormField(
                                controller: _passContr,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.password_outlined),
                                  labelText: "Password",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                          text: TextSpan(text: "", children: [
                        TextSpan(
                            text: "Forgot Password?       ",
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = (() =>
                                  _auth.forgotPassword(_emailContr.text)))
                      ])),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    ElevatedButton(
                      onPressed: () => signIn(),
                      child: const Text("Sign in"),
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.4,
                              vertical: size.height * 0.03),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          primary: Colors.blueGrey[300]),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          Authentications().signInWithGoogle(context),
                      child: const Text("Sign in with Google"),
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.3,
                              vertical: size.height * 0.03),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          primary: Colors.blueGrey[200]),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Don't have account?"),
                        GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            child: const Text(
                              "Register Now",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp())),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
      ),
    ]);
  }
}
