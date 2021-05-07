class Note{
  String title;
  String description;
  String timestamp;
  int color;
  String id;

  Note({this.title,this.description,this.timestamp,this.color,this.id});

  Note.fromMap(Map<String, dynamic> map) {
    this.title = map['title'];
    this.description = map['description'];
    this.timestamp = map['timestamp'];
    this.color = map['color'];
  }

}