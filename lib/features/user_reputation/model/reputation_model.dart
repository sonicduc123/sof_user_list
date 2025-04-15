import 'dart:convert';

class ListReputationModel {
  List<ReputationModel>? items;
  bool? hasMore;
  int? quotaMax;
  int? quotaRemaining;

  ListReputationModel({
    this.items,
    this.hasMore,
    this.quotaMax,
    this.quotaRemaining,
  });

  ListReputationModel copyWith({
    List<ReputationModel>? items,
    bool? hasMore,
    int? quotaMax,
    int? quotaRemaining,
  }) =>
      ListReputationModel(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        quotaMax: quotaMax ?? this.quotaMax,
        quotaRemaining: quotaRemaining ?? this.quotaRemaining,
      );

  factory ListReputationModel.fromRawJson(String str) => ListReputationModel.fromJson(json.decode(str));

  factory ListReputationModel.fromJson(Map<String, dynamic> json) => ListReputationModel(
    items: json["items"] == null ? [] : List<ReputationModel>.from(json["items"]?.map((x) => ReputationModel.fromJson(x))),
    hasMore: json["has_more"],
    quotaMax: json["quota_max"],
    quotaRemaining: json["quota_remaining"],
  );

  Map<String, dynamic> toJson() => {
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "has_more": hasMore,
    "quota_max": quotaMax,
    "quota_remaining": quotaRemaining,
  };
}

class ReputationModel {
  String? reputationHistoryType;
  int? reputationChange;
  int? postId;
  int? creationDate;

  ReputationModel({
    this.reputationHistoryType,
    this.reputationChange,
    this.postId,
    this.creationDate,
  });

  ReputationModel copyWith({
    String? reputationHistoryType,
    int? reputationChange,
    int? postId,
    int? creationDate,
  }) =>
      ReputationModel(
        reputationHistoryType: reputationHistoryType ?? this.reputationHistoryType,
        reputationChange: reputationChange ?? this.reputationChange,
        postId: postId ?? this.postId,
        creationDate: creationDate ?? this.creationDate,
      );

  factory ReputationModel.fromRawJson(String str) => ReputationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReputationModel.fromJson(Map<String, dynamic> json) => ReputationModel(
    reputationHistoryType: json["reputation_history_type"],
    reputationChange: json["reputation_change"],
    postId: json["post_id"],
    creationDate: json["creation_date"],
  );

  Map<String, dynamic> toJson() => {
    "reputation_history_type": reputationHistoryType,
    "reputation_change": reputationChange,
    "post_id": postId,
    "creation_date": creationDate,
  };
}
