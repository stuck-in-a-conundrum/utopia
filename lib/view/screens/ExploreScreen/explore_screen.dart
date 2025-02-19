import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:utopia/constants/article_category_constants.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/articles_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';
import 'package:utopia/view/screens/ExploreScreen/components/search_box.dart';
import 'package:utopia/view/shimmers/article_shimmer.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({Key? key}) : super(key: key);
  final Logger _logger = Logger("ExploreScreen");
  PageController articlePageController = PageController();
  ItemScrollController articleCategoryController = ItemScrollController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newArticle');
        },
        backgroundColor: authBackground,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SearchBox(),
          // const SizedBox(height: 10),

          // ArticleCategoryTab(),
          SizedBox(
              // color: Colors.red.shade100,
              height: displayHeight(context) * 0.06,
              width: displayWidth(context),
              child: Consumer<ArticlesController>(
                builder: (context, controller, child) {
                  return ScrollablePositionedList.builder(
                    itemScrollController: articleCategoryController,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextButton(
                          child: Text(
                            controller.articles.keys.toList()[index],
                            style: TextStyle(
                                fontSize: 14,
                                color: controller.selectedCategory == index
                                    ? Colors.black87
                                    : Colors.black54,
                                fontWeight: controller.selectedCategory == index
                                    ? FontWeight.w400
                                    : FontWeight.normal,
                                fontFamily: "Fira"),
                          ),
                          onPressed: () {
                            controller.selectCategory(index);
                            articleCategoryController.scrollTo(
                                duration: const Duration(microseconds: 2),
                                index: index,
                                alignment: 0.4);
                            articlePageController.animateToPage(index,
                                duration: const Duration(microseconds: 2),
                                curve: Curves.bounceInOut);
                          },
                        ),
                      );
                    },
                    itemCount: controller.articles.length,
                  );
                },
              )),

          const SizedBox(height: 4),

          // List Body to display articles.
          Expanded(
            child: Consumer<ArticlesController>(
              builder: (context, controller, child) {
                return PageView.builder(
                  controller: articlePageController,
                  onPageChanged: (index) {
                    articleCategoryController.scrollTo(
                        duration: const Duration(microseconds: 5),
                        index: index,
                        alignment: 0.5);
                    controller.selectCategory(index);
                  },
                  itemCount: articleCategoriesForDisplaying.length,
                  itemBuilder: (context, index) {
                    return Consumer<ArticlesController>(
                      builder: (context, controller, child) {
                        if (controller.articlesStatus == ArticlesStatus.nil) {
                          controller.fetchArticles();
                        }
                        switch (controller.articlesStatus) {
                          case ArticlesStatus.nil:
                            return const Center(
                              child: Text("Swipe to refresh"),
                            );

                          case ArticlesStatus.fetched:
                            return ListView.builder(
                              itemCount: controller
                                  .articles[articleCategoriesForDisplaying[
                                      controller.selectedCategory]]!
                                  .length,
                              itemBuilder: (context, index) {
                                // return ArticleSkeleton();
                                return ArticleBox(
                                    article: controller.articles[
                                        articleCategoriesForDisplaying[
                                            controller
                                                .selectedCategory]]![index]);
                              },
                            );
                          case ArticlesStatus.fetching:
                            return ListView.builder(
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return const ShimmerForArticles();
                              },
                            );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
