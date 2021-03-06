import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/widgets/location_input.dart';
import '../widgets/image_input.dart';
import 'package:path/path.dart' as path;
import 'package:latlong/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'add_item_screen.dart';

class EditItemScreen extends StatefulWidget {
  //static const routeName = '/edit-item';

  final item;
  final itemId;

  EditItemScreen({
    Key key,
    @required this.item,
    @required this.itemId,
  }) : super(key: key);

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Image _initImage;
  LatLng _initLocation;
  File _selectedImage;
  LatLng _selectedLocation;

  @override
  void initState() {
    if (widget.item['name'] != null) {
      _nameController.text = widget.item['name'];
    }
    if (widget.item['description'] != null) {
      _descriptionController.text = widget.item['description'];
    }
    if (widget.item['imageUrl'] != null) {
      _initImage = Image.network(
        widget.item['imageUrl'],
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
    if (widget.item['location_lat'] != null &&
        widget.item['location_lng'] != null) {
      _initLocation =
          new LatLng(widget.item['location_lat'], widget.item['location_lng']);
    }
    super.initState();
  }

  void _selectImage(File selectedImage) {
    _selectedImage = selectedImage;
  }

  void _selectLocation(LatLng selectedLocation) {
    _selectedLocation = selectedLocation;
  }

  void _deleteItem() async {
    await FirebaseFirestore.instance
        .collection('items')
        .doc(widget.itemId)
        .delete()
        .then((value) => Navigator.pop(context))
        .then((value) => Navigator.pop(context))
        .then((value) => Navigator.pop(context))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Theme.of(context).errorColor,
              ),
            ));
  }

  _showDeleteAlert(BuildContext context) {
    AlertDialog deleteAlert = AlertDialog(
      title: Text("Are you sure you want to delete this item?"),
      //content: Text("Are you sure you want to delete this item?"),
      actions: [
        ElevatedButton.icon(
          icon: Icon(Icons.delete),
          label: Text("Delete"),
          onPressed: () async {
            _deleteItem();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            elevation: 10,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.cancel),
          label: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return deleteAlert;
      },
    );
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

  void _editItem() async {
    if (_nameController.text.isEmpty) {
      _showToast(context, "Name can not be empty!");
      return;
    }

    String downloadUrl;
    if (_selectedImage != null) {
      String fileName = path.basename(_selectedImage.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_selectedImage);
      TaskSnapshot taskSnapshot = await uploadTask;
      downloadUrl = (await taskSnapshot.ref.getDownloadURL()).toString();
    } else {
      downloadUrl = widget.item['imageUrl'];
    }

    if (_selectedLocation == null) {
      print('xd');
      _selectedLocation = _initLocation;
    }

    try {
      await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.itemId)
          .update({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'imageUrl': downloadUrl,
        'location_lat': _selectedLocation.latitude,
        'location_lng': _selectedLocation.longitude,
      });

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (err) {
      var message = 'An error occured during editing item';
      _showToast(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit ' + widget.item['name'],
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                _showDeleteAlert(context);
              }),
        ],
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
                    controller: _nameController,
                    onChanged: (text) => {},
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Item Name",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      labelText: "Item Name",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageInput(_selectImage, _initImage),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      labelText: "Description",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LocationInput(_selectLocation, _initLocation),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Save Item'),
              onPressed: _editItem,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
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
