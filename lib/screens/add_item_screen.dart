import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/widgets/location_input.dart';
import '../widgets/image_input.dart';
import 'package:path/path.dart' as path;
import 'package:latlong/latlong.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/add-item';

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File _selectedImage;
  LatLng _selectedLocation;

  void _selectImage(File selectedImage) {
    _selectedImage = selectedImage;
  }

  void _selectLocation(LatLng selectedLocation) {
    _selectedLocation = selectedLocation;
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(text),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _saveItem() async {
    if (_nameController.text.isEmpty) {
      _showToast(context, "Item name can not be empty!");
      return;
    }
    if (_selectedImage == null) {
      _showToast(context, "Item photo can not be empty!");
      return;
    }

    try {
      String fileName = path.basename(_selectedImage.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_selectedImage);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = (await taskSnapshot.ref.getDownloadURL()).toString();
      await FirebaseFirestore.instance.collection('items').add({
        'user': FirebaseAuth.instance.currentUser.uid,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'imageUrl': downloadUrl,
        'location_lat': _selectedLocation.latitude,
        'location_lng': _selectedLocation.longitude,
      });

      Navigator.of(context).pop();
    } catch (err) {
      var message = 'An error occured during adding new item';

      _showToast(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add new item'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                    ],
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: "Item Name",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      labelText: "Item Name",
                    ),
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageInput(_selectImage, null),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 16),
                    minLines: 1,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      labelText: "Description",
                    ),
                    controller: _descriptionController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LocationInput(_selectLocation, null),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Item'),
              onPressed: _saveItem,
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                elevation: 10,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
