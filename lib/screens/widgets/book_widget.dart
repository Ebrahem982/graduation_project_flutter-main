import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:shimmer/shimmer.dart';

class BookWidget extends StatelessWidget {
  const BookWidget({
    super.key,
    required this.book,
    required this.isSwapBook,
  });
  final BookModel book;
  final bool isSwapBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      width: isSwapBook ? 160 : 100,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/book-details',
            arguments: book,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(5, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: book.id!,
                  child: CachedNetworkImage(
                    imageUrl: book.image!,
                    height: isSwapBook ? 240 : 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.surface,
                      highlightColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                      child: Container(
                        height: isSwapBook ? 240 : 140,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Title
            Flexible(
              child: Text(
                book.title!,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: "myfont4",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // author
            Text(
              book.author!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            ),
            Row(
              children: [
                Text(
                  '⭐ ${book.reviewsAvgRating != null ? book.reviewsAvgRating!.toStringAsFixed(2) : '0'}',
                  style: const TextStyle(fontSize: 12, color: Colors.amber),
                ),
                const SizedBox(width: 5),
                // Text(
                //   book.availability == 'sale' ? '${book.price}EGP' : '| ',
                //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                // ),
                Builder(
                  builder: (context) {
                    if (book.availability == 'sale') {
                      return Text(
                        '${book.price} EGP',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      );
                    } else {
                      return Image.asset(
                        'assets/images/swap-icon.png',
                        width: 35,
                      );
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
