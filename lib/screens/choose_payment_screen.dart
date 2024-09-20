// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/services/apis/books_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ChoosePaymentScreen extends StatelessWidget {
  const ChoosePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)!.settings.arguments) as Map<String, dynamic>;
    final bookid = arguments['bookId'];
    final plan = arguments['plan'];
    final price = plan == 'plan1' ? 205 : 380;
    final days = plan == 'plan1' ? 7 : 14;
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
          child: SingleChildScrollView(
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
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
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
                          Text(
                            "Single featured ad for $days days",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            " EGP $price",
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
                PaymentMethodWidget(
                  img: 'assets/images/wallet.png',
                  title: 'Wallet',
                  description: 'Pay with your Wallet',
                  bookid: bookid,
                  days: days,
                  price: price,
                  method: 'wallet',
                ),
                const SizedBox(
                  height: 16,
                ),
                PaymentMethodWidget(
                  img: 'assets/images/fawry.png',
                  title: 'Fawry',
                  description: 'Pay with Fawry',
                  bookid: bookid,
                  days: days,
                  price: price,
                  method: 'fawry',
                ),
                const SizedBox(
                  height: 16,
                ),
                PaymentMethodWidget(
                  img: 'assets/images/card.png',
                  title: 'Card Payment',
                  description: 'Pay with you Card',
                  bookid: bookid,
                  days: days,
                  price: price,
                  method: 'card',
                ),
                const SizedBox(
                  height: 16,
                ),
                PaymentMethodWidget(
                  img: 'assets/images/vodafon.png',
                  title: 'Vodafone Cash',
                  description: 'Pay using Vodafone Cash',
                  bookid: bookid,
                  days: days,
                  price: price,
                  method: 'vodafone cash',
                ),
                const SizedBox(
                  height: 16,
                ),
                PaymentMethodWidget(
                  img: 'assets/images/orange.png',
                  title: 'Orange Cash',
                  description: 'Pay using Orange Cash',
                  bookid: bookid,
                  days: days,
                  price: price,
                  method: 'orange cash',
                ),
                const SizedBox(
                  height: 16,
                ),
                PaymentMethodWidget(
                  img: 'assets/images/etisalat.png',
                  title: 'Etisalat Cash',
                  description: 'Pay using Etisalat Cash',
                  bookid: bookid,
                  days: days,
                  price: price,
                  method: 'etisalat cash',
                ),
              ],
            ),
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
    required this.price,
    required this.bookid,
    required this.days,
    required this.method,
  });
  final String img;
  final String title;
  final String description;
  final String method;
  final int price;
  final int bookid;
  final int days;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          text: 'Are you sure you want to pay $price EGP with your $method?',
          confirmBtnText: 'Yes',
          cancelBtnText: 'No',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () async {
            Navigator.pop(context);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              title: 'Loading',
              text: 'Processing payment...',
            );
            bool isSubscribed = await BooksServiceApi().makeSubscription(
              bookId: bookid,
              price: price,
              startDate: DateTime.now(),
              endDate: DateTime.now().add(Duration(days: days)),
              userId: BlocProvider.of<AuthCubit>(context).userData!.data!.id!,
            );

            if (isSubscribed) {
              Navigator.pop(context);
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: 'Success',
                text: 'Payment has been made successfully',
              );
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushReplacementNamed(context, '/main');
              });
            }
          },
        );
      },
      child: Container(
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
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
