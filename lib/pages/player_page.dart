import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import '../utils/app_colors.dart';
import 'game_round_page.dart';

class PlayerPage extends StatefulWidget {
  final String selectedCategory;

  const PlayerPage({super.key, required this.selectedCategory});
  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  Map<int, String> players = {1: "لاعب 1", 2: "لاعب 2", 3: "لاعب 3"};
  bool add = false; // to open pop up
  bool edit = false; // to know if the pop up is for editing or not
  int editingKey = 0;

  final TextEditingController nameController = TextEditingController();

  Future<String> getRandomItem(String categoryKey) async {
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
    return items[random.nextInt(items.length)];
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
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                width: double.infinity,
                child: Text(
                  textAlign: TextAlign.center,
                  "اقل عدد لبدأ اللعب هو 3, يمكنك اضافة المزيد من اللاعبين وتعديل اسمائهم ادناه",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var player in players.entries)
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.color2,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          width: 2,
                                          color: AppColors.color2,
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          edit = true;
                                          editingKey = player.key;
                                          nameController.text = player.value;
                                        });
                                      },
                                      icon: Icon(Icons.edit),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${player.value}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          width: 2,
                                          color: AppColors.color2,
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          players.remove(player.key);
                                        });
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 45),
                      decoration: BoxDecoration(
                        color: AppColors.color5,
                        border: Border.all(color: AppColors.color1, width: 3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 2,
                                  color: AppColors.color1,
                                ),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  add = true;
                                });
                              },
                              icon: Icon(Icons.person_add_alt_1_rounded),
                              iconSize: 40,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              String item = await getRandomItem(
                                widget.selectedCategory,
                              );

                              // Pick a random player
                              final random = Random();
                              String randomPlayer = players.values.elementAt(
                                random.nextInt(players.length),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameRoundPage(
                                    item: item,
                                    players: {
                                      for (var name in players.values) name: 0,
                                    },
                                    outsidePlayer: randomPlayer,
                                    category: widget.selectedCategory,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 4, 40, 4),
                              child: Text(
                                "بدأ اللعب",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
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
              ),
            ],
          ),
          if (add || edit)
            Container(
              color: const Color.fromARGB(77, 35, 37, 41),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                  padding: EdgeInsets.fromLTRB(35, 20, 35, 20),
                  decoration: BoxDecoration(
                    color: AppColors.color5,
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 137, 137, 174),
                        offset: Offset(0, 0),
                        blurRadius: 6,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          add ? "اضافة لاعب جديد" : "تعديل اسم اللاعب",
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 42, 42, 44),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: nameController,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(color: Colors.white, fontSize: 24),
                          decoration: InputDecoration(
                            hintText: "اكتب الاسم هنا...",
                            hintStyle: TextStyle(fontSize: 24),
                            hintTextDirection: TextDirection.rtl,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextButton(
                          onPressed: () {
                            if (nameController.text != "") {
                              setState(() {
                                if (add) {
                                  add = false;
                                  players[players.length + 1] =
                                      nameController.text;
                                  nameController.clear();
                                } else {
                                  edit = false;
                                  players[editingKey] = nameController.text;
                                  nameController.clear();
                                }
                              });
                            }
                          },
                          child: Text(
                            add ? "اضافة" : "تعديل",
                            style: TextStyle(color: Colors.white, fontSize: 26),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
