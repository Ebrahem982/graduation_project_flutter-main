import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/icon4.png"), fit: BoxFit.fill),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo1.png",
                  height: 320,
                  width: 244,
                ),
                const Text(
                  "Book Deal",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    height: 2,
                    fontWeight: FontWeight.w900,
                    fontFamily: "myfont1",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                    padding: EdgeInsets.only(
                  left: 45,
                  right: 45,
                )),
                const Text(
                  "Find your dream book according to your preferemce and join to our family.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: "myfont2"),
                ),
                const SizedBox(
                  height: 35,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/get-started");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 207, 147, 146)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11))),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: "myfont3",
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
