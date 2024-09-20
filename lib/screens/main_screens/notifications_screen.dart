import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/screens/widgets/app_bar.dart';
import 'package:graduation_project/screens/widgets/please_login_widget.dart';
import 'package:graduation_project/services/apis/notification_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';

import '../../models/notification_model.dart';
import '../../services/cubits/auth/auth_cubit.dart';

class NotificationsScreens extends StatelessWidget {
  const NotificationsScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarWidget(
          isHomeScreen: false,
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return FutureBuilder<List<NotificationModel>>(
              future: NotificationService().getNotifications(
                  token: BlocProvider.of<AuthCubit>(context).userData!.token!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(child: Text('No notifications'));
                    }
                    return NotificationsList(
                      notifications: snapshot.data!,
                    );
                  } else {
                    return const Center(child: Text('No notifications'));
                  }
                } else {
                  return const Center(child: Text('Error'));
                }
              },
            );
          } else {
            return const PleaseLoginWidget(message: "view your notifications");
          }
        },
      ),
    );
  }
}

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    super.key,
    required this.notifications,
  });
  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationWidget(
          notification: notifications[index],
        );
      },
    );
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.notification,
  });
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(notification.data!.image!,
                  height: 50, width: 50)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.data!.userName!),
              Text(notification.data!.title!),
            ],
          ),
        ],
      ),
    );
  }
}
