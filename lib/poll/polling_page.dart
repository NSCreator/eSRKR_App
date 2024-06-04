import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth_page.dart';
import '../functions.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polls/flutter_polls.dart'; // Assuming you have imported the flutter_polls package

class PollContainer extends StatefulWidget {
  final DocumentSnapshot pollSnapshot;

  const PollContainer({required this.pollSnapshot});

  @override
  State<PollContainer> createState() => _PollContainerState();
}

class _PollContainerState extends State<PollContainer> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> poll = widget.pollSnapshot.data() as Map<String, dynamic>;
    final DateTime endDate = poll['end_date'].toDate();
    final int days = endDate.difference(DateTime.now()).inDays;

    final List<Map<String, dynamic>> votedIds = List<Map<String, dynamic>>.from(poll['votedIds'] ?? []);
    bool hasVoted = votedIds.any((element) => element['id'] == fullUserId());
    String? userVotedOptionId;

    if (hasVoted) {
      final Map<String, dynamic>? userVotedOption = votedIds.firstWhere((element) => element['id'] == fullUserId());
      userVotedOptionId = userVotedOption?['votedFor']?.toString();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: FlutterPolls(
        votedBackgroundColor:Colors.blueGrey.shade700,
        leadingVotedProgessColor:Colors.white70,
        votedPercentageTextStyle:TextStyle(color: Colors.white),

        votedProgressColor:Colors.white30,
        pollOptionsBorder:Border.all(color: Colors.white30),

        votedAnimationDuration: 500,
        pollId: poll['id'].toString(),
        hasVoted: hasVoted,
        userVotedOptionId: userVotedOptionId,
        onVoted: (PollOption pollOption, int newTotalVotes) async {
          try {
            if (isAnonymousUser()) {
              showToastText("Please log in with your college ID.");
              return false;
            }

            List<Map<String, dynamic>> options = List<Map<String, dynamic>>.from(poll['options']);
            int votedOptionIndex = int.parse(pollOption.id.toString()) - 1;
            options[votedOptionIndex]['votes'] = pollOption.votes + 1;

            await FirebaseFirestore.instance.collection("polls").doc(widget.pollSnapshot.id).update({
              'options': options,
              'votedIds': FieldValue.arrayUnion([
                {"id": fullUserId(), "votedFor": pollOption.id}
              ]),
            });

            return true;
          } catch (e) {
            print('Error updating poll options: $e');
            return false;
          }
        },
        pollEnded: days < 0,
        pollTitle: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            poll['question'],
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        pollOptions: List<PollOption>.from(
          poll['options'].map(
                (option) => PollOption(
              id: option['id'].toString(),
              title: Text(
                option['title'],
                style:  TextStyle(
                  fontSize: 15,
                  color: hasVoted ?Colors.black:Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              votes: option['votes'],
            ),
          ),
        ),

        metaWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 6),
            Row(
              children: [
                const Text('•'),
                const SizedBox(width: 3),
                Text(
                  days < 0 ? "ended" : "ends in $days days",
                  style: TextStyle(fontSize: 12,color: Colors.white70),
                ),
              ],
            ),
            if (hasVoted&&days > 0 ) InkWell(
              onTap: () async {
                try {
                  int userVoteIndex = votedIds.indexWhere((element) => element['id'] == fullUserId());

                  if (userVoteIndex != -1) {
                    List<Map<String, dynamic>> options = List<Map<String, dynamic>>.from(poll['options']);
                    int votedOptionIndex = int.parse(votedIds[userVoteIndex]['votedFor']) - 1;
                    options[votedOptionIndex]['votes'] = options[votedOptionIndex]['votes'] - 1;

                    await FirebaseFirestore.instance.collection("polls").doc(widget.pollSnapshot.id).update({
                      'options': options,
                      'votedIds': FieldValue.arrayRemove([votedIds[userVoteIndex]]),
                    });

                    setState(() {}); // Refresh widget
                  } else {
                    // Handle case where the user has not voted yet
                    print('User has not voted yet.');
                  }
                } catch (e) {
                  print('Error removing vote: $e');
                }
              },
              child: Text(
                "Remove Vote ",
                style: TextStyle(fontSize: 14, color: Colors.orangeAccent),
              ),
            )
          ],
        ),
      ),
    );
  }
}

