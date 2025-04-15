import 'package:http/http.dart';
import 'package:sof_user_list/network/client_network.dart';
import 'package:sof_user_list/network/endpoint.dart';
import 'package:sof_user_list/network/result.dart';

class UserListService {
  Future<Result<Response>> getListUser({required int page, required int pagesize}) async {
    return ClientNetwork.get(
      endpoint: Endpoint.getListUser,
      queryParameters: {
        'page': page.toString(),
        'pagesize': pagesize.toString(),
        'site': 'stackoverflow',
      },
    );
  }
}