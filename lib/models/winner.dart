class Winner {
  final int id;
  final String name;
  final String prizeImage;
  final String date;
  final String prizeName;

  const Winner(
      {this.id, this.name, this.date, this.prizeName, this.prizeImage});

  Winner.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['nev'],
        date = map['datum'],
        prizeName = map['nyeremeny'],
        prizeImage = map['nyeremenykep'];

  @override
  String toString() {
    return 'Winner{id: $id, name: $name, date: $date, prizeName: $prizeName prizeImage: $prizeImage,}';
  }
}
