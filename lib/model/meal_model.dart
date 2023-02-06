class Meal {
  final String time;
  final String meals;

  Meal.fromJson(Map<String, dynamic> json)
      : meals = json['meals'],
        time = json['time'];
}
