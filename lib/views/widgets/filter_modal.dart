import 'package:animexhub/extensions/string_extension.dart';
import 'package:animexhub/models/ani_pic.dart';
import 'package:animexhub/providers/anipic_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final TextEditingController _tagController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<AnimePicsProvider>(
        builder: (context, animePicsProviderRating, child) {
          return SingleChildScrollView(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: const Text(
                    "Filters",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Rating",
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            animePicsProviderRating.clearRating();
                            animePicsProviderRating.clearTags();
                            animePicsProviderRating.clearAniPics();
                            animePicsProviderRating.loadMoreAniPics();
                          },
                          child: Text(
                            "Reset All",
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      children:
                          Rating.values.map((Rating rating) {
                            return FilterChip(
                              label: Text(rating.value.capitalize()),
                              selected: animePicsProviderRating.rating
                                  .contains(rating),
                              onSelected: (bool selected) {
                                if (selected) {
                                  animePicsProviderRating.addRating(
                                    rating,
                                  );
                                } else {
                                  if (animePicsProviderRating
                                          .rating
                                          .length ==
                                      1) {
                                    return;
                                  }
                                  animePicsProviderRating
                                      .removeRating(rating);
                                }
                                animePicsProviderRating
                                    .clearAniPics();
                                animePicsProviderRating
                                    .loadMoreAniPics();
                              },
                            );
                          }).toList(),
                    ),
                  ],
                ),
                const Text("Tags", style: TextStyle(fontSize: 16)),
                TextField(
                  controller: _tagController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    label: const Text("Add a tag"),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (_tagController.text.isEmpty) return;
                    animePicsProviderRating.addTag(
                      _tagController.text,
                    );
                    _tagController.clear();
                    _tagController.clearComposing();
                    animePicsProviderRating.clearAniPics();
                    animePicsProviderRating.loadMoreAniPics();
                  },
                ),
                Wrap(
                  spacing: 8,
                  children:
                      animePicsProviderRating.tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            animePicsProviderRating.removeTag(tag);
                            animePicsProviderRating.clearAniPics();
                            animePicsProviderRating.loadMoreAniPics();
                          },
                        );
                      }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }
}
