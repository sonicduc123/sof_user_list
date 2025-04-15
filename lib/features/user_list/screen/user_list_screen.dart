import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sof_user_list/common/handle_state/state_widget.dart';
import 'package:sof_user_list/common/handle_state/view_state.dart';
import 'package:sof_user_list/common/loadmore/load_more_listview.dart';
import 'package:sof_user_list/constants.dart';
import 'package:sof_user_list/features/user_list/provider/user_list_provider.dart';
import 'package:sof_user_list/features/user_list/widget/user_list_item.dart';
import 'package:sof_user_list/widgets/custom_filter_chip.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserListProvider provider = context.read<UserListProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('StackOverflow User List'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.paddingLayout),
        child: Column(
          children: [
            const SizedBox(height: Space.marginElement),
            Expanded(
              child: CustomFilterChip(
                listLabel: const ['All', 'Bookmarked'],
                listCountElement: [
                  provider.userListLength,
                  provider.bookmarkListLength,
                ],
                listWidget: [
                  StateWidget(
                    state: context.watch<UserListProvider>().userListState,
                    successBuilder: (userList) {
                      return LoadMoreListview(
                        key: PageStorageKey(0),
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return UserListItem(
                            data: userList[index],
                            onBookmark: () async{
                              await provider.onTapBookmark(userList[index]);

                              if (userList[index].isBookmarked == true) {
                                if (provider.addBookmarkState is SuccessState) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bookmark added'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else if (provider.addBookmarkState is FailureState) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bookmark failed'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                if (provider.deleteBookmarkState is SuccessState) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bookmark removed'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bookmark removal failed'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                        onGetMoreData: provider.loadMore,
                        hasMore: provider.hasMore,
                        loadMoreError: provider.loadMoreError,
                      );
                    },
                  ),
                  StateWidget(
                    state: context.watch<UserListProvider>().bookmarkListState,
                    emptyWidget: const Center(
                      child: Text('No Bookmarked User'),
                    ),
                    successBuilder: (userList) {
                      return ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return UserListItem(
                            data: userList[index],
                            onBookmark: () async{
                              int lastLength = userList.length;
                              await provider.onTapBookmark(userList[index]);

                              if (userList.length < lastLength) {
                                if (provider.deleteBookmarkState is SuccessState) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bookmark removed'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bookmark removal failed'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
