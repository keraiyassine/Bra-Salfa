import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/animated_play_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showAbout = false;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      width: 260,
                      height: 260,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.asset("assets/img/Logo.png"),
                      ),
                    ),
                    Container(
                      child: Text(
                        "برا السالفة",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    AnimatedPlayButton(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAbout = true;
                        });
                      },
                      style: TextButton.styleFrom(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 3, color: Colors.white),
                            ),
                            child: Icon(
                              Icons.question_mark_sharp,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "حول اللعبة   ",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_showAbout)
            Center(
              child: Container(
                width: 320,
                height: 550,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.color5,
                  border: Border.all(width: 3, color: Colors.white),
                ),
                child: Column(
                  children: [
                    Text(
                      "تُعتبر لعبة برة السالفة من ألعاب الألغاز، حيث يتم فيها إخفاء شيء ما عن أحد اللاعبين الذي هو برة السالفة -باختيار من تطبيق الجوال نفسه-، وإظهاره للاعبين الآخرين، وفي هذا الوقت على اللاعبين إدارة حوار فيما بينهم يقوم على أسئلة حول ذلك الشيء، وملاحظة تعابير وجه باقي اللاعبين وإجاباتهم بدقة؛ لمعرفة اللاعب (برة السالفة) والحصول على النقطة، في الوقت ذاته على اللاعب الذي هو برة السالفة ملاحظة أجوبة اللاعبين لمعرفة الشيء الذي يدور حوله الحديث والحصول على نقطة",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAbout = false;
                        });
                      },
                      child: Text(
                        "فهمت",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.color2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
