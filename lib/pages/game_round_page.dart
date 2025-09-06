import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import '../utils/app_colors.dart';
import '../widgets/background.dart';
import 'round_finish_page.dart';

class GameRoundPage extends StatefulWidget {
  final String item;
  final String category;
  final Map<String, int> players;
  final String outsidePlayer;

  const GameRoundPage({
    super.key,
    required this.item,
    required this.players,
    required this.outsidePlayer,
    required this.category,
  });

  @override
  State<GameRoundPage> createState() => _GameRoundPageState();
}

class _GameRoundPageState extends State<GameRoundPage> {
  int counter = 0;
  bool show = false; //show to the player if they are in Salfa
  bool showQestion = false; // show the question selected by the app
  int questions = 0;
  List askedList = [];
  bool isAskedListEmpty = false;
  String asked = "";
  List voterList = [];
  String voter = "";
  String qusetioner = "";
  bool vote = false; // to show vote page
  bool showBraSalfa = false;
  bool timerFinish = false;
  final AudioPlayer _player = AudioPlayer();

  List<String> shuffledPlayers = [];
  String? currentName;

  @override
  void initState() {
    super.initState();
    askedList = widget.players.keys.toList();
    askedList.shuffle(); // shuffle the order once

    voterList = widget.players.keys.toList();
    voterList.shuffle(); // shuffle the order once
  }

  void startRevealPlayers() async {
    await _player.play(AssetSource("soundEffect/drum_roll.mp3"));
    Duration totalDuration = const Duration(milliseconds: 4800);
    int intervalMs = 300; // every 0.5 second change the name
    int elapsed = 0;

    Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      elapsed += intervalMs;

      if (elapsed < totalDuration.inMilliseconds) {
        setState(() {
          // choose random name each time
          List<String> shuffled = widget.players.keys.toList()..shuffle();
          currentName = shuffled.first;
        });
      } else {
        timer.cancel();
        // after five seconds the outside player name appear
        setState(() {
          currentName = widget.outsidePlayer;
          timerFinish = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          if (!show && !showQestion)
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(25, 45, 25, 45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      "${widget.players.keys.elementAt(counter)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color2,
                      ),
                    ),
                  ),
                  Text(
                    "أعط الهاتف ل${widget.players.keys.elementAt(counter)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 160),
                    child: Text(
                      "اضغط التالي لتعرف ان كنت داخل السالفة او لا... لاتدع احد غيرك يرى الشاشة!!",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (show && !showQestion)
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(25, 45, 25, 45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      "${widget.players.keys.elementAt(counter)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color2,
                      ),
                    ),
                  ),
                  Text(
                    widget.players.keys.elementAt(counter) !=
                            widget.outsidePlayer
                        ? "انت في السالفة والسالفة هي ${widget.item}. مهمتك هي محاولة معرفة من برا السالفة من خلال اسئلتك و اسئلة اللاعبين الاخرين"
                        : "أنت هو الذي برا السالفة!!. مهمتك هي اكتشاف ما هي السالفة وتجنب معرفة بقية اللاعبين انك  انت الذي برا السالفة",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 160),
                    child: Text(
                      "اضغط التالي للاستمرار!!",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (showQestion && !vote)
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(25, 45, 25, 45),
              child: Padding(
                padding: EdgeInsets.only(top: !isAskedListEmpty ? 160.0 : 20),
                child: Column(
                  children: [
                    Text(
                      "وقت الأسئلة",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: AppColors.color2,
                      ),
                    ),
                    if (!isAskedListEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          "$qusetioner اسأل $asked سؤال عن السالفة وحاول الا توضح ماهي السالفة",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (isAskedListEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                        child: Text(
                          "$asked اختر شخص تسأله سؤال عن السالفة وحاول الا توضح ماهي السالفة",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (isAskedListEmpty)
                      SingleChildScrollView(
                        child: Column(
                          spacing: 14,
                          children: [
                            for (var player in widget.players.keys.where(
                              (p) => p != asked,
                            ))
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  color: AppColors.color2,
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      asked = player;
                                    });
                                  },
                                  child: Text(
                                    "$player",
                                    style: TextStyle(
                                      fontSize: 26,
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
            ),

          if (vote && !showBraSalfa)
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(25, 45, 25, 45),
              child: Padding(
                padding: EdgeInsets.only(top: !isAskedListEmpty ? 160.0 : 20),
                child: Column(
                  children: [
                    Text(
                      "وقت التصويت",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: AppColors.color2,
                      ),
                    ),
                    if (isAskedListEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                        child: Text(
                          "$voter اختر شخص تظن انه هو الذي برا السالفة",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    SingleChildScrollView(
                      child: Column(
                        spacing: 14,
                        children: [
                          for (var player in widget.players.keys.where(
                            (p) => p != voter,
                          ))
                            Container(
                              width: 300,
                              decoration: BoxDecoration(
                                color: AppColors.color2,
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (player == widget.outsidePlayer) {
                                      widget.players.update(
                                        voter,
                                        (value) => value + 1,
                                      );
                                    }
                                    if (voterList.isNotEmpty) {
                                      voter = voterList.removeLast();
                                    } else {
                                      setState(() {
                                        showBraSalfa = true;
                                        startRevealPlayers();
                                      });
                                    }
                                  });
                                },
                                child: Text(
                                  "$player",
                                  style: TextStyle(
                                    fontSize: 26,
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
            ),

          if (showBraSalfa)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 180),
              child: Column(
                children: [
                  const Text(
                    "الذي برا السالفة هو...",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/img/vote_placeholder.png"),
                      Text(
                        currentName ?? "",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color:
                              currentName == widget.outsidePlayer && timerFinish
                              ? AppColors.color4
                              : Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (timerFinish)
            Positioned(
              bottom: 70,
              right: 110,
              left: 110,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.color1,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                height: 80,

                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoundFinishPage(
                          players: widget.players,
                          outsidePlayer: widget.outsidePlayer,
                          category: widget.category,
                          item: widget.item,
                        ),
                      ),
                    );
                  },

                  child: Text(
                    "التالي",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          if (!vote)
            Positioned(
              bottom: 120,
              right: 110,
              left: 110,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.color1,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                height: 80,

                child: TextButton(
                  onPressed: () {
                    if (counter == widget.players.length - 1 &&
                        show &&
                        !isAskedListEmpty) {
                      setState(() {
                        showQestion = true;
                        final Random random = Random();
                        isAskedListEmpty = askedList.isEmpty;
                        asked = !isAskedListEmpty
                            ? askedList.removeLast()
                            : widget.players.keys.elementAt(
                                random.nextInt(widget.players.length),
                              );
                        print(isAskedListEmpty);
                        print(askedList);
                        qusetioner = widget.players.keys.elementAt(
                          random.nextInt(widget.players.length),
                        );
                        while (asked == qusetioner) {
                          qusetioner = widget.players.keys.elementAt(
                            random.nextInt(widget.players.length),
                          );
                        }
                      });
                    } else if (counter == widget.players.length - 1 &&
                        show &&
                        isAskedListEmpty) {
                      setState(() {
                        vote = true;
                        voter = voterList.removeLast();
                      });
                    } else {
                      setState(() {
                        if (show) {
                          show = false;
                          counter++;
                        } else {
                          show = true;
                        }
                      });
                    }
                  },
                  child: Text(
                    !isAskedListEmpty ? "التالي" : "تصويت",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
