import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/services/apis/bookmark_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';
import 'package:shimmer/shimmer.dart';

class SingleBookWidget extends StatelessWidget {
  const SingleBookWidget({
    super.key,
    required this.books,
  });
  final List<BookModel> books;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final authCubit = BlocProvider.of<AuthCubit>(context);
                  final userId = authCubit.userData?.data?.id;

                  if (userId != null) {
                    final book = books[index];
                    final routeName = book.userId == userId
                        ? '/edit-book'
                        : '/book-details';
                    await Navigator.of(context).pushNamed(
                      routeName,
                      arguments: book,
                    );
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9B8B8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: const Offset(6, 3),
                        ),
                      ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: books[index].image!,
                          height: 140,
                          width: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Theme.of(context).colorScheme.surface,
                            highlightColor: Theme.of(context)
                                .colorScheme
                                .surfaceVariant,
                            child: Container(
                              height: 140,
                              width: 100,
                              color: Colors.grey,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Title
              Text(
                books[index].title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Author
              Text(
                books[index].author!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BookChips(
                    text: Text(
                      "⭐ ${books[index].reviewsAvgRating == null ? '-' : books[index].reviewsAvgRating!.toStringAsFixed(1)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: const Color(0xFFFF8888),
                  ),
                  BookChips(
                    text: Text(
                      books[index].availability == "swap"
                          ? '🤝'
                          : 'EGP ${books[index].price}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.white,
                  ),
                  BookChips(
                    text: books[index].userId !=
                            BlocProvider.of<AuthCubit>(context)
                                .userData!
                                .data!
                                .id
                        ? GestureDetector(
                            onTap: () async {
                              final userId = BlocProvider.of<AuthCubit>(context)
                                  .userData!
                                  .data!
                                  .id;
                              bool success = await BookmarkService()
                                  .addBookmark(
                                      bookId: books[index].id!,
                                      userId: userId!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? 'Bookmarked successfully'
                                      : 'Already in your bookmarks'),
                                  backgroundColor:
                                      success ? Colors.green : Colors.red,
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.bookmark,
                              color: Color(0xFF414143),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/choose-plan',
                                  arguments: {
                                    'bookId': books[index].id,
                                  });
                            },
                            child: const Icon(
                              Icons.arrow_circle_up,
                              color: Color.fromARGB(255, 255, 204, 51),
                            ),
                          ),
                    color: const Color(0xFFFF8888),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class BookChips extends StatelessWidget {
  const BookChips({
    super.key,
    required this.text,
    required this.color,
  });

  final Widget text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: text,
    );
  }
}
