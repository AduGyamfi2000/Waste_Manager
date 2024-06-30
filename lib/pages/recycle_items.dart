import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/items.dart';

class RecycleItemsPage extends StatefulWidget {
  const RecycleItemsPage({Key? key, String? name}) : super(key: key);

  @override
  RecycleItemsPageState createState() => RecycleItemsPageState();
}

class RecycleItemsPageState extends State<RecycleItemsPage> {
  final formKey = GlobalKey<FormState>();
  late List<Items> items = [];
  String name = "";
  String mrp = "";
  String condition = "";
  String category = "";
  int selectedOption = -1;
  int selectedConOption = -1;
  DatabaseReference reference = FirebaseDatabase.instance
      .ref("user/${FirebaseAuth.instance.currentUser!.uid}");

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    reference.child("items").once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            Map<String, dynamic> values =
                snapshot.value as Map<String, dynamic>;
            values.forEach((key, value) {
              setState(() {
                items.add(Items(value["name"], value["mrp"], value["condition"],
                    value["category"]));
              });
            });
          }
        } as FutureOr Function(DatabaseEvent value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("Add the details of product",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Colors.blue)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 10.0,
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 1.2,
                      height: MediaQuery.of(context).size.height * 1.2,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "empty value";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  labelText: "Product name",
                                  hintText: "enter here"),
                            ),
                            TextFormField(
                              onChanged: (price) {
                                mrp = price;
                                setState(() {});
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "empty value";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  labelText:
                                      "Mrp at which product is bought in ₹.",
                                  hintText: "₹"),
                            ),
                            const SizedBox(height: 20),
                            Text(
                                "Choose the category of item which you want to recycle",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700])),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                SizedBox(
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    primary: false,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8),
                                    crossAxisSpacing: 7,
                                    mainAxisSpacing: 7,
                                    childAspectRatio: 1.2,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedOption = 1;
                                            category =
                                                "Fridges, freezers and other cooling equipment";
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectedOption == 1
                                                  ? Colors.green
                                                  : Colors.blue[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                                "A. Fridges, freezers and other cooling equipment",
                                                style: TextStyle()),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedOption = 2;
                                            category =
                                                "Computers and telecommunications equipment";
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectedOption == 2
                                                  ? Colors.green
                                                  : Colors.blue[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              "B. Computers and telecommunications equipment",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedOption = 3;
                                            category =
                                                "Consumer electronic devices and solar panels";
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectedOption == 3
                                                  ? Colors.green
                                                  : Colors.blue[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              "C. Consumer electronic devices and solar panels.",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedOption = 4;
                                            category =
                                                "TVs, monitors,Led Bulbs and screens";
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectedOption == 4
                                                  ? Colors.green
                                                  : Colors.blue[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              "D. TVs, monitors,Led Bulbs and screens",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedOption = 5;
                                            category =
                                                "Medical device,toys, leisure and sports equipment";
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectedOption == 5
                                                  ? Colors.green
                                                  : Colors.blue[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              "E. Medical device,toys, leisure and sports equipment",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedOption = 6;
                                            category = "other";
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectedOption == 6
                                                  ? Colors.green
                                                  : Colors.blue[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              "F. other",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Condition of product",
                              textScaleFactor: 1.2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700]),
                            ),
                            Column(
                              children: [
                                ListTile(
                                  title: const Text("working"),
                                  leading: Radio(
                                    value: 1,
                                    groupValue: selectedConOption,
                                    onChanged: (value) {
                                      setState(() {
                                        condition = "working";
                                        selectedConOption = value as int;
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                ),
                                ListTile(
                                  title: const Text("not working"),
                                  leading: Radio(
                                    value: 2,
                                    groupValue: selectedConOption,
                                    onChanged: (value) {
                                      setState(() {
                                        condition = "not working";
                                        selectedConOption = value as int;
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                ),
                                ListTile(
                                  title: const Text("partially working"),
                                  leading: Radio(
                                    value: 3,
                                    groupValue: selectedConOption,
                                    onChanged: (value) {
                                      setState(() {
                                        condition = "partially working";
                                        selectedConOption = value as int;
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                ),
                                ListTile(
                                  title: const Text("did not know"),
                                  leading: Radio(
                                    value: 4,
                                    groupValue: selectedConOption,
                                    onChanged: (value) {
                                      setState(() {
                                        condition = "did not know";
                                        selectedConOption = value as int;
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blue, // background color of button
                              ),
                              child: const Text("Add item"),
                              onPressed: () {
                                const CircularProgressIndicator(
                                    backgroundColor: Colors.white);
                                if (formKey.currentState!.validate()) {
                                  addToCart();
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: items.isNotEmpty
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ExpansionTile(
                        title: Text(
                          items[index].name,
                          textScaleFactor: 1.5,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          'Mrp : ₹ ${items[index].mrp}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textScaleFactor: 1.0,
                        ),
                        trailing: InkWell(
                          child: const Icon(Icons.delete),
                          onTap: () {
                            setState(() {
                              reference
                                  .child('items')
                                  .orderByChild('name')
                                  .equalTo(items[index].name)
                                  .once()
                                  .then((DataSnapshot snapshot) {
                                    Map<dynamic, dynamic>? children =
                                        snapshot.value as Map?;
                                    children!.forEach((key, value) {
                                      reference
                                          .child('items')
                                          .child(key)
                                          .remove();
                                    });
                                  } as FutureOr Function(DatabaseEvent value));
                              items.removeAt(index);
                              setState(() {});
                            });
                          },
                        ),
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "condition: ${items[index].condition}",
                                textScaleFactor: 1.2,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "category: ${items[index].category}",
                                textScaleFactor: 1.2,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.not_interested_rounded,
                    color: Colors.grey,
                  ),
                  Text(
                    "no item added",
                    textScaleFactor: 1.2,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
    );
  }

  addToCart() async {
    final FormState? formState = formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      Items item = Items(name, mrp, condition, category);
      reference.child("items").push().set({
        'name': name,
        'mrp': mrp,
        'condition': condition,
        'category': category
      }).asStream();
      setState(() {
        items.add(item);
      });
    }
  }
}
