import 'dart:isolate';

import 'package:http/http.dart';
import 'package:sof_user_list/features/user_list/model/user_model.dart';
import 'package:sof_user_list/features/user_list/service/bookmark_sqflite_service.dart';
import 'package:sof_user_list/features/user_list/service/user_list_service.dart';
import 'package:sof_user_list/network/result.dart';

class UserListRepository {
  UserListRepository({
    required UserListService service,
    required BookmarkService bookmarkService,
  }) : _userListService = service,
       _bookmarkService = bookmarkService;

  final UserListService _userListService;
  final BookmarkService _bookmarkService;


  Future<Result<ListUserModel>> getListUser({required int page, required int pagesize}) async {
    try {
      final response = await _userListService.getListUser(page: page, pagesize: pagesize);

      if (response is Ok<Response>) {
        final data = await Isolate.run<ListUserModel>(() {
          return ListUserModel.fromRawJson(response.value.body);
        });
        return Ok(data);
      } else if (response is Error<Response>) {

        return Error(response.error);
      }
    } catch (e) {
      return Error(Exception('Error when handling response'));
    }

    return Error(Exception('Unknown error'));
  }

  Future<Result<UserModel>> addBookmark(UserModel user) async {
    try {
      int? id = await _bookmarkService.insert(user);
      if (id != null) {
        return Ok(user);
      }
    } catch (e) {
      return Error(Exception('Error when adding bookmark'));
    }
    return Error(Exception('Unknown error'));
  }

  Future<Result<List<UserModel>>> getBookmarkList({List<String>? columns}) async {
    try {
      final listResult = await _bookmarkService.getList(columns: columns);
      if (listResult != null) {
        final listMap = await Isolate.run<List<UserModel>>(() {
          return listResult.map((e) => UserModel.fromJson(e)).toList();
        });
        return Ok(listMap);
      }
    } catch (e) {
      return Error(Exception('Error when getting bookmark list'));
    }
    return Error(Exception('Unknown error'));
  }

  Future<Result> deleteBookmark(int id) async {
    try {
      await _bookmarkService.delete(id);
      return Ok(null);
    } catch (e) {
      return Error(Exception('Error when deleting bookmark'));
    }
  }
}