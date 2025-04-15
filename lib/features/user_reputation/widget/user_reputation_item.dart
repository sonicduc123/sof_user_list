import 'package:flutter/material.dart';
import 'package:sof_user_list/constants.dart';
import 'package:sof_user_list/features/user_reputation/model/reputation_model.dart';
import 'package:sof_user_list/widgets/display_info_text.dart';

class UserReputationItem extends StatelessWidget {
  const UserReputationItem({super.key, required this.data});

  final ReputationModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: (data.reputationHistoryType ?? '').toUpperCase(),
            style: const TextStyle(color: Colors.black, fontSize: 15),
            children: [
              TextSpan(
                text: " (${data.reputationChange?.compareTo(0) == 1 ? '+' : ''}${data.reputationChange ?? 0})",
                style: TextStyle(color: data.reputationChange?.compareTo(0) == -1 ? Colors.red : Colors.green),
              ),
            ],
          ),
        ),
        SizedBox(height: Space.marginText),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DisplayInfoText(title: 'Post ID', value: '${data.postId ?? 0}'),
            Text(DateTime.fromMillisecondsSinceEpoch((data.creationDate ?? 0) * 1000).toString().substring(0, 19)),

          ]
        ),
        SizedBox(height: Space.marginText),
        Divider(),
      ],
    );
  }
}
