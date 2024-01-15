
class TodoItem {
  final String name;
  //final List<condition> condition;



  TodoItem({
    required this.name,

    //required this.condition,

  });

  factory TodoItem.fromJson (Map<String, dynamic> json){
    return TodoItem(
      name: json['name'],

    );
  }
}
