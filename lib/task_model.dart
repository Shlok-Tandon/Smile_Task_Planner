class Task {
  String title;
  String? time;
  String? description;
  String? meetingLink;
  bool isCompleted;

  Task({
    required this.title,
    this.time,
    this.description,
    this.meetingLink,
    this.isCompleted = false,
  });

  // To JSON
  Map<String, dynamic> toJson() => {
    'title': title,
    'time': time,
    'description': description,
    'meetingLink': meetingLink,
    'isCompleted': isCompleted,
  };

  // From JSON
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    time: json['time'],
    description: json['description'],
    meetingLink: json['meetingLink'],
    isCompleted: json['isCompleted'],
  );
}