class ToDoModel {
  ToDoModel({
    required this.heading,
    required this.body,
    required this.time,
    required this.isCompleted,
  });

  String heading;
  String body;
  DateTime time;
  bool isCompleted;

  Map<String, dynamic> toMap() {
    return {
      'heading': heading,
      'body': body,
      'time': time,
      'isCompleted': isCompleted,
    };
  }

  factory ToDoModel.fromMap(Map<String, dynamic> todo) {
    return ToDoModel(
      heading: todo['heading'],
      body: todo['body'],
      time: todo['time'],
      isCompleted: todo['isCompleted'],
    );
  }
}

ToDoModel todo = ToDoModel(
  heading: 'Welcome',
  body: "Hello, I'm Amit Choudhary I made this app hope you like this app.",
  time: DateTime.now(),
  isCompleted: false,
);
