import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sof_user_list/constants.dart';
import 'package:sof_user_list/features/user_list/model/user_model.dart';
import 'package:sof_user_list/routes.dart';
import 'package:sof_user_list/widgets/display_info_text.dart';

class UserListItem extends StatefulWidget {
  const UserListItem({super.key, required this.data, this.onBookmark});

  final UserModel data;
  final VoidCallback? onBookmark;

  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.marginComponent),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.userReputation, arguments: widget.data.userId);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.marginText),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  widget.data.profileImage ?? '',
                ),
              ),
              SizedBox(width: Space.marginComponent),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.data.displayName ?? '', style: TextStyle(fontSize: 15),),
                    const SizedBox(height: Space.marginText),
                    DisplayInfoText(
                      title: "Reputation",
                      value: NumberFormat.decimalPattern().format(widget.data.reputation),
                    ),
                    const SizedBox(height: Space.marginText),
                    DisplayInfoText(
                      title: 'Location',
                      value: widget.data.location ?? '-',
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  widget.data.isBookmarked == true ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: () {
                  widget.onBookmark?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
