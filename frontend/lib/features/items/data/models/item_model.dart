import 'package:equatable/equatable.dart';

class ItemModel extends Equatable {
  final String? id;
  final String? content;
  final String? uid;
  final String? status;
  final String? currentlyAssignedTo;
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
    String? uid,
    String? status,
    String? currentlyAssignedTo,
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
      uid: json['uid'] as String?,
      status: json['status'] as String?,
      currentlyAssignedTo: json['currentlyAssignedTo'] as String?,
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
      'uid': uid,
      'status': status,
      'currentlyAssignedTo': currentlyAssignedTo,
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
  final String? assignedTo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TotalAssignedPeopleModel({
    this.assignedTo,
    this.createdAt,
    this.updatedAt,
  });

  TotalAssignedPeopleModel copyWith({
    String? assignedTo,
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
      assignedTo: json['assignedTo'] as String?,
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
      'assignedTo': assignedTo,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [assignedTo, createdAt, updatedAt];
}
