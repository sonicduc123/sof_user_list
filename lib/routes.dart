import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sof_user_list/features/user_list/provider/user_list_provider.dart';
import 'package:sof_user_list/features/user_list/repository/user_list_repository.dart';
import 'package:sof_user_list/features/user_list/screen/user_list_screen.dart';
import 'package:sof_user_list/features/user_list/service/bookmark_sqflite_service.dart';
import 'package:sof_user_list/features/user_list/service/user_list_service.dart';
import 'package:sof_user_list/features/user_reputation/provider/user_reputation_provider.dart';
import 'package:sof_user_list/features/user_reputation/repository/user_reputation_repository.dart';
import 'package:sof_user_list/features/user_reputation/screen/user_reputation_screen.dart';
import 'package:sof_user_list/features/user_reputation/service/user_reputation_service.dart';

class Routes {
  // static routes
  static const String userList = '/userList';
  static const String userReputation = '/userReputation';

  static final routes = <String, WidgetBuilder> {
    userList: (BuildContext context) => MultiProvider(
      providers: [
        Provider(create: (context) => UserListService()),
        Provider(create: (context) => BookmarkService()),
        Provider(create: (context) => UserListRepository(service: context.read<UserListService>(), bookmarkService: context.read<BookmarkService>())),
        ChangeNotifierProvider(create: (context) => UserListProvider(
            repository: context.read<UserListRepository>(),
          )..initData(),
        ),
      ],
      child: UserListScreen(),
    ),
  };

  static Route<dynamic>? generateRoutes(settings) {
    switch (settings.name) {
      case userReputation:
        int? passData = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(create: (context) => UserReputationService()),
              Provider(create: (context) => UserReputationRepository(service: context.read<UserReputationService>())),
              ChangeNotifierProvider(
                create: (context) => UserReputationProvider(
                  userId: passData ?? 0,
                  repository: context.read<UserReputationRepository>(),
                )..initData(),
              ),
            ],
            child: UserReputationScreen(),
          ),
        );
    }

    return null;
  }
}