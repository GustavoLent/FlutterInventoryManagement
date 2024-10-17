import 'package:flutter/material.dart';

import 'package:inventory_management/src/pages/home_page.dart';
import 'package:inventory_management/src/pages/inventory_page.dart';
import 'package:inventory_management/src/models/tree_node.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      onGenerateRoute: (RouteSettings routeSettings) {
        switch (routeSettings.name) {
          case InventoryPage.routeName:
            final List<TreeNode> companyTree = routeSettings.arguments as List<TreeNode>;
            return MaterialPageRoute<void>(
              builder: (BuildContext context) => InventoryPage(companyTree: companyTree),
            );
          case HomePage.routeName:
          default:
            return MaterialPageRoute<void>(
              builder: (BuildContext context) => const HomePage(),
            );
        }
      },
    );
  }
}
