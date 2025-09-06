import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import '../utils/app_colors.dart';
import 'game_page.dart';
import 'game_round_page.dart';

class RoundFinishPage extends StatefulWidget {
  final Map<String, int> players;
  final String outsidePlayer;
  final String item;
  final String category;
  const RoundFinishPage({
    super.key,
    required this.players,
    required this.outsidePlayer,
    required this.category,
    required this.item,
  });

  @override
  State<RoundFinishPage> createState() => _RoundFinishPageState();
}

class _RoundFinishPageState extends State<RoundFinishPage> {
  bool resultShow = false;
  bool statShow = false;
  late Future<List> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = generateItems(widget.category);
  }

  Future<List> generateItems(String categoryKey) async {
    // load json file
    String jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString("assets/categories.json");
    Map<String, dynamic> data = json.decode(jsonString);
    // pick category
    var category = data[categoryKey];
    List items = category["items"];
    // pick random item
    final random = Random();
    List randomItems = [widget.item];
    String item;
    for (int i = 0; i < 7; i++) {
      item = items[random.nextInt(items.length)];
      while (randomItems.contains(item)) {
        item = items[random.nextInt(items.length)];
      }
      randomItems.add(item);
    }
    randomItems.shuffle();
    return randomItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/img/question-mark.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromARGB(219, 21, 31, 35),
          ),
          if (!statShow)
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: FutureBuilder<List>(
                  future: _itemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final items = snapshot.data ?? [];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                            child: Text(
                              textAlign: TextAlign.center,
                              "اعطوا الهاتف للذي برا السالفة كي يخمن ما هي",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          for (var item in items)
                            Container(
                              width: 300,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: resultShow
                                    ? (item == widget.item
                                          ? AppColors.color3
                                          : AppColors.color4)
                                    : AppColors.color2,
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: TextButton(
                                onPressed: resultShow
                                    ? null
                                    : () async {
                                        final AudioPlayer _player =
                                            AudioPlayer();
                                        setState(() {
                                          resultShow = true;
                                          if (item == widget.item) {
                                            widget.players.update(
                                              widget.outsidePlayer,
                                              (value) => value + 1,
                                            );
                                          }
                                        });
                                        if (item == widget.item) {
                                          await _player.play(
                                            AssetSource(
                                              "soundEffect/success.mp3",
                                            ),
                                          );
                                        } else {
                                          await _player.play(
                                            AssetSource("soundEffect/fail.mp3"),
                                          );
                                        }
                                      },
                                child: Text(
                                  "$item",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if (resultShow && !statShow)
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
                              width: 200,
                              decoration: BoxDecoration(
                                color: AppColors.color1,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 0,
                              ),
                              height: 80,

                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    statShow = true;
                                  });
                                },

                                child: Text(
                                  "النتائج",
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          if (statShow)
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.80,
              margin: EdgeInsets.fromLTRB(0, 60, 0, 15),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 30,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "النقاط:",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: AppColors.color2,
                          ),
                        ),
                        Text(
                          "اللاعبين: ",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: AppColors.color2,
                          ),
                        ),
                      ],
                    ),
                    for (var player in widget.players.entries)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "${player.value}",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${player.key}",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (statShow)
            Positioned(
              bottom: 120,
              right: 20,
              left: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.color1,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    height: 100,
                    width: 150,

                    child: TextButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GamePage(
                              players: widget.players,
                              newGame: false,
                            ),
                          ),
                        );
                      },

                      child: Text(
                        "تغيير نوع السالفة",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.color1,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    height: 100,
                    width: 150,

                    child: TextButton(
                      onPressed: () async {
                        // load json file
                        String jsonString = await DefaultAssetBundle.of(
                          context,
                        ).loadString("assets/categories.json");
                        Map<String, dynamic> data = json.decode(jsonString);

                        // pick category
                        var category = data[widget.category];
                        List items = category["items"];

                        // pick random item
                        final random = Random();
                        final String Item;
                        Item = items[random.nextInt(items.length)];
                        // pick random player
                        String randomPlayer = widget.players.keys.elementAt(
                          random.nextInt(widget.players.length),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameRoundPage(
                              players: widget.players,
                              outsidePlayer: randomPlayer,
                              category: widget.category,
                              item: Item,
                            ),
                          ),
                        );
                      },

                      child: Text(
                        "اكمال اللعب",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
