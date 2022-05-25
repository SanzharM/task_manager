import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/models/comment.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/empty_box.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({Key? key, required this.comment}) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 32.0,
            width: 32.0,
            child: comment.user?.tryGetImage() ?? const Icon(CupertinoIcons.person_fill),
          ),
          const EmptyBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        comment.user?.name ?? ' ',
                        maxLines: 2,
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        Utils.getNamedDateTime(comment.createdAt),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Text(
                  comment.content ?? ' ',
                  maxLines: 8,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
