import 'dart:isolate';

import 'package:http/http.dart';
import 'package:sof_user_list/features/user_reputation/model/reputation_model.dart';
import 'package:sof_user_list/features/user_reputation/service/user_reputation_service.dart';
import 'package:sof_user_list/network/result.dart';

class UserReputationRepository {
  UserReputationRepository({
    required UserReputationService service,
  }) : _service = service;

  final UserReputationService _service;

  Future<Result<ListReputationModel>> getListReputation({required int userId, required int page, required int pagesize}) async {
    try {
      final response = await _service.getListReputation(userId: userId, page: page, pagesize: pagesize);

      if (response is Ok<Response>) {
        final data = await Isolate.run<ListReputationModel>(() {
          return ListReputationModel.fromRawJson(response.value.body);
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
}