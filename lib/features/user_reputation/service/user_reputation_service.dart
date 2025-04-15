import 'package:http/http.dart';
import 'package:sof_user_list/network/client_network.dart';
import 'package:sof_user_list/network/endpoint.dart';
import 'package:sof_user_list/network/result.dart';

class UserReputationService {
  Future<Result<Response>> getListReputation({required int userId, required int page, required int pagesize}) async {
    return ClientNetwork.get(
      endpoint: Endpoint.getListUserReputation(userId),
      queryParameters: {
        'page': page.toString(),
        'pagesize': pagesize.toString(),
        'site': 'stackoverflow',
      },
    );
  }
}