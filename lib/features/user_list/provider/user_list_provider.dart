import 'package:flutter/material.dart';
import 'package:sof_user_list/common/handle_state/view_state.dart';
import 'package:sof_user_list/features/user_list/model/user_model.dart';
import 'package:sof_user_list/features/user_list/repository/user_list_repository.dart';
import 'package:sof_user_list/network/result.dart';

class UserListProvider extends ChangeNotifier {
  UserListProvider({required UserListRepository repository})
      : _repository = repository;

  final UserListRepository _repository;

  final List<UserModel> _userList = [];
  int get userListLength => _userList.length;
  ViewState<List<UserModel>> _userListState = InitialState();
  ViewState<List<UserModel>> get userListState => _userListState;

  final List<UserModel> _bookmarkList = [];
  int get bookmarkListLength => _bookmarkList.length;
  ViewState<List<UserModel>> _bookmarkListState = InitialState();
  ViewState<List<UserModel>> get bookmarkListState => _bookmarkListState;

  ViewState _addBookmarkState = InitialState();
  ViewState get addBookmarkState => _addBookmarkState;

  ViewState _deleteBookmarkState = InitialState();
  ViewState get deleteBookmarkState => _deleteBookmarkState;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _loadMoreError;
  String? get loadMoreError => _loadMoreError;

  int page = 1;
  final int pagesize = 30;

  Future<void> initData() async {
    _userListState = LoadingState();
    notifyListeners();
    await Future.wait([
      getListUser(),
      getBookmarkList(),
    ]);
  }

  Future<void> getListUser() async {
    final result = await _repository.getListUser(page: page, pagesize: pagesize);
    if (result is Ok<ListUserModel>) {
      List<UserModel> userList = result.value.items ?? [];
      _hasMore = result.value.hasMore ?? false;

      if (userList.isEmpty) {
        _userListState = EmptyState();
      } else {
        for (var user in userList) {
          user.isBookmarked = _bookmarkList.any((bookmark) => bookmark.userId == user.userId);
        }
        _userList.addAll(userList);
        _userListState = SuccessState(_userList);
      }
    } else if (result is Error<ListUserModel>) {
      if (page == 1) {
        _userListState = FailureState(result.error);
      } else {
        _loadMoreError = result.error.toString();
      }
    }

    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_hasMore) {
      page++;
      await getListUser();
    }
  }

  Future<void> addBookmark(UserModel user) async {
    _addBookmarkState = LoadingState();
    final result = await _repository.addBookmark(user);
    if (result is Ok<UserModel>) {
      _bookmarkList.insert(0, user);
      _bookmarkListState = SuccessState(_bookmarkList);
      _addBookmarkState = SuccessState(null);
    } else if (result is Error<UserModel>) {
      _addBookmarkState = FailureState(result.error);
    }
    notifyListeners();
  }

  Future<void> deleteBookmark(int userId) async {
    _deleteBookmarkState = LoadingState();
    final result = await _repository.deleteBookmark(userId);
    if (result is Ok<void>) {
      _bookmarkList.removeWhere((user) => user.userId == userId);
      _bookmarkListState = SuccessState(_bookmarkList);
      _userList.where((user) => user.userId == userId).toList().firstOrNull?.isBookmarked = false;
      if (_bookmarkList.isEmpty) {
        _bookmarkListState = EmptyState();
      }
      _deleteBookmarkState = SuccessState(null);
    } else if (result is Error<void>) {
      _deleteBookmarkState = FailureState(result.error);
    }
    notifyListeners();
  }

  Future<void> getBookmarkList({List<String>? columns}) async {
    _bookmarkListState = LoadingState();
    notifyListeners();
    final result = await _repository.getBookmarkList(columns: columns);
    if (result is Ok<List<UserModel>>) {
      _bookmarkList.addAll(result.value);
      _bookmarkListState = SuccessState(_bookmarkList);
      if (_bookmarkList.isEmpty) {
        _bookmarkListState = EmptyState();
      }
    } else if (result is Error<List<UserModel>>) {
      _bookmarkListState = FailureState(result.error);
    }
    notifyListeners();
  }

  Future<void> onTapBookmark(UserModel user) async {
    if (user.isBookmarked == true) {
      user.isBookmarked = false;
      await deleteBookmark(user.userId ?? 0);
    } else {
      user.isBookmarked = true;
      await addBookmark(user);
    }
    notifyListeners();
  }
}