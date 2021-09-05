import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/services/api/sqldatabase.dart';
import 'package:instagrampub/services/core/url_validator_service.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:instagrampub/utilities/themes.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  final Function updateUser;
  final Function onProfileEdited;
  final Function goToCameraScreen;

  EditProfileScreen({this.user, this.updateUser, this.onProfileEdited, this.goToCameraScreen});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _displayname = '';
  String _bio = '';
  String _website = '';
  File _profileImage;
  final picker = ImagePicker();
  bool _isLoading = false;
  RegExp regExp;
  bool doesnameexist;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _displayname = widget.user.displayname;
    _bio = widget.user.bio;
    _website = widget.user.website;
  }

  _handleImageFromGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() => _isLoading = true);
      String url;

      if (_website.trim() != '') {
        url = await UrlValidatorService.isUrlValid(context, _website.trim());
        if (url == null) {
          setState(() => _isLoading = false);
          return;
        }
      }

      //Update user in database
      String _profileImageUrl = '';

      // if (_profileImage == null) {
      //   _profileImageUrl = widget.user.profileImageUrl;
      // } else {
      //   _profileImageUrl = await StroageService.uploadUserProfileImage(
      //     widget.user.profileImageUrl,
      //     _profileImage,
      //   );
      // }

      User user = User(
          id: widget.user.id,
          name: _name.trim(),
          displayname: _displayname.trim(),
          bio: _bio.trim(),
          role: widget.user.role,
          isVerified: widget.user.isVerified,
          website: url);

      // if (widget.user.name != _name) {
      //   doesnameexist = await DatabaseService.checkUsername(_name);
      //   if (doesnameexist != false) {
      //     final err = Text('Username Already taken');
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(title: err);
      //         });
      //     setState(() {
      //       _isLoading = false;
      //     });
      //     throw (err);
      //   } else {
      //     DatabaseService.updateUser(user);
      //     SQLDatabase.updateUser(user, _profileImage, widget.user.profileImageUrl);
      //     widget.updateUser(user);
      //     DatabaseService.changeUsername(_name, widget.user.name);
      //   }
      // } else {
        //DatabaseService.updateUser(user);
      //_profileImage, widget.user.profileImageUrl
      //_profileImageUrl =
      await SQLDatabase.updateUser(user, _profileImage, widget.user.profileImageUrl);
      Navigator.pop(context);
    }
  }

  _displayProfileImage() {
    // No new profile image
    if (_profileImage == null) {
      // No existing profile image
      if (widget.user.profileImageUrl.isEmpty) {
        //display placeholder
        return AssetImage(placeHolderImageRef);
      } else {
        //user profile image exist
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      //new profile image
      return FileImage(_profileImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        title: Text(
          'Edit Profile',
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: _displayProfileImage(),
                    ),
                    TextButton(
                      onPressed: _handleImageFromGallery,
                      child: Text(
                        'Change Profile Image',
                        style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      ),
                    ),
                    TextFormField(
                      initialValue: _displayname,
                      maxLength: 20,
                      textCapitalization: TextCapitalization.words,
                      style: kFontSize18TextStyle,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            size: 30.0,
                          ),
                          labelText: 'Display Name'),
                      onSaved: (input) => _displayname = input,
                    ),
                    TextFormField(
                      initialValue: _name,
                      maxLength: 20,
                      textCapitalization: TextCapitalization.words,
                      style: kFontSize18TextStyle,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(
                            "[0-9a-z.@अ-ज्ञट-नप-भय-वसहझश_ािीुूोौैत्रक्षश्रम]")),
                      ],
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            size: 30.0,
                          ),
                          labelText: 'Username'),
                      validator: (input) => input.trim().length < 1
                          ? 'Please enter a valid Username'
                          : input.trim().length > 20
                              ? 'Please enter name less than 20 characters'
                              : null,
                      onSaved: (input) => _name = input,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      maxLines: 4,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      style: kFontSize18TextStyle,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.book,
                            size: 30.0,
                          ),
                          labelText: 'Bio'),
                      validator: (input) => input.trim().length > 150
                          ? 'Please enter a bio less than 150 characters'
                          : null,
                      onSaved: (input) => _bio = input,
                    ),
                    TextFormField(
                      initialValue: _website,
                      style: kFontSize18TextStyle,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.important_devices,
                            size: 30.0,
                          ),
                          labelText: 'Website'),
                      onSaved: (input) => _website = input,
                    ),
                    Container(
                      margin: const EdgeInsets.all(40.0),
                      height: 40.0,
                      width: 250.0,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: _submit,
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text(
                          'Save Profile',
                          style: kFontSize18TextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
