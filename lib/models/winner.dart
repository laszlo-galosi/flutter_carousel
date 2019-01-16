class Winner {
  final String name;
  final String prizeImage;
  final String date;
  final String prizeName;

  const Winner({this.name, this.date, this.prizeName, this.prizeImage});

  Winner.fromMap(Map<String, dynamic> map)
      : name = map['nev'],
        date = map['datum'],
        prizeName = map['nyeremeny'],
        prizeImage = map['nyeremenykep'];
}
