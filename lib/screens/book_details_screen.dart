// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/models/review_model.dart';
import 'package:graduation_project/services/apis/bookmark_service.dart';
import 'package:graduation_project/services/apis/reviews_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  Future<void> _dialogBuilder(BuildContext context, int bookId) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ReviewFormDialog(
          bookId: bookId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)!.settings.arguments) as BookModel;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(arguments.user!.profilePicture!),
            ),
            const SizedBox(width: 10),
            Text(arguments.user!.name!),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookDetailsWidget(arguments: arguments),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Book Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            //* Book Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                arguments.description!,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                  // color: paragraphColor,
                ),
              ),
            ),
            //* END Book Description
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  label: const Icon(Icons.bookmark),
                  heroTag: null,
                  onPressed: () async {
                    bool success = await BookmarkService().addBookmark(
                      bookId: arguments.id!,
                      userId: BlocProvider.of<AuthCubit>(context)
                          .userData!
                          .data!
                          .id!,
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bookmarked successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Already in your bookmarks'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  // child: const Icon(Icons.bookmark),
                ),
                FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/chat', arguments: {
                      'sellerId': arguments.userId!,
                      'buyerId': BlocProvider.of<AuthCubit>(context)
                          .userData!
                          .data!
                          .id,
                      'bookId': arguments.id!,
                      'talkTo': arguments.user!.name!,
                      'image': arguments.user!.profilePicture!,
                      'phone': arguments.user!.phone!,
                    });
                  },
                  label: const Text("Chat"),
                  icon: const Icon(Icons.chat),
                ),
                FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () async {
                    await launchUrlString('tel:${arguments.user!.phone!}');
                  },
                  label: const Text("Call"),
                  icon: const Icon(Icons.phone),
                ),
              ],
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _dialogBuilder(context, arguments.id!.toInt());
                          },
                          child: const Text("Review"),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: const Text('Login to contact the owner'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Reviews', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 20),
            //* Reviews
            FutureBuilder<List<ReviewModel>>(
                future: ReviewsService().getReviews(arguments.id!.toInt()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return snapshot.data!.isEmpty
                        ? const Text('No reviews')
                        : ReviewsList(reviews: snapshot.data!);
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class ReviewFormDialog extends StatefulWidget {
  const ReviewFormDialog({
    super.key,
    required this.bookId,
  });
  final int bookId;

  @override
  State<ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<ReviewFormDialog> {
  TextEditingController reviewController = TextEditingController();
  double rating = 3.5;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Submit a review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Rate the book'),
          RatingBar.builder(
            initialRating: 3.5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                this.rating = rating;
              });
              log(rating.toString());
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: reviewController,
            decoration: const InputDecoration(
              hintText: 'Write your review here',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Submit'),
          onPressed: () async {
            bool success = await ReviewsService().addReview(
              bookId: widget.bookId,
              rating: rating,
              review: reviewController.text,
              token: BlocProvider.of<AuthCubit>(context).userData!.token!,
            );
            if (success) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review submitted successfully'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to submit review'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class ReviewsList extends StatelessWidget {
  const ReviewsList({
    super.key,
    required this.reviews,
  });
  final List<ReviewModel> reviews;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return ReviewWidget(
            review: reviews[index],
          );
        },
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    super.key,
    required this.review,
  });
  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                review.user!.profilePicture!,
                width: 40,
              ),
            ),
            const SizedBox(width: 20),
            Text(review.user!.name!),
            const Spacer(),
            Builder(
              builder: (context) {
                if (review.userId ==
                    BlocProvider.of<AuthCubit>(context).userData?.data?.id) {
                  return IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool success = await ReviewsService().deleteReview(
                        reviewId: review.id!.toInt(),
                        token: BlocProvider.of<AuthCubit>(context)
                            .userData!
                            .token!,
                      );
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Review deleted successfully'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to delete review'),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          review.reviewText ?? '',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text('Rating: ${review.rating}'),
            const SizedBox(width: 10),
            RatingBarIndicator(
                rating: review.rating!.toDouble(),
                itemBuilder: (context, index) =>
                    const Icon(Icons.star, color: Colors.amber),
                itemSize: 20),
            const SizedBox(width: 20),
            Text(
              '${review.createdAt}',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

class BookDetailsWidget extends StatelessWidget {
  const BookDetailsWidget({
    super.key,
    required this.arguments,
  });

  final BookModel arguments;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/book-details-bg.png',
                // height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                height: 350,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Hero(
                    tag: arguments.id!,
                    child: CachedNetworkImage(
                      imageUrl: arguments.image!,
                      height: 200,
                      width: 130,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 200,
                          width: 100,
                          color: Colors.grey,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  arguments.title!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "myfont5",
                  ),
                ),
                Text(
                  arguments.author!,
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                Text(
                  arguments.availability == 'swap'
                      ? '🤝'
                      : '${arguments.price}EGP',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD4D2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BookDetailsInfo(
                        value:
                            '${arguments.reviewsAvgRating?.toStringAsFixed(2) ?? '0'}⭐',
                        title: 'Rating',
                      ),
                      BookDetailsInfo(
                        value: arguments.user!.location!,
                        title: 'Address',
                      ),
                      BookDetailsInfo(
                        value: arguments.category!.name!,
                        title: 'Category',
                      ),
                      BookDetailsInfo(
                        value: '${arguments.status}',
                        title: 'Status',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookDetailsInfo extends StatelessWidget {
  const BookDetailsInfo({
    super.key,
    required this.value,
    required this.title,
  });
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "myfont5",
              color: Color(0xFF323232)),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "myfont5",
              color: Color(0xFF756F6F)),
        ),
      ],
    );
  }
}
