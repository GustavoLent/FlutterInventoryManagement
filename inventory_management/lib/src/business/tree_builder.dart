import '../models/tree_node.dart';
import '../models/asset.dart';
import '../models/location.dart';

class TreeBuilder {
  List<TreeNode> buildTree(List<Asset> assets, List<Location> locations) {
    // 1. Hash of all locations as nodes
    final locationMap = <String, TreeNode>{};
    for (var location in locations) {
      locationMap[location.id] = TreeNode.fromLocation(location);
    }

    // 2. Hash of all assets as nodes
    final assetMap = <String, TreeNode>{};
    for (var asset in assets) {
      assetMap[asset.id] = TreeNode.fromAsset(asset);
    }

    // 3. the result is a list of nodes - as they may not have a parent
    final List<TreeNode> rootNodes = [];

    for (var location in locations) {
      final isRootLocation = location.parentId == null;

      if (isRootLocation) {
        rootNodes.add(locationMap[location.id]!);
      } else {
        // gets the parent of the location
        final parentLocation = locationMap[location.parentId!];

        // adds this location as child of the parent location
        parentLocation?.children?.add(locationMap[location.id]!);
      }
    }

    for (var asset in assets) {
      final belongsToLocation = asset.locationId != null;
      final isSubAsset = asset.parentId != null;

      if (belongsToLocation) {
        // put this asset as child of the parent location
        locationMap[asset.locationId!]?.children?.add(assetMap[asset.id]!);
      } else if (isSubAsset) {
        // put this asset as child of the parent asset
        assetMap[asset.parentId!]?.children?.add(assetMap[asset.id]!);
      } else {
        // standalone asset with no parent or location
        rootNodes.add(assetMap[asset.id]!);
      }
    }

    return rootNodes;
  }
}
