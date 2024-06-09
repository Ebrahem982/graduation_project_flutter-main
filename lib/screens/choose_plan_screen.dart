import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduation_project/screens/widgets/primary_button.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

List<String> options = ["205", "380"];

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  String? currentOption = options[0];

  Color _borderColor = const Color(0xFFDE6A6A);
  Color _borderColor2 = Colors.transparent;

  void _changeCircleColor(Color color) {
    setState(() {
      _borderColor = color;
    });
  }

  void _changeCircleColor2(Color color) {
    setState(() {
      _borderColor2 = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)!.settings.arguments) as Map<String, dynamic>;
    final bookId = arguments['bookId'];
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color.fromARGB(255, 231, 200, 200),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Choose Plan'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/rocket.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        const Text(
                          "Feature Your Ad",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF33495F),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.56,
                          child: const Text(
                            "Reach more buyers and get noticed with ‘Featured’ tag in a top position",
                            softWrap: true,
                            style: TextStyle(
                              color: Color(0xFF33495F),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // * First Plan
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC0A5A5),
                    border: Border.all(color: _borderColor, width: 7),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Single featured ad for 7 days",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            "EGP 205",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.red),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Spacer(),
                          Text(
                            "EGP 265",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                decoration: TextDecoration.lineThrough),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            autofocus: true,
                            fillColor: MaterialStateProperty.all(Colors.brown),
                            value: options[0],
                            groupValue: currentOption,
                            onChanged: (value) {
                              setState(() {
                                currentOption = value;
                              });
                              _changeCircleColor(const Color(0xFFDE6A6A));
                              _changeCircleColor2(Colors.transparent);
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: const Text(
                                  "Your ad will stay among the top ads of the category pages over service validity",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Spacer(),
                          Image(image: AssetImage("assets/images/d-23.png"))
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // * Second Plan
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: const Color(0xFFC0A5A5),
                      border: Border.all(color: _borderColor2, width: 7),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Single featured ad for 14 days",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            "EGP 380",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.red),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Spacer(),
                          Text(
                            "EGP 410",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                decoration: TextDecoration.lineThrough),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            fillColor: MaterialStateProperty.all(Colors.brown),
                            value: options[1],
                            autofocus: true,
                            groupValue: currentOption,
                            onChanged: (value) {
                              setState(() {
                                currentOption = value;
                              });
                              _changeCircleColor2(const Color(0xFFDE6A6A));
                              _changeCircleColor(Colors.transparent);
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                decoration: const BoxDecoration(
                                    color: Color(0xFF987070),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: const Center(
                                  child: Text(
                                    "Best Seller",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: const Text(
                                  "Your ad will stay among the top ads of the category pages over service validity",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Spacer(),
                          Image(
                            image: AssetImage("assets/images/d-20.png"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                    text: 'Proceed to pay',
                    onPressed: () {
                      Navigator.pushNamed(context, '/choose-payment',
                          arguments: {'bookId': bookId, 'plan': currentOption});
                      log("$currentOption $bookId");
                    },
                    color: null)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
