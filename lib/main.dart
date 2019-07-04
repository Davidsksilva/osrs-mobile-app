import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';

void main() => runApp(MyApp());

class Quest {
  String name;
  int questPointsReward;
  String length;
  bool membershipRequirement;
  String url;

  Quest(this.name, this.questPointsReward, this.length,
      this.membershipRequirement, this.url);

  Quest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    questPointsReward = int.parse(json['quest_points_reward']);
    length = json['length'];
    membershipRequirement = json['membership_requirement'] == 'true';
    debugPrint('$membershipRequirement');
    url = json['url'];
  }
}

class ListQuests extends StatefulWidget {
  @override
  ListQuestsState createState() => new ListQuestsState();
}

class ListQuestsState extends State<ListQuests> {
  final List<Quest> _questList = [];

  readJSON() async {
    final future =
        DefaultAssetBundle.of(context).loadString("assets/quests.json");
    future.then((data) {
      List questData = json.decode(data);
      List<Quest> list = questData.map((val) => Quest.fromJson(val)).toList();
      _questList.addAll(list);
    });
  }

  AssetImage _returnMembershipIcon(Quest quest) {
    if (quest.membershipRequirement == false) {
      return new AssetImage("assets/f2p_icon.png");
    } else {
      return new AssetImage("assets/member_icon.png");
    }
  }

  Widget _buildQuestRow(Quest quest) {
    /*return ListTile(
      title: Text(quest.name),
      trailing: Image(
        image: new AssetImage("assets/member_icon.png"),
        color: null,
),

    );*/

    return Container(
        height: 100,
        color: Colors.white,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Column(
              children: [
                Text(quest.name, textAlign: TextAlign.center),
              ],
            ),
          ),
          Expanded(
            child: Column(children: [
              Text(quest.length),
            ]),
          ),
          Expanded(
            child: Column(children: [
              Image(
                image: _returnMembershipIcon(quest),
                color: null,
              ),
            ]),
          ),
        ]));
  }

  Widget _buildQuestList() {
    return ListView.builder(
        padding: const EdgeInsets.all(14.0),
        itemCount: _questList.length,
        itemBuilder: (context, i) {
          return _buildQuestRow(_questList[i]);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_questList.isEmpty) {
      readJSON();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quests'),
      ),
      body: _buildQuestList(),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runescape Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListQuests(),
    );
  }
}
