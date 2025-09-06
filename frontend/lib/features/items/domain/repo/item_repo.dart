import 'package:frontend/features/items/data/models/item_model.dart';

abstract interface class ItemRepo {
  Future<List<ItemModel>> getUserItems();
  Future<List<ItemModel>> getAssignedItems();
  Future<bool> createItem({required ItemModel item});
  Future<bool> updateItem({
    required String itemID,
    required ItemModel updatedItem,
  });
  Future<bool> changeAssignmentToOtherReceiver({required String itemID});
}
