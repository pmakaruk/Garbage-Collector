import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'edit_item_screen.dart';

class ItemDetailScreen extends StatelessWidget {
  final item;

  ItemDetailScreen({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          item['name'],
          textAlign: TextAlign.center,
        ),
        actions: FirebaseAuth.instance.currentUser.uid == item['user']
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditItemScreen(
                          item: item,
                        ),
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 500,
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.white),
                    ),
                    child: item['imageUrl'] != null
                        ? Image.network(
                            item['imageUrl'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Text(
                            'No image selected',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                    alignment: Alignment.center,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone_android_outlined,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "123456",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ]),
                        ),
                        Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.mail_outline,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "12@34.56",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: ({String xd = "50", xdd = "20"}) async {
                  //     var mapSchema = 'geo:$xd,$xdd';
                  //     if (await canLaunch(mapSchema)) {
                  //       await launch(mapSchema);
                  //     } else {
                  //       throw 'Could not launch $mapSchema';
                  //     }
                  //   },
                  //   child:
                  Container(
                    height: 200,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.white),
                    ),
                    child: item['location.lng'] != null
                        ? FlutterMap(
                            options: new MapOptions(
                              center: new LatLng(
                                  item['location.lat'], item['location.lng']),
                              zoom: 13.0,
                              maxZoom: 18,
                              minZoom: 4,
                              interactive: false,
                            ),
                            layers: [
                              new TileLayerOptions(
                                  urlTemplate:
                                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c']),
                              new MarkerLayerOptions(
                                markers: [
                                  new Marker(
                                    width: 40.0,
                                    height: 40.0,
                                    point: new LatLng(item['location.lat'],
                                        item['location.lng']),
                                    builder: (ctx) => new Container(
                                      child: Icon(
                                        Icons.room,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Text(
                            'No location selected',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}