import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/error/common_error.dart';
import 'package:frontend/features/items/data/models/item_model.dart';
import 'package:frontend/features/items/domain/repo/item_repo.dart';
import 'package:frontend/features/items/presentation/riverpod/item_state.dart';

class ItemNotifier extends StateNotifier<ItemState> {
  final ItemRepo _repo;

  ItemNotifier({required ItemRepo repo})
    : _repo = repo,
      super(const ItemState());

  Future<void> getUserItems() async {
    try {
      state = state.copyWith(getUserItemsStatus: CommonStatus.loading);
      final items = await _repo.getUserItems();
      state = state.copyWith(
        userItems: items,
        getUserItemsStatus: CommonStatus.success,
      );
    } catch (e) {
      log("GET_USER_ITEMS_ERROR: $e");
      state = state.copyWith(
        getUserItemsStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }

  Future<void> createItem({required ItemModel item}) async {
    try {
      state = state.copyWith(createItemStatus: CommonStatus.loading);
      final success = await _repo.createItem(item: item);
      if (success) {
        await getUserItems();
        state = state.copyWith(createItemStatus: CommonStatus.success);
      } else {
        state = state.copyWith(createItemStatus: CommonStatus.failure);
      }
    } catch (e) {
      log("CREATE_ITEM_ERROR: $e");
      state = state.copyWith(
        createItemStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }

  Future<void> updateItem({
    required String itemID,
    required ItemModel updatedItem,
  }) async {
    try {
      state = state.copyWith(updateItemStatus: CommonStatus.loading);
      final success = await _repo.updateItem(
        itemID: itemID,
        updatedItem: updatedItem,
      );
      if (success) {
        await getUserItems();
        state = state.copyWith(updateItemStatus: CommonStatus.success);
      } else {
        state = state.copyWith(updateItemStatus: CommonStatus.failure);
      }
    } catch (e) {
      log("UPDATE_ITEM_ERROR: $e");
      state = state.copyWith(
        updateItemStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }

  Future<void> changeAssignmentToOtherReceiver({required String itemID}) async {
    try {
      state = state.copyWith(changeAssignmentStatus: CommonStatus.loading);
      final success = await _repo.changeAssignmentToOtherReceiver(
        itemID: itemID,
      );
      if (success) {
        await getUserItems();
        state = state.copyWith(changeAssignmentStatus: CommonStatus.success);
      } else {
        state = state.copyWith(changeAssignmentStatus: CommonStatus.failure);
      }
    } catch (e) {
      log("CHANGE_ASSIGNMENT_ERROR: $e");
      state = state.copyWith(
        changeAssignmentStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }
}
