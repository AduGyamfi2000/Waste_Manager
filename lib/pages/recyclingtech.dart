import 'package:flutter/material.dart';

class Recycle extends StatefulWidget {
  const Recycle({Key? key}) : super(key: key);

  @override
  RecycleState createState() => RecycleState();
}

class RecycleState extends State<Recycle> {
  int columncount = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            Image.asset(
              "lib/assets/electronic-recycling.jpg",
            ),
            const Center(
                child: Text(
              "What is E-waste?",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              textScaleFactor: 2.0,
            )),
            const Text(
              "E-waste is any electrical or electronic equipment that’s been discarded. This includes working and broken items that are thrown in the garbage or donated to a charity reseller like Goodwill. Often, if the item goes unsold in the store, it will be thrown away. E-waste is particularly dangerous due to toxic chemicals that naturally leach from the metals inside when buried.\n",
              style: TextStyle(),
              textScaleFactor: 1.5,
            ),
            const SizedBox(
              height: 10,
            ),
            Image.asset("lib/assets/ewastePostProductionInfo.jpg"),
            const SizedBox(
              height: 10,
            ),
            const Center(
                child: Text(
              "List of E-waste items",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              textScaleFactor: 2.0,
            )),
            SizedBox(
              child: GridView.count(
                crossAxisCount: 2,
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
                childAspectRatio: 0.6,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Home Appliances-",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.2,
                          ),
                          Text(
                            "Microwaves\nHome Entertainment Devices\nElectric cookers\nHeaters\nFans\n",
                            style: TextStyle(),
                            textScaleFactor: 1.2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.redAccent[100],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Communications and Information Technology Devices-",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.2,
                          ),
                          Text(
                            "Cell phones\nSmartphones\nDesktop Computers\nComputer Monitors\nLaptops\nCircuit boards\nHard Drives\n",
                            style: TextStyle(),
                            textScaleFactor: 1.2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Home Entertainment Devices-",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.2,
                          ),
                          Text(
                            "DVDs\nBlu Ray Players\nStereos\nTelevisions\nVideo Game Systems\nFax machines\nCopiers\nPrinters\n",
                            style: TextStyle(),
                            textScaleFactor: 1.2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Office and Medical Equipment-",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.2,
                          ),
                          Text(
                            "Copiers/Printers\n IT Server Racks\nIT Servers\nCords and Cables\nWiFi Dongles\nDialysis Machines\nImaging Equipment\nPhone & PBX systems\nAudio & Video Equipment\nNetwork Hardware\n",
                            style: TextStyle(),
                            textScaleFactor: 1.2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    )));
  }
}
