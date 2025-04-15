import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sof_user_list/common/handle_state/state_widget.dart';
import 'package:sof_user_list/common/loadmore/load_more_listview.dart';
import 'package:sof_user_list/constants.dart';
import 'package:sof_user_list/features/user_reputation/provider/user_reputation_provider.dart';
import 'package:sof_user_list/features/user_reputation/widget/user_reputation_item.dart';

class UserReputationScreen extends StatelessWidget {
  const UserReputationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserReputationProvider provider = context.read<UserReputationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Reputation History'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.paddingLayout),
        child: StateWidget(
          state: context.watch<UserReputationProvider>().reputationListState,
          successBuilder: (reputationList) {
            return LoadMoreListview(
              itemCount: reputationList.length,
              itemBuilder: (context, index) {
                return UserReputationItem(
                  data: reputationList[index],
                );
              },
              onGetMoreData: provider.loadMore,
              hasMore: provider.hasMore,
              loadMoreError: provider.loadMoreError,
            );
          },
        ),
      ),
    );
  }
}
