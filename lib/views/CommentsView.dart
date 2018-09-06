import 'dart:async';

import 'package:flutter/material.dart';
import 'package:draw/draw.dart';

import 'widgets/image_post_card_widget.dart';
import 'widgets/text_post_card_widget.dart';
import 'widgets/comment_widget.dart';

class CommentsView extends StatefulWidget {
  CommentsView(this.sub);

  final Submission sub;

  @override
  _CommentsViewState createState() => _CommentsViewState(sub);
}

class _CommentsViewState extends State<CommentsView> {
  _CommentsViewState(this.submission);

  Submission submission;

  @override
  initState() {
    super.initState();
  }

  Future<CommentForest> initComments() async {
    CommentForest comments = await submission.refreshComments();
    return comments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: ListView(
            children: <Widget>[
              Container(
                child: Text(
                  "Comments",
                  style:
                      TextStyle(fontFamily: "Raleway-SemiBold", fontSize: 32.0),
                ),
                padding: EdgeInsets.only(
                    top: 32.0, bottom: 16.0, left: 16.0, right: 16.0),
              ),
              Builder(builder: (c) {
                if (submission.isSelf) {
                  return TextPost(submission);
                } else {
                  return ImagePost(submission, submission.score);
                }
              }),
              Container(height: 16.0),
              FutureBuilder(
                  future: initComments(),
                  builder: (c, snapshot) {
                    if (snapshot.hasData) {
                      CommentForest comments = snapshot.data;
                      return Column(
                        children: List.generate(comments.length, (index) {
                          var thisComment = comments[index];
                          return CommentWidget(thisComment);
                        }),
                      );
                    } else {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      return Container(
                        height: 0.0,
                        width: 0.0,
                      );
                    }
                  })
            ],
          ),
        ),
      ]),
    );
  }
}
