import 'package:divide/model/groups.dart';
import 'package:flutter/material.dart';

class Divide extends StatefulWidget {
  final Group groups;

  const Divide({Key? key, required this.groups}) : super(key: key);

  @override
  _DivideState createState() => _DivideState();
}

class _DivideState extends State<Divide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 75, 141, 1),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Individual Expenses",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Color.fromRGBO(130, 200, 255, 0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Info(widget.groups.names, widget.groups.spend)),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Payee"),
                  Icon(Icons.keyboard_arrow_right),
                  Text("Pay"),
                  Icon(Icons.arrow_right),
                  Text("Amount")
                ],
              ),
              split(widget.groups.names, widget.groups.spend),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 75, 141, 1),
        onPressed: () {},
        child: Icon(Icons.payment),
      ),
    );
  }
}

class Customer {
  String name;
  int spent;

  Customer(this.name, this.spent);

  @override
  String toString() {
    return '{ ${this.name}, ${this.spent} }';
  }
}

Info(List a, List b) {
  String mem = "";
  String sp = "";
  String mem2 = "";

  for (int i = 0; i < a.length; i++) {
    if (i != a.length - 1) {
      mem = mem + a[i].toString() + "\n";
      sp = sp + " : \n";
      mem2 = mem2 + b[i].toString() + "\n";
    } else {
      mem = mem + a[i].toString() + "";
      sp = sp + " : ";
      mem2 = mem2 + b[i].toString() + "";
    }
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(
        mem,
        style: TextStyle(
          fontSize: 25,
        ),
      ),
      Text(sp, style: TextStyle(fontSize: 25)),
      Text(mem2, style: TextStyle(fontSize: 25))
    ],
  );
}

split(List keys, List values) {
  List ans1 = [];
  List ans2 = [];
  List ans3 = [];
  List list = [];

  for (int i = 0; i < keys.length; i++) {
    list.add(Customer(keys[i], values[i]));
  }
  var payments = {};

  list.forEach((customer) => payments[customer.name] = customer.spent);
  List p = payments.keys.toList();
  List v = payments.values.toList();
  List sp = p;
  List sv = v;
  var sum = v.reduce((acc, curr) {
    return curr + acc;
  });
  var mean = sum / p.length;

  sp.sort((pA, pB) => payments[pA] - payments[pB]);
  sv = sp.map((person) => payments[person] - mean).toList();

  var i = 0;
  var j = sp.length - 1;
  double d = 0;

  while (i < j) {
    if (-(sv[i]) > sv[j]) {
      d = sv[j];
    } else {
      d = -(sv[i]);
    }

    sv[i] = sv[i] + d;
    sv[j] = sv[j] - d;
    //String s = sp[i].toString() + " => " + sp[j].toString() + " :  Rs " + d.toString();

    ans1.add(sp[i].toString());
    ans2.add(sp[j].toString());
    ans3.add(d.toStringAsFixed(2));

    if (sv[i] == 0) {
      i++;
    }
    if (sv[j] == 0) {
      j--;
    }
  }
  return ListView.builder(
      itemCount: ans1.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          child: Container(
            height: 80,
            child: Card(
              color: Color.fromRGBO(0, 75, 141, 0.8),
              semanticContainer: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Gap(index),
                  Text(ans1[index],
                      style: TextStyle(fontSize: 25, color: Colors.white)),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 30,
                    color: Colors.white,
                  ),
                  Text(ans2[index],
                      style: TextStyle(fontSize: 25, color: Colors.white)),
                  Icon(Icons.arrow_right, size: 30, color: Colors.white),
                  Text(ans3[index],
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        );
      });
}
