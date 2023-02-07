import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './model/meal_model.dart';
import 'package:html/parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Meal> futureMeal;

  Future<List<String>> fetchMeal(int menuIndex) async {
    final response = await http.get(Uri.parse(
        'https://dormitory.pknu.ac.kr/03_notice/req_getSchedule.php'));

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var targetElement = document.getElementsByClassName('board_box').first;

      String data = targetElement.text.replaceAll('\t', '');
      String data2 = data.replaceAll('\n', ',');

      List<String> mealTime =
          data2.split(',,').sublist(menuIndex, menuIndex + 8);
      return mealTime;
    } else {
      throw Exception('실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('오늘 밥 뭐야?'),
        ),
        body: FutureBuilder(
            future: fetchMeal(9),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    for (var meal in snapshot.data!)
                      Text(
                        meal,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      )
                  ],
                );
              } else {
                throw Error();
              }
              //return Container();
            }),
      ),
    );
  }
}
