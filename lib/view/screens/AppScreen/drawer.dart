import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/helper_widgets.dart';
import '../../../services/firebase/auth_services.dart';

class CustomDrawer extends StatelessWidget {
  final Logger _logger = Logger('CustomDrawer');

  final Authservice _auth = Authservice(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: displayWidth(context) * 0.3,
        padding: const EdgeInsets.only(left: 20, top: 25, right: 14),
        child: Consumer<UserController>(
          builder: (context, controller, child) {
            if (controller.profileStatus == ProfileStatus.nil) {
              controller.setUser(FirebaseAuth.instance.currentUser!.uid);
            }

            switch (controller.profileStatus) {
              case ProfileStatus.nil:
                return Center(
                  child: MaterialButton(
                    color: authMaterialButtonColor,
                    onPressed: () {
                      controller
                          .setUser(FirebaseAuth.instance.currentUser!.uid);
                    },
                    child: const Text('Refresh Profile'),
                  ),
                );
              case ProfileStatus.loading:
                return const Center(
                  child:
                      CircularProgressIndicator(color: authMaterialButtonColor),
                );
              case ProfileStatus.fetched:
                List<String> initials = controller.user!.name.split(" ");
                String firstLetter = "", lastLetter = "";

                if (initials.length == 1) {
                  firstLetter = initials[0].characters.first;
                } else {
                  firstLetter = initials[0].characters.first;
                  lastLetter = initials[1].characters.first;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: CircleAvatar(
                        radius: displayWidth(context) * 0.125,
                        backgroundColor: Colors.white,
                        child: (controller.user!.dp.isEmpty)
                            ? CircleAvatar(
                                backgroundColor: authMaterialButtonColor,
                                radius: displayWidth(context) * 0.12,
                                child: Center(
                                  child: initials.length > 1
                                      ? Text(
                                          "$firstLetter.$lastLetter"
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        )
                                      : Text(
                                          firstLetter.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                ),
                              )
                            : CircleAvatar(
                                radius: displayWidth(context) * 0.12,
                                backgroundImage: CachedNetworkImageProvider(
                                    controller.user!.dp),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Text(
                        '@${controller.user!.name}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Fira"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Follower detail box
                    Container(
                      height: displayHeight(context) * 0.08,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.user!.followers.length.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.user!.following.length.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                'Following',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    drawerTile(
                        'Write new article',
                        const Icon(
                          size: 22,
                          Icons.edit,
                          color: Colors.white70,
                        ),
                        () => Navigator.pushNamed(context, '/newArticle')),
                    drawerTile(
                        'My articles',
                        const Icon(
                          size: 22,
                          Icons.book_sharp,
                          color: Colors.white70,
                        ),
                        () => Navigator.pushNamed(context, '/myArticles')),
                    drawerTile(
                        'Search articles',
                        const Icon(
                          size: 22,
                          Icons.search_rounded,
                          color: Colors.white70,
                        ),
                        () => _logger.info("Search")),
                    drawerTile(
                        'Saved articles',
                        const Icon(
                          size: 22,
                          Icons.bookmark_add_outlined,
                          color: Colors.white70,
                        ),
                        () => _logger.info("Search")),
                    drawerTile(
                        'Notifications',
                        const Icon(
                          size: 22,
                          Icons.notifications_none_rounded,
                          color: Colors.white70,
                        ),
                        () => _logger.info("Notifications")),
                    drawerTile(
                        'Logout',
                        const Icon(
                          Icons.logout,
                          size: 22,
                          color: Colors.white70,
                        ), () async {
                      final navigator = Navigator.of(context);
                      await _auth.signOut();
                      navigator.pushReplacementNamed('/auth');
                    }),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
