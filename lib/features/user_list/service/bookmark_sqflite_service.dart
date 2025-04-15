import 'package:path/path.dart';
import 'package:sof_user_list/features/user_list/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class BookmarkService {
  Database? database;

  final String databaseName = "user_list.db";
  final String userTable = 'user';
  static final String userId = 'user_id';
  static final String displayName = 'display_name';
  static final String profileImage = 'profile_image';
  static final String reputation = 'reputation';
  static final String location = 'location';
  static final String isBookmarked = 'is_bookmarked';

  Future<void> open() async {
    database = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) {
        return db.execute(
            '''
          CREATE TABLE IF NOT EXISTS $userTable(
            $userId INTEGER PRIMARY KEY, 
            $displayName TEXT, 
            $profileImage TEXT,
            $reputation INTEGER,
            $location TEXT,
            $isBookmarked INTEGER
          )
          '''
        );
      },
      version: 1,
    );
  }

  Future<void> close() async {
    await database?.close();
  }

  Future<int?> insert(UserModel user) async {
    await open();

    int? id = await database?.insert(
      userTable,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    await close();

    return id;
  }

  Future<List<Map<String, Object?>>?> getList({List<String>? columns}) async {
    await open();

    final List<Map<String, Object?>>? listMap = await database?.query(
      userTable,
      columns: columns,
    );

    await close();

    return listMap;
  }

  Future<int?> delete(int id) async {
    await open();

    int? count = await database?.delete(
      userTable,
      where: '$userId = ?',
      whereArgs: [id],
    );

    await close();

    return count; // the number of rows affected
  }
}