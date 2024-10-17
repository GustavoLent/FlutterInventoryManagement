import 'package:flutter/material.dart';

// Importing the core service class
import 'package:inventory_management/src/models/tree_node.dart';

class InventoryPage extends StatefulWidget {
  static const String routeName = '/inventory';

  final List<TreeNode> companyTree;

  const InventoryPage({super.key, required this.companyTree});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<TreeNode>? filteredTree;
  String? activeFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 16.0, // horizontal space
                runSpacing: 8.0, // vertical space
                children: [
                  filterButton("sensorType", "energy", "Sensor de Energia", Icons.bolt),
                  filterButton("sensorType", "vibration", "Sensor de Vibração", Icons.vibration_rounded),
                  filterButton("status", "alert", "Crítico", Icons.error_outline_rounded),
                ],
              ),
              filteredTree != null ? buildTree(filteredTree!) : buildTree(widget.companyTree),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTree(List<TreeNode> nodes) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nodes.map((node) {
        return buildNode(node);
      }).toList(),
    );
  }

  Widget buildNode(TreeNode node) {
    final bool hasChildren = node.children != null && node.children!.isNotEmpty;

    return hasChildren ? buildParentNode(node) : buildLastChild(node);
  }

  Widget buildParentNode(TreeNode node) {
    IconData icon = node.type == 'asset' ? Icons.square_outlined : Icons.location_on;
    Color iconColor = Colors.blue;

    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8.0),
          Text(
            node.data['name'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      shape: const Border(),
      childrenPadding: const EdgeInsets.only(left: 8.0),
      children: node.children != null ? node.children!.map((child) => buildNode(child)).toList() : [],
    );
  }

  Widget buildLastChild(TreeNode node) {
    IconData icon = node.type == 'asset' ? Icons.rectangle_outlined : Icons.location_on;
    Color iconColor = Colors.blue;

    bool shouldShowStatus = node.type == 'asset' && node.data['status'] != null && node.data['sensorType'] != null;
    bool hasParent = node.data['parentId'] != null || node.data['locationId'] != null;

    return ListTile(
      title: Row(
        children: [
          hasParent ? const SizedBox(width: 32.0) : Container(),
          Icon(icon, color: iconColor),
          const SizedBox(width: 8.0),
          Text(
            node.data['name'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          shouldShowStatus ? buildSensorStatus(node) : Container()
        ],
      ),
      shape: const Border(),
    );
  }

  Widget buildSensorStatus(TreeNode node) {
    String sensorType = node.data['sensorType'];
    bool isAlert = node.data['status'] == "alert";

    IconData icon = sensorType == "vibration" ? Icons.vibration_rounded : Icons.bolt;
    Color iconColor = isAlert ? Colors.red : Colors.green;

    return Row(
      children: [
        const SizedBox(width: 8.0),
        Icon(
          icon,
          color: iconColor,
        ),
      ],
    );
  }

  List<TreeNode> _filterTree(List<TreeNode> nodes, String attribute, String filter) {
    List<TreeNode> filteredNodes = [];

    for (TreeNode node in nodes) {
      // Recursively filter children
      List<TreeNode> filteredChildren = node.children != null ? _filterTree(node.children!, attribute, filter) : [];

      // Check if the current node matches the filter or has filtered children
      if (node.data[attribute] == filter || filteredChildren.isNotEmpty) {
        // Include the node, but only add filtered children
        filteredNodes.add(TreeNode(
          type: node.type,
          data: node.data,
          children: filteredChildren.isNotEmpty ? filteredChildren : null,
        ));
      }
    }

    return filteredNodes;
  }

  Widget filterButton(String nodeAttribute, String filter, String label, IconData icon) {
    bool isActive = activeFilter == filter;
    Color color = isActive ? Colors.blue : Colors.grey;

    return OutlinedButton.icon(
      onPressed: () {
        if (isActive) {
          setState(() {
            activeFilter = null;
            filteredTree = null;
          });
        } else {
          setState(() {
            activeFilter = filter;
            filteredTree = _filterTree(widget.companyTree, nodeAttribute, filter);
          });
        }
      },
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
