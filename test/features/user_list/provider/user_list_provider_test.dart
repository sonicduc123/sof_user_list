import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sof_user_list/common/handle_state/view_state.dart';
import 'package:sof_user_list/features/user_list/model/user_model.dart';
import 'package:sof_user_list/features/user_list/provider/user_list_provider.dart';
import 'package:sof_user_list/features/user_list/repository/user_list_repository.dart';
import 'package:sof_user_list/network/result.dart';

import 'user_list_provider_test.mocks.dart';


@GenerateMocks([UserListRepository])
void main() {
  late UserListProvider provider;
  late MockUserListRepository mockRepository;

  setUp(() {
    mockRepository = MockUserListRepository();
    provider = UserListProvider(repository: mockRepository);
  });

  group('User list provider test', () {
    group('initData', () {
      test('sets userListState and bookmarkListState to SuccessState when data is loaded successfully', () async {
        provideDummy(Result.ok(ListUserModel(items: [UserModel(userId: 1)], hasMore: true)));
        when(mockRepository.getListUser(page: provider.page, pagesize: provider.pagesize))
            .thenAnswer((_) async => Ok(ListUserModel(items: [UserModel(userId: 1)], hasMore: true)));

        provideDummy(Result.ok([UserModel(userId: 1)]));
        when(mockRepository.getBookmarkList(columns: anyNamed('columns')))
            .thenAnswer((_) async => Ok([UserModel(userId: 1)]));

        await provider.initData();

        expect(provider.userListState, isA<SuccessState>());
        expect(provider.bookmarkListState, isA<SuccessState>());
        expect(provider.userListLength, 1);
        expect(provider.bookmarkListLength, 1);
      });

      test('sets userListState to FailureState when getListUser fails', () async {
        provideDummy(Result.error(Exception('Error fetching user list')));
        when(mockRepository.getListUser(
            page: anyNamed('page'), pagesize: anyNamed('pagesize')))
            .thenAnswer((_) async => Error(Exception('Error fetching user list')));

        provideDummy(Result.ok([UserModel(userId: 1)]));
        when(mockRepository.getBookmarkList(columns: anyNamed('columns')))
            .thenAnswer((_) async => Ok([UserModel(userId: 1)]));

        await provider.initData();

        expect(provider.userListState, isA<FailureState>());
      });
    });

    group('addBookmark', () {
      test('adds a user to the bookmark list and updates states on success', () async {
        final user = UserModel(userId: 1);
        provideDummy(Result.ok(user));
        when(mockRepository.addBookmark(user)).thenAnswer((_) async => Ok(user));

        await provider.addBookmark(user);

        expect(provider.bookmarkListLength, 1);
        expect(provider.addBookmarkState, isA<SuccessState>());
      });

      test('sets addBookmarkState to FailureState when addBookmark fails', () async {
        final user = UserModel(userId: 1);
        provideDummy(Result.error(Exception('Error adding bookmark')));
        when(mockRepository.addBookmark(user)).thenAnswer((_) async => Error(Exception('Error adding bookmark')));

        await provider.addBookmark(user);

        expect(provider.addBookmarkState, isA<FailureState>());
      });
    });

    group('loadMore', () {
      test('loads more users and updates userList when hasMore is true', () async {
        provider.page = 1;
        provideDummy(Result.ok(ListUserModel(items: [UserModel(userId: 1)], hasMore: true)));
        when(mockRepository.getListUser(page: provider.page + 1, pagesize: provider.pagesize))
            .thenAnswer((_) async => Ok(ListUserModel(items: [UserModel(userId: 2)], hasMore: false)));

        await provider.loadMore();

        expect(provider.userListLength, 1);
        expect(provider.hasMore, false);
        expect(provider.page, 2);
      });

      test('does not load more users when hasMore is false', () async {
        provider.page = 1;
        provideDummy(Result.ok(ListUserModel(items: [UserModel(userId: 1)], hasMore: false)));
        when(mockRepository.getListUser(page: provider.page + 1, pagesize: provider.pagesize))
            .thenAnswer((_) async => Ok(ListUserModel(items: [UserModel(userId: 1)], hasMore: false)));

        await provider.loadMore();
        await provider.loadMore();

        verifyNever(mockRepository.getListUser(page: provider.page + 1, pagesize: provider.pagesize));
        expect(provider.page, 2);
      });
    });

    group('deleteBookmark', () {
      test('removes user from bookmark list and updates states on success', () async {
        final user = UserModel(userId: 1);
        provideDummy(Result.ok(null));
        when(mockRepository.deleteBookmark(user.userId!))
            .thenAnswer((_) async => Ok(null));

        await provider.deleteBookmark(user.userId!);

        expect(provider.bookmarkListLength, 0);
        expect(provider.deleteBookmarkState, isA<SuccessState>());
        expect(provider.bookmarkListState, isA<EmptyState>());
      });

      test('sets deleteBookmarkState to FailureState when deletion fails', () async {
        provideDummy(Result.error(Exception('Error deleting bookmark')));
        when(mockRepository.deleteBookmark(1))
            .thenAnswer((_) async => Error(Exception('Error deleting bookmark')));

        await provider.deleteBookmark(1);

        expect(provider.deleteBookmarkState, isA<FailureState>());
      });
    });

    group('onTapBookmark', () {
      test('removes bookmark when user is already bookmarked', () async {
        final user = UserModel(userId: 1, isBookmarked: true);
        provideDummy(Result.ok(null));
        when(mockRepository.deleteBookmark(user.userId!))
            .thenAnswer((_) async => Ok(null));

        await provider.onTapBookmark(user);

        expect(user.isBookmarked, false);
      });

      test('adds bookmark when user is not bookmarked', () async {
        final user = UserModel(userId: 1, isBookmarked: false);
        provideDummy(Result.ok(user));
        when(mockRepository.addBookmark(user))
            .thenAnswer((_) async => Ok(user));

        await provider.onTapBookmark(user);

        expect(user.isBookmarked, true);
      });
    });
  });
}