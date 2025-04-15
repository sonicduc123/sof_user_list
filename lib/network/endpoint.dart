class Endpoint {
  static const String baseUrl = 'api.stackexchange.com';

  static const String version = '/2.2/';

  static const String getListUser = '${version}users';

  static String getListUserReputation(int userId) => '${version}users/$userId/reputation-history';
}