import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/article_category_constants.dart';
import 'package:utopia/controlller/new_article_screen_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_detail_textfield.dart';

class ArticleDetailDialog extends StatelessWidget {
  String? dropdownValue;
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController tag1Controller = TextEditingController();
  TextEditingController tag2Controller = TextEditingController();
  TextEditingController tag3Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 2),
      backgroundColor: Colors.white,
      title: const Text(
        "Add Article Details",
        style: TextStyle(fontFamily: "Fira"),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: displayWidth(context) * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArticleDetailTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Title cannot be empty";
                    }
                    return null;
                  },
                  controller: titleController,
                  label: "Tittle of article"),
              const SizedBox(height: 20),
              Consumer<NewArticleScreenController>(
                builder: (context, controller, child) {
                  return SizedBox(
                    height: displayHeight(context) * 0.07,
                    child: DropdownButtonFormField(
                      validator: (value) {
                        if (value!.toString().isEmpty) {
                          return "Please select any category";
                        }
                        return null;
                      },
                      onChanged: (String? selected) {
                        controller.changeCategory(selected!);
                      },
                      isExpanded: true,
                      value: dropdownValue,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 12, right: 10),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white54),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: const Text("Select Category"),
                      items: articleCategories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Add 3 tags",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              ArticleDetailTextField(
                  controller: tag1Controller,
                  label: "Tag 1",
                  validator: (p0) => null,
                  prefixIcon: Icon(Icons.auto_fix_high_rounded)),
              const SizedBox(height: 14),
              ArticleDetailTextField(
                controller: tag2Controller,
                label: "Tag 2",
                validator: (p0) => null,
                prefixIcon: Icon(Icons.auto_fix_high_rounded),
              ),
              const SizedBox(height: 14),
              ArticleDetailTextField(
                controller: tag3Controller,
                label: "Tag 2",
                validator: (p0) => null,
                prefixIcon: Icon(Icons.auto_fix_high_rounded),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: EdgeInsets.only(right: 20,top: 0,bottom: 8),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel",style: TextStyle(color: Color(0xfb40B5AD),fontSize: 16,letterSpacing: 0.5)),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text("Publish Article",style: TextStyle(color: Color(0xfb40B5AD),fontSize: 16,letterSpacing: 0.2)),
        ),
      ],
    );
  }
}
