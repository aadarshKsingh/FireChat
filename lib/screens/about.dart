import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              "About the app",
              style: TextStyle(letterSpacing: 3),
            ),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              Image.asset(
                "assets/images/fire.png",
                height: 200,
                width: 200,
                alignment: Alignment.center,
              ),
              const Text(
                "FireChat",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
              ),
              const Text(
                "v0.1.0 Alpha",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 70.0),
              const Text(
                "This is an open-source project and can be found on ",
                style: TextStyle(fontSize: 17),
              ),
              GestureDetector(
                child: const Icon(EvilIcons.sc_github, size: 150),
                onTap: () => _launchURL(),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "If you liked my work",
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "show some",
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesome5.heart),
                  ),
                  Text(
                    "and",
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesome5.star),
                  ),
                  Text(
                    "the repo",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Made with ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(EvilIcons.heart),
                  Text(
                    "by Aadarsh K. Singh",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              )
            ],
          )),
    );
  }
}

_launchURL() async {
  const url = 'https://github.com/aadarshKsingh/FireChat';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
