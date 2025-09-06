import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';

class ItemModel extends Equatable {
  final String? id;
  final String? content;
  final UserModel? uid;
  final String? status;
  final UserModel? currentlyAssignedTo;
  final List<TotalAssignedPeopleModel> totalAssignedPeoples;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ItemModel({
    this.id,
    this.content,
    this.uid,
    this.status,
    this.currentlyAssignedTo,
    this.totalAssignedPeoples = const [],
    this.createdAt,
    this.updatedAt,
  });

  ItemModel copyWith({
    String? id,
    String? content,
    UserModel? uid,
    String? status,
    UserModel? currentlyAssignedTo,
    List<TotalAssignedPeopleModel>? totalAssignedPeoples,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      content: content ?? this.content,
      uid: uid ?? this.uid,
      status: status ?? this.status,
      currentlyAssignedTo: currentlyAssignedTo ?? this.currentlyAssignedTo,
      totalAssignedPeoples: totalAssignedPeoples ?? this.totalAssignedPeoples,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ItemModel();
    return ItemModel(
      id: json['_id'] as String?,
      content: json['content'] as String?,
      uid: json['uid'] != null ? UserModel.fromJson(json['uid']) : null,
      status: json['status'] as String?,
      currentlyAssignedTo: json['currentlyAssignedTo'] != null
          ? UserModel.fromJson(json['currentlyAssignedTo'])
          : null,
      totalAssignedPeoples:
          (json['totalAssignedPeoples'] as List<dynamic>?)
              ?.map(
                (e) => TotalAssignedPeopleModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'uid': uid?.toJson(),
      'status': status,
      'currentlyAssignedTo': currentlyAssignedTo?.toJson(),
      'totalAssignedPeoples': totalAssignedPeoples
          .map((e) => e.toJson())
          .toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    content,
    uid,
    status,
    currentlyAssignedTo,
    totalAssignedPeoples,
    createdAt,
    updatedAt,
  ];
}

class TotalAssignedPeopleModel extends Equatable {
  final UserModel? assignedTo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TotalAssignedPeopleModel({
    this.assignedTo,
    this.createdAt,
    this.updatedAt,
  });

  TotalAssignedPeopleModel copyWith({
    UserModel? assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TotalAssignedPeopleModel(
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TotalAssignedPeopleModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TotalAssignedPeopleModel();
    return TotalAssignedPeopleModel(
      assignedTo: json['assignedTo'] != null
          ? UserModel.fromJson(json['assignedTo'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignedTo': assignedTo?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [assignedTo, createdAt, updatedAt];
}
