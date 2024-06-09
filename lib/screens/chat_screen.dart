// ignore_for_file: use_build_context_synchronously

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/chat_model.dart';
import 'package:graduation_project/models/message_model.dart';
import 'package:graduation_project/services/apis/chat_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../services/cubits/auth/auth_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)!.settings.arguments) as Map<String, dynamic>;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFCEAEA), Color(0xFFD6C1C1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFFE28789),
          toolbarHeight: 80,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(arguments['image']),
              ),
              const SizedBox(width: 5),
              Text('${arguments['talkTo']}'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await launchUrlString('tel:${arguments['phone']}');
              },
              icon: const Icon(Icons.call),
            ),
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    title: const Text(
                      'Delete Chat',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete chat?'),
                            content: const Text(
                                'Are you sure you want to delete this chat?'),
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
                                    chatId: arguments['chatId'],
                                    token: BlocProvider.of<AuthCubit>(context)
                                        .userData!
                                        .token!,
                                  );
                                  if (deleted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Chat deleted successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.of(context)
                                        .pushReplacementNamed('/main');
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
                  ),
                ),
              ];
            }),
          ],
        ),
        body: FutureBuilder<ChatModel?>(
          future: ChatService().chatExists(
            sellerId: arguments['sellerId'],
            buyerId: arguments['buyerId'],
            bookId: arguments['bookId'],
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return Chat(
                chat: snapshot.data!,
              );
            }
            return const Text('Chat does not exist');
          },
        ),
      ),
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({super.key, required this.chat});
  final ChatModel chat;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Future<List<MessageModel>>? messages;

  void getMessages() {
    setState(() {
      messages = ChatService().getMessages(
        chatId: widget.chat.id!,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<MessageModel>>(
            future: messages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return MessagesList(
                  messages: snapshot.data!,
                );
              }
              return const Text('No messages');
            },
          ),
        ),
        MessageBar(
          messageBarColor: Colors.transparent,
          sendButtonColor: Theme.of(context).colorScheme.tertiary,
          messageBarHintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),
          messageBarHintText: "Type a message...",
          onSend: (p0) async {
            await ChatService().sendMessage(
              message: p0,
              chatId: widget.chat.id!,
              token: BlocProvider.of<AuthCubit>(context).userData!.token!,
            );
            getMessages();
          },
        ),
      ],
    );
  }
}

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
    required this.messages,
  });
  final List<MessageModel> messages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        reverse: true,
        itemBuilder: (context, index) {
          return MessageWidget(
            message: messages[index],
          );
        },
        itemCount: messages.length,
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.message});
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateChip(
            date: DateTime.parse(message.createdAt!),
            color: Theme.of(context).colorScheme.tertiaryContainer),
        BubbleNormal(
          text: message.content!,
          isSender: message.senderId ==
              BlocProvider.of<AuthCubit>(context).userData!.data!.id!,
          color: message.senderId ==
                  BlocProvider.of<AuthCubit>(context).userData!.data!.id!
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.secondaryContainer,
          trailing: const Icon(Icons.check),
        ),
      ],
    );
  }
}
