// Mocks generated by Mockito 5.4.5 from annotations
// in sof_user_list/test/features/user_reputation/repository/user_reputation_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:sof_user_list/features/user_reputation/service/user_reputation_service.dart'
    as _i2;
import 'package:sof_user_list/network/result.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [UserReputationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserReputationService extends _i1.Mock
    implements _i2.UserReputationService {
  MockUserReputationService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Result<_i5.Response>> getListReputation({
    required int? userId,
    required int? page,
    required int? pagesize,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#getListReputation, [], {
              #userId: userId,
              #page: page,
              #pagesize: pagesize,
            }),
            returnValue: _i3.Future<_i4.Result<_i5.Response>>.value(
              _i6.dummyValue<_i4.Result<_i5.Response>>(
                this,
                Invocation.method(#getListReputation, [], {
                  #userId: userId,
                  #page: page,
                  #pagesize: pagesize,
                }),
              ),
            ),
          )
          as _i3.Future<_i4.Result<_i5.Response>>);
}
