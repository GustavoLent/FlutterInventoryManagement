import 'dart:convert';

import 'location.dart';
import 'asset.dart';

class TreeNode {
  final String type; // "location", "asset", or "component"
  final Map<String, dynamic> data;
  final List<TreeNode>? children;

  TreeNode({required this.type, required this.data, this.children});

  // Factory constructor to create a TreeNode from data
  factory TreeNode.fromLocation(Location location) {
    return TreeNode(
      type: 'location',
      data: {'id': location.id, 'name': location.name, 'parentId': location.parentId},
      children: [],
    );
  }

  factory TreeNode.fromAsset(Asset asset) {
    return TreeNode(
      type: 'asset',
      data: {
        'gatewayId': asset.gatewayId,
        'id': asset.id,
        'locationId': asset.locationId,
        'name': asset.name,
        'parentId': asset.parentId,
        'sensorId': asset.sensorId,
        'sensorType': asset.sensorType,
        'status': asset.status,
      },
      children: [],
    );
  }

  static Map<String, dynamic> toMap(TreeNode tree) {
    return {
      'type': tree.type,
      'data': tree.data,
      'children': tree.children?.map((x) => TreeNode.toMap(x)).toList(),
    };
  }

  static String toJson(TreeNode tree) => json.encode(toMap(tree));
}
