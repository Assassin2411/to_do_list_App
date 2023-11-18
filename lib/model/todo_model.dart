class ToDoModel {
  ToDoModel({
    required this.heading,
    required this.body,
    required this.time,
  });

  String heading;
  String body;
  DateTime time;

  Map<String, dynamic> toMap() {
    return {
      'heading': heading,
      'body': body,
      'time': time,
    };
  }

  factory ToDoModel.fromMap(Map<String, dynamic> todo) {
    return ToDoModel(
      heading: todo['heading'],
      body: todo['body'],
      time: todo['time'],
    );
  }
}

ToDoModel todo = ToDoModel(
  heading: 'Welcome',
  body: "Hello, I'm Amit Choudhary I made this app hope you like this app.",
  time: DateTime.now(),
);
