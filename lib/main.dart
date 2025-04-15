import 'package:flutter/material.dart';
import 'package:sof_user_list/routes.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    initialRoute: Routes.userList,
    routes: Routes.routes,
    onGenerateRoute: Routes.generateRoutes,
  ));
}
