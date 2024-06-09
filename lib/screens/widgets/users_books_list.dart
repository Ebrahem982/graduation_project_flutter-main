// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/services/apis/books_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';

class UserBookList extends StatelessWidget {
  const UserBookList({
    super.key,
    required this.books,
  });
  final List<BookModel> books;

  @override
  Widget build(BuildContext context) {
    return UsersBookWidget(books: books);
  }
}

class UsersBookWidget extends StatefulWidget {
  const UsersBookWidget({super.key, required this.books});
  final List<BookModel> books;

  @override
  State<UsersBookWidget> createState() => _UsersBookWidgetState();
}

class _UsersBookWidgetState extends State<UsersBookWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/edit-book',
              arguments: widget.books[index],
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 200,
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(5, 7),
                        blurRadius: 7,
                        spreadRadius: 0.7,
                      )
                    ],
                    border: Border.all(
                      color: const Color(0xFFB78682),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.books[index].image!,
                      // height: 180,
                      width: MediaQuery.of(context).size.width * 0.29,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE79696),
                      // border: Border.all(color: Colors.red),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(5, 7),
                          blurRadius: 7,
                          spreadRadius: 0.7,
                        )
                      ],
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.27,
                              child: Text(
                                widget.books[index].title!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(widget.books[index].createdAt!),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(widget.books[index].author!),
                        const SizedBox(height: 10),
                        Text(widget.books[index].availability == 'sale'
                            ? '${widget.books[index].price!}EGP'
                            : '🤝'),
                        const SizedBox(height: 10),
                        Builder(
                          builder: (context) {
                            if (widget.books[index].availability != 'sold') {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      bool isMarkedAsSold =
                                          await BooksServiceApi().markAsSold(
                                        bookId: widget.books[index].id!,
                                        token:
                                            BlocProvider.of<AuthCubit>(context)
                                                .userData!
                                                .token!,
                                      );
                                      if (isMarkedAsSold) {
                                        widget.books[index].availability =
                                            'sold';
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Book marked as sold'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        setState(() {});
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Failed to mark as sold'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        'Mark as Sold',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          '/choose-plan',
                                          arguments: {
                                            'bookId': widget.books[index].id,
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        'Sell Faster Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: const Text(
                                  'Sold',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      itemCount: widget.books.length,
    );
  }
}
