import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'player_page.dart';
import 'game_round_page.dart';
import 'dart:math';
import 'dart:convert';

class GamePage extends StatelessWidget {
  final bool newGame;
  final Map<String, int> players;

  const GamePage({super.key, required this.players, required this.newGame});

  @override
  Widget build(BuildContext context) {
    Map<String, String> categories = {
      "animal.avif": "حيوانات",
      "spy.webp": "الجاسوس",
      "fruit.avif": "فواكه",
      "games.webp": "ألعاب",
      "jobs.jpg": "وظائف",
      "player.jpg": "لاعبين",
      "world.jpg": "دول",
      "animes.jpg": "أنميات",
    };
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 0, 15, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        iconSize: 28,
                      ),
                      Text(
                        "اختر نوع لسالفة السالفة",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 5,
                  runSpacing: 25,
                  children: [
                    for (var entry in categories.entries)
                      TextButton(
                        onPressed: () async {
                          if (newGame) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlayerPage(selectedCategory: entry.key),
                              ),
                            );
                          } else {
                            // load json file
                            String jsonString = await DefaultAssetBundle.of(
                              context,
                            ).loadString("assets/categories.json");
                            Map<String, dynamic> data = json.decode(jsonString);

                            // pick category
                            var category = data[entry.key];
                            List items = category["items"];

                            // pick random item
                            final random = Random();
                            final String Item;
                            Item = items[random.nextInt(items.length)];
                            // pick random player
                            String randomPlayer = players.keys.elementAt(
                              random.nextInt(players.length),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameRoundPage(
                                  category: entry.key,
                                  players: players,
                                  item: Item,
                                  outsidePlayer: randomPlayer,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.color1,
                              width: 3,
                            ),
                            color: AppColors.color1,
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: Image.asset(
                                  "assets/img/${entry.key}",
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 5,
                                right: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.color1,
                                      width: 2.5,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "${entry.value}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.color5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
