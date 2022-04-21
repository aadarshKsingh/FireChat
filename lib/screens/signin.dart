import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/screens/allchats.dart';
import 'package:firechat/screens/signup.dart';
import 'package:firechat/services/auth.dart';
import 'package:firechat/services/databaseSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../helper/config.dart';

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
          SharedPreferencesConfig.storeMail(
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 50.0,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: Colors.amber),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.whatshot_rounded),
            SizedBox(
              width: 10.0,
            ),
            Text("Sign In")
          ]),
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
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: FittedBox(
                      clipBehavior: Clip.antiAlias,
                      child: SvgPicture.asset('assets/images/fire.svg',
                          height: size.height * 0.35,
                          width: size.width * 0.35,
                          fit: BoxFit.scaleDown),
                    ),
                  ),
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
                            ..onTap = (() => {}))
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
                        primary: Colors.amber[300]),
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
                        primary: Colors.amber[200]),
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
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                        ),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp())),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
    );
  }
}
