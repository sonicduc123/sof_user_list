import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';
import 'package:sof_user_list/features/user_reputation/model/reputation_model.dart';
import 'package:sof_user_list/features/user_reputation/repository/user_reputation_repository.dart';
import 'package:sof_user_list/features/user_reputation/service/user_reputation_service.dart';
import 'package:sof_user_list/network/result.dart';

import 'user_reputation_repository_test.mocks.dart';

@GenerateMocks([UserReputationService])
void main() {
  late UserReputationRepository repository;
  late MockUserReputationService mockService;

  setUp(() {
    mockService = MockUserReputationService();
    repository = UserReputationRepository(service: mockService);
  });

  group('getListReputation', () {
    test('returns reputation list when API call succeeds', () async {
      final expectedModel = ListReputationModel(
          items: [ReputationModel(reputationChange: 100)],
          hasMore: true
      );
      provideDummy(Result.ok(Response(jsonEncode(expectedModel.toJson()), 200)));
      when(mockService.getListReputation(userId: 1, page: 1, pagesize: 10))
          .thenAnswer((_) async => Ok(Response(jsonEncode(expectedModel.toJson()), 200)));

      final result = await repository.getListReputation(userId: 1, page: 1, pagesize: 10);

      expect(result, isA<Ok<ListReputationModel>>());
      expect((result as Ok<ListReputationModel>).value.items?.first.reputationChange, 100);
      expect((result as Ok).value.hasMore, true);
    });

    test('returns error when API call fails', () async {
      when(mockService.getListReputation(userId: 1, page: 1, pagesize: 10))
          .thenAnswer((_) async => Error(Exception('API error')));

      final result = await repository.getListReputation(userId: 1, page: 1, pagesize: 10);

      expect(result, isA<Error>());
    });

    test('returns error when response has invalid JSON', () async {
      when(mockService.getListReputation(userId: 1, page: 1, pagesize: 10))
          .thenAnswer((_) async => Ok(Response('invalid json', 200)));

      final result = await repository.getListReputation(userId: 1, page: 1, pagesize: 10);

      expect(result, isA<Error>());
    });

    test('returns error when response is empty', () async {
      when(mockService.getListReputation(userId: 1, page: 1, pagesize: 10))
          .thenAnswer((_) async => Ok(Response('', 200)));

      final result = await repository.getListReputation(userId: 1, page: 1, pagesize: 10);

      expect(result, isA<Error>());
    });

    test('returns error when service throws exception', () async {
      when(mockService.getListReputation(userId: 1, page: 1, pagesize: 10))
          .thenThrow(Exception('Service error'));

      final result = await repository.getListReputation(userId: 1, page: 1, pagesize: 10);

      expect(result, isA<Error>());
    });
  });
}