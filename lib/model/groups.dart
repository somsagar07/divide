class Group {
  String gname;
  final List names;
  final List spend;
  String uid;

  Group(
      {required this.gname,
      required this.names,
      required this.spend,
      required this.uid});
  Map<String, dynamic> toMap() {
    return {
      'Gname': gname,
      'Name': names,
      'Spent': spend,
      'user': uid,
    };
  }
}
