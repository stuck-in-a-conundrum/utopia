import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';

class NotificationBell extends StatelessWidget {
  NotificationBell({super.key});
  String myuid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .doc(myuid)
          .collection('notification')
          .where('read', isEqualTo: false)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          int numberOfNewNotification = snapshot.data.docs.length;
          if (numberOfNewNotification == 0) {
            return Image.asset(
              notificationIcon,
              width: 21,
              fit: BoxFit.contain,
              color: Colors.black,
            );
          } else {
            return Badge(
              elevation: 2,
              position: const BadgePosition(top: 3, isCenter: false, end: -6),
              badgeColor: Colors.red.shade400,
              badgeContent: Text(
                numberOfNewNotification.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              child: Image.asset(
                notificationIcon,
                width: 21,
                fit: BoxFit.contain,
                color: Colors.black,
              ),
            );
          }
        } else {
          return Image.asset(
            notificationIcon,
            width: 21,
            fit: BoxFit.contain,
            color: Colors.black,
          );
        }
      },
    );
  }
}
