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

  Future<void> fetchMeal() async {
    final response = await http.get(Uri.parse(
        'https://dormitory.pknu.ac.kr/03_notice/req_getSchedule.php'));

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var targetElement = document.getElementsByClassName('board_box').first;

      String data = targetElement.text.replaceAll('\t', '');
      String data2 = data.replaceAll('\n', ',');

      List<String> dataBreakfast =
          data2.substring(0, data2.indexOf('점심')).split(',,').sublist(9, 17);
      for (var i = 0; i < dataBreakfast.length; i++) {
        print(dataBreakfast[i]);
      }

      List<String> dataLunch =
          data2.substring(0, data2.indexOf('저녁')).split(',,').sublist(18, 26);
      for (var i = 0; i < dataLunch.length; i++) {
        print(dataLunch[i]);
      }

      List<String> dataDinner = data2.substring(0).split(',,').sublist(26);
      for (var i = 0; i < dataDinner.length; i++) {
        print(dataDinner[i]);
      }

      //Map<String, dynamic> jsonMap = {'data': data2};

      //String jsonString = json.encode(jsonMap);
      //  print(jsonString);
    } else {
      throw Exception('실패');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMeal();
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
      ),
    );
  }
}
