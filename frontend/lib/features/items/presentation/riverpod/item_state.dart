import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/common_error.dart';
import 'package:frontend/features/items/data/models/item_model.dart';

class ItemState extends Equatable {
  final List<ItemModel> userItems;
  final CommonStatus getUserItemsStatus;
  final CommonStatus getAssignedItemsStatus;
  final CommonStatus createItemStatus;
  final CommonStatus updateItemStatus;
  final CommonStatus changeAssignmentStatus;
  final CommonError error;

  const ItemState({
    this.userItems = const [],
    this.getUserItemsStatus = CommonStatus.initial,
    this.getAssignedItemsStatus = CommonStatus.initial,
    this.createItemStatus = CommonStatus.initial,
    this.updateItemStatus = CommonStatus.initial,
    this.changeAssignmentStatus = CommonStatus.initial,
    this.error = const CommonError(),
  });

  ItemState copyWith({
    List<ItemModel>? userItems,
    CommonStatus? getUserItemsStatus,
    CommonStatus? getAssignedItemsStatus,
    CommonStatus? createItemStatus,
    CommonStatus? updateItemStatus,
    CommonStatus? changeAssignmentStatus,
    CommonError? error,
  }) {
    return ItemState(
      userItems: userItems ?? this.userItems,
      getUserItemsStatus: getUserItemsStatus ?? this.getUserItemsStatus,
      getAssignedItemsStatus:
          getAssignedItemsStatus ?? this.getAssignedItemsStatus,
      createItemStatus: createItemStatus ?? this.createItemStatus,
      updateItemStatus: updateItemStatus ?? this.updateItemStatus,
      changeAssignmentStatus:
          changeAssignmentStatus ?? this.changeAssignmentStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    userItems,
    getUserItemsStatus,
    getAssignedItemsStatus,
    createItemStatus,
    updateItemStatus,
    changeAssignmentStatus,
    error,
  ];
}
