import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide/model/groups.dart';
import 'package:divide/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'divide.dart';
import 'group_data.dart';

class Dash extends StatefulWidget {
  final UserModel user;
  const Dash({Key? key, required this.user}) : super(key: key);

  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final gnamesController = TextEditingController();
  final namesController = TextEditingController();
  final spentController = TextEditingController();
  final laternames = [];
  final laterspent = [];

  @override
  Widget build(BuildContext context) {
    final groups = Provider.of<List<Group>?>(context);

    return StreamProvider<List<Group>?>.value(
      value: Groupdata().groups,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Group"),
          backgroundColor: Color.fromRGBO(0, 75, 141, 1),
        ),
        body: Grouplist(user: widget.user),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromRGBO(0, 75, 141, 1),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      title: new Text("Add Expense Item"),
                      content: Container(
                        height: 350,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Group Name"),
                            TextField(
                              controller: gnamesController,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Names"),
                            TextField(
                              controller: namesController,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Expenditures"),
                            TextField(
                              controller: spentController,
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: ElevatedButton(
                                      onPressed: () => Addtodb(
                                          namesController,
                                          spentController,
                                          gnamesController,
                                          context,
                                          user!.uid),
                                      child: Icon(Icons.group_add_rounded)),
                                ),
                                Center(
                                  child: ElevatedButton(
                                      onPressed: () => Clear(namesController,
                                          spentController, gnamesController),
                                      child: Icon(Icons.clear_all)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Icon(Icons.add)),
      ),
    );
  }
}

class Grouplist extends StatefulWidget {
  final UserModel user;
  const Grouplist({Key? key, required this.user}) : super(key: key);
  @override
  _GrouplistState createState() => _GrouplistState();
}

class _GrouplistState extends State<Grouplist> {
  @override
  Widget build(BuildContext context) {
    final groups = Provider.of<List<Group>?>(context);
    if (groups == null) {
      return const Center(
        child: Text("Loading"),
      );
    }
    if (groups.isEmpty) {
      return const Center(
        child: Text("is empty"),
      );
    }
    return ListView.builder(
      itemCount: groups.length,
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemBuilder: (context, index) {
        if (widget.user.uid == groups[index].uid) {
          return GroupTile(groups: groups[index]);
        }
        return Container();
      },
    );
  }
}

class GroupTile extends StatelessWidget {
  final Group groups;
  const GroupTile({Key? key, required this.groups}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Divide(groups: groups)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Icon(Icons.group),
              ),
              Expanded(
                child: ListTile(
                  title: Text(groups.gname),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Members : ${groups.names.toString().replaceAll(",", ", ").replaceAll("[", "").replaceAll("]", "")}'),
                      Text(
                          'Expenditure : ${groups.spend.reduce((a, b) => a + b)}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Addtodb(
    TextEditingController namesController,
    TextEditingController spentController,
    TextEditingController gnamesController,
    BuildContext context,
    String uid) async {
  var n = namesController.text;
  var s = spentController.text.split(' ');
  List<int> ss = s.map(int.parse).toList();

  List<String> addname = n.split(' ');
  List<int> addspent = ss;
  var docname = gnamesController.text;
  Clear(namesController, spentController, gnamesController);
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Group group =
      Group(gname: docname, names: addname, spend: addspent, uid: uid);

  await firebaseFirestore.collection("Groups").doc(docname).set(group.toMap());
  Navigator.of(context, rootNavigator: true).pop();
}

Clear(
    TextEditingController namesController,
    TextEditingController spentController,
    TextEditingController gnamesController) {
  namesController.clear();
  gnamesController.clear();
  spentController.clear();
}
