class TodoModel {
  int? id;
  String title;
  String description;

  TodoModel({this.id, required this.title, required this.description});

  set setId(id) => this.id = id;
  set setTitle(title) => this.title = title;
  set setDescription(description) => this.description = description;

  factory TodoModel.fromDB(Map<String, dynamic> data){
    return TodoModel(id: data['id'],title: data['title'], description: data['description']);
  }

  Map<String, Object?> toObject(){
    return {
      "id": id,
      "title": title,
      "description": description
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return "{id: $id, title: $title, description: $description}";
  }
}
