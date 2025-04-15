import 'package:flutter/material.dart';
import 'package:sof_user_list/common/handle_state/view_state.dart';
import 'package:sof_user_list/features/user_reputation/model/reputation_model.dart';
import 'package:sof_user_list/features/user_reputation/repository/user_reputation_repository.dart';
import 'package:sof_user_list/network/result.dart';

class UserReputationProvider extends ChangeNotifier {
  UserReputationProvider({
    required this.userId,
    required UserReputationRepository repository,
  })
      : _repository = repository;

  final UserReputationRepository _repository;
  final int userId;

  final List<ReputationModel> _reputationList = [];
  int get userListLength => _reputationList.length;
  ViewState<List<ReputationModel>> _reputationListState = InitialState();
  ViewState<List<ReputationModel>> get reputationListState => _reputationListState;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _loadMoreError;
  String? get loadMoreError => _loadMoreError;

  int page = 1;
  final int pagesize = 30;

  Future<void> initData() async {
    _reputationListState = LoadingState();
    notifyListeners();

    await Future.wait([
      getListReputation(),
    ]);
  }

  Future<void> getListReputation() async {
    final result = await _repository.getListReputation(userId: userId, page: page, pagesize: pagesize);
    if (result is Ok<ListReputationModel>) {
      List<ReputationModel> userList = result.value.items ?? [];
      _hasMore = result.value.hasMore ?? false;

      if (userList.isEmpty) {
        _reputationListState = EmptyState();
      } else {
        _reputationList.addAll(userList);
        _reputationListState = SuccessState(_reputationList);
      }
    } else if (result is Error<ListReputationModel>) {
      if (page == 1) {
        _reputationListState = FailureState(result.error);
      } else {
        _loadMoreError = result.error.toString();
      }
    }

    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_hasMore) {
      page++;
      await getListReputation();
    }
  }

}