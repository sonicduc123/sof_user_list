import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sof_user_list/features/user_list/model/user_model.dart';
import 'package:sof_user_list/features/user_list/repository/user_list_repository.dart';
import 'package:sof_user_list/features/user_list/service/bookmark_sqflite_service.dart';
import 'package:sof_user_list/features/user_list/service/user_list_service.dart';
import 'package:sof_user_list/network/result.dart';

import 'user_reputation_repository_test.mocks.dart';

@GenerateMocks([UserListService, BookmarkService])
void main() {
  late UserListRepository repository;
  late MockUserListService mockUserListService;
  late MockBookmarkService mockBookmarkService;

  setUp(() {
    mockUserListService = MockUserListService();
    mockBookmarkService = MockBookmarkService();
    repository = UserListRepository(
        service: mockUserListService,
        bookmarkService: mockBookmarkService
    );
  });

  group('User reputation repository test', () {
    group('getListUser', () {
      test('returns ListUserModel when API call is successful', () async {
        final listUserModel = ListUserModel(items: [UserModel(userId: 1)], hasMore: true);
        provideDummy(Result.ok(Response(jsonEncode(listUserModel.toJson()), 200)));
        when(mockUserListService.getListUser(page: 1, pagesize: 10))
            .thenAnswer((_) async => Ok(Response(jsonEncode(listUserModel.toJson()), 200)));

        final result = await repository.getListUser(page: 1, pagesize: 10);

        expect(result, isA<Ok<ListUserModel>>());
        expect((result as Ok).value.items.first.userId, 1);
      });

      test('returns error when API call fails', () async {
        when(mockUserListService.getListUser(page: 1, pagesize: 10))
            .thenAnswer((_) async => Error(Exception('API error')));

        final result = await repository.getListUser(page: 1, pagesize: 10);

        expect(result, isA<Error>());
      });
    });

    group('addBookmark', () {
      test('returns user model when bookmark is added successfully', () async {
        final user = UserModel(userId: 1);
        when(mockBookmarkService.insert(user)).thenAnswer((_) async => 1);

        final result = await repository.addBookmark(user);

        expect(result, isA<Ok<UserModel>>());
        expect((result as Ok).value.userId, 1);
      });

      test('returns error when bookmark insertion fails', () async {
        final user = UserModel(userId: 1);
        when(mockBookmarkService.insert(user)).thenThrow(Exception('DB error'));

        final result = await repository.addBookmark(user);

        expect(result, isA<Error>());
      });
    });

    group('getBookmarkList', () {
      test('returns list of bookmarks when database query succeeds', () async {
        final bookmarks = [{'userId': 1}, {'userId': 2}];
        when(mockBookmarkService.getList(columns: null)).thenAnswer((_) async => bookmarks);

        final result = await repository.getBookmarkList();

        expect(result, isA<Ok<List<UserModel>>>());
        expect((result as Ok).value.length, 2);
      });

      test('returns empty list when no bookmarks exist', () async {
        when(mockBookmarkService.getList(columns: null)).thenAnswer((_) async => []);

        final result = await repository.getBookmarkList();

        expect(result, isA<Ok<List<UserModel>>>());
        expect((result as Ok).value.isEmpty, true);
      });

      test('returns error when database query fails', () async {
        when(mockBookmarkService.getList(columns: null)).thenThrow(Exception('DB error'));

        final result = await repository.getBookmarkList();

        expect(result, isA<Error>());
      });
    });

    group('deleteBookmark', () {
      test('returns success when bookmark is deleted', () async {
        when(mockBookmarkService.delete(1)).thenAnswer((_) async => 1);

        final result = await repository.deleteBookmark(1);

        expect(result, isA<Ok>());
      });

      test('returns error when bookmark deletion fails', () async {
        when(mockBookmarkService.delete(1)).thenThrow(Exception('DB error'));

        final result = await repository.deleteBookmark(1);

        expect(result, isA<Error>());
      });
    });
  });
}