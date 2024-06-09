// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/chat_model.dart';
import 'package:graduation_project/screens/widgets/please_login_widget.dart';
import 'package:graduation_project/screens/widgets/profile_appbar_widget.dart';
import 'package:graduation_project/services/apis/chat_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';
import '../../services/cubits/auth/auth_cubit.dart';

class UserChatsScreen extends StatelessWidget {
  const UserChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/chat_bg.png"),
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                toolbarHeight: 100,
                centerTitle: true,
                title: Image.asset(
                  "assets/images/logo1.png",
                  height: 100,
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/categories");
                  },
                  icon: const Icon(Icons.grid_view_rounded),
                ),
                actions: const [
                  ProfileAppBarWidget(),
                ],
              ),
              body: const UserChats(),
            ),
          );
        } else {
          return const PleaseLoginWidget(
            message: 'view your chats',
          );
        }
      },
    );
  }
}

class UserChats extends StatelessWidget {
  const UserChats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatModel>>(
      future: ChatService().getUserChats(
        userId: BlocProvider.of<AuthCubit>(context).userData!.data!.id!,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching chats'),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No chats'),
            );
          } else {
            return UserChatsList(
              chats: snapshot.data!,
            );
          }
        } else {
          return const Center(
            child: Text('No chats'),
          );
        }
      },
    );
  }
}

class UserChatsList extends StatelessWidget {
  const UserChatsList({
    super.key,
    required this.chats,
  });
  final List<ChatModel> chats;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ChatWidget(
            chat: chats[index],
            isBuying: chats[index].buyerId ==
                BlocProvider.of<AuthCubit>(context).userData!.data!.id!);
      },
    );
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.chat,
    required this.isBuying,
  });

  final ChatModel chat;
  final bool isBuying;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete chat?'),
              content: const Text('Are you sure you want to delete this chat?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
                TextButton(
                  onPressed: () async {
                    bool deleted = await ChatService().deleteChat(
                      chatId: chat.id!,
                      token:
                          BlocProvider.of<AuthCubit>(context).userData!.token!,
                    );
                    if (deleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chat deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).pushReplacementNamed('/main');
                    } else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error deleting chat'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onTap: () {
        Navigator.of(context).pushNamed('/chat', arguments: {
          'sellerId': chat.seller!.id!,
          'buyerId': chat.buyer!.id!,
          'bookId': chat.book!.id!,
          'talkTo': isBuying ? chat.seller!.name! : chat.buyer!.name!,
          'image': isBuying
              ? chat.seller!.profilePicture!
              : chat.buyer!.profilePicture!,
          'phone': isBuying ? chat.seller!.phone! : chat.buyer!.phone!,
          'chatId': chat.id!,
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 200,
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
                  imageUrl: chat.book!.image!,
                  // height: 180,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                            chat.book!.title!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          chat.createdAt!,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(chat.book!.author!),
                    const SizedBox(height: 10),
                    Text(
                      chat.book!.availability == 'sale'
                          ? '${chat.book!.price!}EGP'
                          : '🤝',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                            'with: ${isBuying ? chat.seller!.name! : chat.buyer!.name!}'),
                        const Spacer(),
                        Builder(
                          builder: (context) {
                            if (chat.sellerId ==
                                BlocProvider.of<AuthCubit>(context)
                                    .userData!
                                    .data!
                                    .id!) {
                              return const Text('selling',
                                  style: TextStyle(color: Colors.green));
                            } else {
                              return const Text('buying',
                                  style: TextStyle(color: Colors.red));
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
