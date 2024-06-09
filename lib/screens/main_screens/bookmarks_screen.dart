// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/bookmark_model.dart';
import 'package:graduation_project/screens/widgets/please_login_widget.dart';
import 'package:graduation_project/services/apis/bookmark_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';

class BookMarksScreen extends StatefulWidget {
  const BookMarksScreen({super.key});

  @override
  State<BookMarksScreen> createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  var future;

  getBookmarks() async {
    future = BookmarkService().getUserBookmarks(
      id: BlocProvider.of<AuthCubit>(context).userData!.data!.id!,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bookmark_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Bookmark'),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return FutureBuilder<List<BookmarkModel>>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text('No bookmarks'));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return BookmarkWidget(
                            bookmark: snapshot.data![index],
                            getBookmarks: getBookmarks,
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No bookmarks'));
                    }
                  } else {
                    return const Center(child: Text('Error'));
                  }
                },
              );
            } else {
              return const PleaseLoginWidget(message: "view your bookmarks");
            }
          },
        ),
      ),
    );
  }
}

class BookmarkWidget extends StatelessWidget {
  const BookmarkWidget({
    super.key,
    required this.bookmark,
    required this.getBookmarks,
  });
  final BookmarkModel bookmark;
  final VoidCallback getBookmarks;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/book-details', arguments: bookmark.book);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(10, 5),
                      ),
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: bookmark.book!.image!,
                    // height: 150,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              bookmark.book!.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final bool removed =
                                  await BookmarkService().removeBookmark(
                                bookMarkId: bookmark.id!,
                                token: BlocProvider.of<AuthCubit>(context)
                                    .userData!
                                    .token!,
                              );
                              if (removed) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Bookmark removed'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                getBookmarks();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Error removing bookmark'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.bookmark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(bookmark.book!.author!),
                      const SizedBox(height: 10),
                      Builder(
                        builder: (context) {
                          if (bookmark.book!.availability == 'sale') {
                            return Text("${bookmark.book!.price} EGP");
                          } else {
                            return const Icon(Icons.handshake);
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
