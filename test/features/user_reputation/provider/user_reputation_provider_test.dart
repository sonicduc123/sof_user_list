import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sof_user_list/common/handle_state/view_state.dart';
import 'package:sof_user_list/features/user_reputation/model/reputation_model.dart';
import 'package:sof_user_list/features/user_reputation/provider/user_reputation_provider.dart';
import 'package:sof_user_list/features/user_reputation/repository/user_reputation_repository.dart';
import 'package:sof_user_list/network/result.dart';

import 'user_reputation_provider_test.mocks.dart';

@GenerateMocks([UserReputationRepository])
void main() {
  late UserReputationProvider provider;
  late MockUserReputationRepository mockRepository;
  final int userId = 1;

  setUp(() {
    mockRepository = MockUserReputationRepository();
    provider = UserReputationProvider(repository: mockRepository, userId: userId);
  });

  group('User reputation provider test', () {
    group('initData', () {
      test('initializes data and sets states correctly', () async {
        provideDummy(Result.ok(ListReputationModel(items: [ReputationModel()], hasMore: true)));
        when(mockRepository.getListReputation(userId: provider.userId, page: 1, pagesize: provider.pagesize))
            .thenAnswer((_) async => Ok(ListReputationModel(items: [ReputationModel()], hasMore: true)));

        await provider.initData();

        expect(provider.reputationListState, isA<SuccessState>());
        expect(provider.userListLength, 1);
        expect(provider.hasMore, true);
      });
    });

    group('getListReputation', () {
      test('adds reputations to list and updates states on first page success', () async {
        final reputation = ReputationModel();
        provideDummy(Result.ok(ListReputationModel(items: [reputation], hasMore: true)));
        when(mockRepository.getListReputation(userId: provider.userId, page: 1, pagesize: provider.pagesize))
            .thenAnswer((_) async => Ok(ListReputationModel(items: [reputation], hasMore: true)));

        await provider.getListReputation();

        expect(provider.userListLength, 1);
        expect(provider.hasMore, true);
        expect(provider.reputationListState, isA<SuccessState>());
      });

      test('sets empty state when no reputations are returned', () async {
        provideDummy(Result.ok(ListReputationModel(items: [], hasMore: false)));
        when(mockRepository.getListReputation(userId: provider.userId, page: 1, pagesize: provider.pagesize))
            .thenAnswer((_) async => Ok(ListReputationModel(items: [], hasMore: false)));

        await provider.getListReputation();

        expect(provider.reputationListState, isA<EmptyState>());
        expect(provider.hasMore, false);
      });

      test('sets failure state when first page request fails', () async {
        provider.page = 1;
        provideDummy(Result.error(Exception('Error loading reputations')));
        when(mockRepository.getListReputation(userId: provider.userId, page: 1, pagesize: provider.pagesize))
            .thenAnswer((_) async => Error(Exception('Error loading reputations')));

        await provider.getListReputation();

        expect(provider.reputationListState, isA<FailureState>());
      });

      test('sets loadMoreError when subsequent page request fails', () async {
        provider.page = 2;
        provideDummy(Result.error(Exception('Error loading more')));
        when(mockRepository.getListReputation(userId: provider.userId, page: 2, pagesize: provider.pagesize))
            .thenAnswer((_) async => Error(Exception('Error loading more')));

        await provider.getListReputation();

        expect(provider.loadMoreError, isNotNull);
      });
    });

    group('loadMore', () {
      test('increments page and loads more reputations when hasMore is true', () async {
        provider.page = 1;
        provideDummy(Result.ok(ListReputationModel(items: [ReputationModel()], hasMore: true)));
        when(mockRepository.getListReputation(userId: provider.userId, page: 2, pagesize: provider.pagesize))
            .thenAnswer((_) async => Ok(ListReputationModel(items: [ReputationModel()], hasMore: true)));

        await provider.loadMore();

        expect(provider.page, 2);
        verify(mockRepository.getListReputation(userId: provider.userId, page: 2, pagesize: provider.pagesize)).called(1);
      });

      test('does not load more when hasMore is false', () async {
        provider.page = 1;
        provideDummy(Result.ok(ListReputationModel(items: [ReputationModel()], hasMore: false)));
        when(mockRepository.getListReputation(userId: provider.userId, page: 2, pagesize: provider.pagesize))
            .thenAnswer((_) async => Ok(ListReputationModel(items: [ReputationModel()], hasMore: false)));

        await provider.loadMore();
        await provider.loadMore();

        verifyNever(mockRepository.getListReputation(userId: provider.userId, page: 3, pagesize: provider.pagesize));
        expect(provider.page, 2);
      });
    });
  });
}