import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubCategories extends ConsumerStatefulWidget {
  static String routeName = '/subcategories';
  const SubCategories({super.key});

  @override
  ConsumerState<SubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends ConsumerState<SubCategories> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    Future(() {
      ref.read(subCategoriesIdProvider.notifier).state = arguments[1];
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(arguments[0]),
      ),
    );
  }
}
