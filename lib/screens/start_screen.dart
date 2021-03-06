import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garbage_collector/screens/my_items_screen.dart';
import 'package:garbage_collector/screens/search_screen.dart';
import 'package:garbage_collector/screens/profile_screen.dart';
import 'package:garbage_collector/screens/starred_items_screen.dart';

class StartScreen extends StatelessWidget {
  static const routeName = '/start-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
            child: Column(children: [
          Flexible(
            child: FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 1,
              child: GestureDetector(
                onTap: () async {
                  var currentUser = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .snapshots()
                      .first;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        user: currentUser.data(),
                        userId: FirebaseAuth.instance.currentUser.uid,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Colors.white),
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.face_outlined,
                        size: MediaQuery.of(context).size.width * 0.15,
                        color: Colors.white,
                      ),
                      Text(
                        '  My Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(MyItemsScreen.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Colors.white),
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.model_training,
                        size: MediaQuery.of(context).size.width * 0.15,
                        color: Colors.white,
                      ),
                      Text(
                        '  My Items  ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(SearchScreen.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Colors.white),
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        size: MediaQuery.of(context).size.width * 0.15,
                        color: Colors.white,
                      ),
                      Text(
                        '  Find Item  ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(StarredItemsScreen.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Colors.white),
                      color: Colors.yellow[800],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.star_rounded,
                        size: MediaQuery.of(context).size.width * 0.15,
                        color: Colors.white,
                      ),
                      Text(
                        '  Starred     ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 1,
              child: GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Colors.white),
                      color: Colors.black87,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.logout,
                        size: MediaQuery.of(context).size.width * 0.15,
                        color: Colors.white,
                      ),
                      Text(
                        '  Log out  ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ])));
  }
}
