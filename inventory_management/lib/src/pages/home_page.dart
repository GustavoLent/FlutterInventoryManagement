import 'package:flutter/material.dart';

import 'package:inventory_management/src/services/api_service.dart';
import 'package:inventory_management/src/business/tree_builder.dart';

import 'package:inventory_management/src/models/company.dart';
import 'package:inventory_management/src/models/location.dart';
import 'package:inventory_management/src/models/asset.dart';
import 'package:inventory_management/src/models/tree_node.dart';

import 'package:inventory_management/src/pages/inventory_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();

  late Future<List<Company>> companiesFuture;

  @override
  void initState() {
    super.initState();

    companiesFuture = apiService.getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TRACTIAN", style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Company>>(
        future: companiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load companies.'));
          } else if (snapshot.hasData) {
            final companies = snapshot.data!;
            return ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final companyTree = await _handleCompanySelected(company.id);

                      if (companyTree != null) {
                        Navigator.pushNamed(
                          context,
                          InventoryPage.routeName,
                          arguments: companyTree,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.apartment, color: Colors.white, size: 40),
                        const SizedBox(width: 10),
                        Text(
                          "${company.name} Unit",
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No companies available.'));
          }
        },
      ),
    );
  }

  Future<List<TreeNode>?> _handleCompanySelected(String companyId) async {
    try {
      final locationsFuture = apiService.getLocations(companyId);
      final assetsFuture = apiService.getAssets(companyId);

      final List<Location> locations = await locationsFuture;
      final List<Asset> assets = await assetsFuture;

      TreeBuilder treeBuilder = TreeBuilder();
      List<TreeNode> companyTree = treeBuilder.buildTree(assets, locations);

      return companyTree;
    } catch (error) {
      debugPrint('[_handleCompanySelected] Error fetching locations or assets: $error');
    }

    return null;
  }
}
