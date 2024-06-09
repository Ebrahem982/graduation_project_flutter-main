import 'package:flutter/material.dart';

// import '../../constants/colors.dart';
import 'feature_item.dart';

class FeaturesList extends StatelessWidget {
  const FeaturesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      height: 130,
      child: PageView(
        padEnds: false,
        scrollDirection: Axis.horizontal,
        controller: PageController(
          viewportFraction: 0.69,
        ),
        children: const [
          FeatureItem(
            title: "Swap your books with others",
            image: 'assets/svg/books.svg',
            // bgColor: primaryRed,
            // textColor: Color(0xFFFFFFFF),
          ),
          FeatureItem(
            title: "Buy books from other users",
            image: 'assets/svg/buy_book.svg',
            // bgColor: primaryRed,
            // textColor: Color(0xFFFFEFE8),
          ),
          FeatureItem(
            title: "Browse textbooks for sale or for free",
            image: 'assets/svg/study_books.svg',
            // bgColor: primaryRed,
            // textColor: Color(0xFFFFEFE8),
          ),
        ],
      ),
    );
  }
}
