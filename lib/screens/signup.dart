import 'package:firechat/helper/config.dart';
import 'package:firechat/screens/allchats.dart';
import 'package:firechat/services/databaseSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth.dart';
import 'signin.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  final Function? toggle;
  const SignUp({Key? key, this.toggle}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  Authentications auth = Authentications();
  final Database _dbObj = Database();
  late TextEditingController _usernameContr;
  late TextEditingController _emailContr;
  late TextEditingController _passContr;
  final _signUpKey = GlobalKey<FormState>();
  final String passRegex =
      r'^.*(?=.{8,})(?=.*[a-zA-Z])(?=.*\d)(?=.*[!#$%&? @"]).*$';
  final String mailPattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  @override
  void initState() {
    _usernameContr = TextEditingController();
    _emailContr = TextEditingController();
    _passContr = TextEditingController();
    super.initState();
  }

  signUp() {
    if (_signUpKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      SharedPreferencesConfig.storeMail(_emailContr.text);
      SharedPreferencesConfig.storeUsername(_usernameContr.text);
      auth.mailSignUp(_emailContr.text, _passContr.text).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const AllChats()));
        _dbObj.addUserInfo(_usernameContr.text, _emailContr.text);
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
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "Welcome to FireChat",
              style: GoogleFonts.roboto(fontSize: 30),
            )),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: FittedBox(
                        clipBehavior: Clip.antiAlias,
                        child: SvgPicture.asset('assets/images/fire.svg',
                            height: size.height * 0.2,
                            width: size.width * 0.2,
                            fit: BoxFit.scaleDown),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Form(
                      key: _signUpKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8.0),
                            child: TextFormField(
                              validator: (value) {
                                return value!.length < 8
                                    ? "Username should container more than 8 char"
                                    : null;
                              },
                              controller: _usernameContr,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.person),
                                labelText: "Username",
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
                              validator: (value) =>
                                  value!.contains(RegExp(mailPattern))
                                      ? null
                                      : "Invalid Email",
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
                              validator: (value) {
                                return value!.contains(RegExp(passRegex))
                                    ? null
                                    : "Invalid Password";
                              },
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
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    ElevatedButton(
                      onPressed: () => signUp(),
                      child: const Text("Sign up"),
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
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Already Registered ? "),
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn())),
                        )
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
