import 'dart:convert';

class ListUserModel {
  List<UserModel>? items;
  bool? hasMore;
  int? quotaMax;
  int? quotaRemaining;

  ListUserModel({
    this.items,
    this.hasMore,
    this.quotaMax,
    this.quotaRemaining,
  });

  ListUserModel copyWith({
    List<UserModel>? items,
    bool? hasMore,
    int? quotaMax,
    int? quotaRemaining,
  }) =>
      ListUserModel(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        quotaMax: quotaMax ?? this.quotaMax,
        quotaRemaining: quotaRemaining ?? this.quotaRemaining,
      );

  factory ListUserModel.fromRawJson(String str) => ListUserModel.fromJson(json.decode(str));

  factory ListUserModel.fromJson(Map<String, dynamic> json) => ListUserModel(
    items: json["items"] == null ? [] : List<UserModel>.from(json["items"]?.map((x) => UserModel.fromJson(x))),
    hasMore: json["has_more"],
    quotaMax: json["quota_max"],
    quotaRemaining: json["quota_remaining"],
  );

  Map<String, dynamic> toJson() => {
    "items": items == null ? [] : List<dynamic>.from((items ?? []).map((x) => x.toJson())),
    "has_more": hasMore,
    "quota_max": quotaMax,
    "quota_remaining": quotaRemaining,
  };
}

class UserModel {
  int? userId;
  String? displayName;
  String? profileImage;
  int? reputation;
  String? location;
  bool? isBookmarked;

  UserModel({
    this.userId,
    this.displayName,
    this.profileImage,
    this.reputation,
    this.location,
    this.isBookmarked,
  });

  UserModel copyWith({
    int? userId,
    String? displayName,
    String? profileImage,
    int? reputation,
    String? location,
    bool? isBookmarked,
  }) =>
      UserModel(
        userId: userId ?? this.userId,
        displayName: displayName ?? this.displayName,
        profileImage: profileImage ?? this.profileImage,
        reputation: reputation ?? this.reputation,
        location: location ?? this.location,
        isBookmarked: isBookmarked ?? this.isBookmarked,
      );

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json["user_id"],
    displayName: json["display_name"],
    profileImage: json["profile_image"],
    reputation: json["reputation"],
    location: json["location"],
    isBookmarked: json["is_bookmarked"] == 1 ? true : false,
  );

  Map<String, Object?> toJson() {
    return {
      'user_id': userId,
      'display_name': displayName,
      'profile_image': profileImage,
      'reputation': reputation,
      'location': location,
      'is_bookmarked': isBookmarked == true ? 1 : 0,
    };
  }
}
