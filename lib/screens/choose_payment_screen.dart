import 'package:flutter/material.dart';

class ChoosePaymentScreen extends StatelessWidget {
  const ChoosePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)!.settings.arguments) as Map<String, dynamic>;
    // final bookid = arguments['bookId'];
    final plan = arguments['plan'];
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
          title: const Text('Choose Payment Method'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 240,
                decoration: const BoxDecoration(
                    color: Color(0xFFD6C1C1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Center(
                  child: Text(
                    "Payment Methods",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F0F0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Single featured ad for 7 days",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          " EGP $plan",
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // * Payment Methods
              const PaymentMethodWidget(
                img: 'assets/images/wallet.png',
                title: 'Wallet',
                description: 'Pay with your Wallet',
              ),
              const SizedBox(
                height: 16,
              ),
              const PaymentMethodWidget(
                img: 'assets/images/fawry.png',
                title: 'Fawry',
                description: 'Pay with Fawry',
              ),
              const SizedBox(
                height: 16,
              ),
              const PaymentMethodWidget(
                img: 'assets/images/card.png',
                title: 'Card Payment',
                description: 'Pay with you Card',
              ),
              const SizedBox(
                height: 16,
              ),
              const PaymentMethodWidget(
                img: 'assets/images/vodafon.png',
                title: 'Vodafone Cash',
                description: 'Pay using Vodafone Cash',
              ),
              const SizedBox(
                height: 16,
              ),
              const PaymentMethodWidget(
                img: 'assets/images/orange.png',
                title: 'Orange Cash',
                description: 'Pay using Orange Cash',
              ),
              const SizedBox(
                height: 16,
              ),
              const PaymentMethodWidget(
                img: 'assets/images/etisalat.png',
                title: 'Etisalat Cash',
                description: 'Pay using Etisalat Cash',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethodWidget extends StatelessWidget {
  const PaymentMethodWidget({
    super.key,
    required this.img,
    required this.title,
    required this.description,
  });
  final String img;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(img),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
