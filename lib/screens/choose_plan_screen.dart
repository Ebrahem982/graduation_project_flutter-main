import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduation_project/screens/widgets/primary_button.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  static const options = ["plan1", "plan2"];
  String? currentOption = options[0];
  Color borderColor1 = const Color(0xFFDE6A6A);
  Color borderColor2 = Colors.transparent;

  void _selectPlan(String plan) {
    setState(() {
      currentOption = plan;
      if (plan == options[0]) {
        borderColor1 = const Color(0xFFDE6A6A);
        borderColor2 = Colors.transparent;
      } else {
        borderColor1 = Colors.transparent;
        borderColor2 = const Color(0xFFDE6A6A);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildPlan(
                title: "Single featured ad for 7 days",
                price: 205,
                originalPrice: 265,
                isSelected: currentOption == options[0],
                borderColor: borderColor1,
                plan: options[0],
                onTap: () => _selectPlan(options[0]),
              ),
              const SizedBox(height: 20),
              _buildPlan(
                title: "Single featured ad for 14 days",
                price: 380,
                originalPrice: 410,
                isSelected: currentOption == options[1],
                borderColor: borderColor2,
                plan: options[1],
                onTap: () => _selectPlan(options[1]),
                isBestSeller: true,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Proceed to pay',
                onPressed: () {
                  Navigator.pushNamed(context, '/choose-payment',
                      arguments: {'bookId': bookId, 'plan': currentOption});
                  log("$currentOption $bookId");
                }, color: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/rocket.png',
          width: 100,
          height: 100,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
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
              const SizedBox(height: 5),
              const Text(
                "Reach more buyers and get noticed with ‘Featured’ tag in a top position",
                style: TextStyle(
                  color: Color(0xFF33495F),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlan({
    required String title,
    required int price,
    required int originalPrice,
    required bool isSelected,
    required Color borderColor,
    required String plan,
    required VoidCallback onTap,
    bool isBestSeller = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFC0A5A5),
          border: Border.all(color: borderColor, width: 7),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Spacer(),
                Text(
                  "EGP $price",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.red.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Spacer(),
                Text(
                  "EGP $originalPrice",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isBestSeller)
              Container(
                width: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF987070),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Center(
                  child: Text(
                    "Best Seller",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 5),
            Row(
              children: [
                Radio<String>(
                  fillColor: MaterialStateProperty.all(Colors.brown),
                  value: plan,
                  groupValue: currentOption,
                  onChanged: (value) => onTap(),
                ),
                Expanded(
                  child: Text(
                    "Your ad will stay among the top ads of the category pages over service validity",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Spacer(),
                Image.asset("assets/images/d-23.png"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
