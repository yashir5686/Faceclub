import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagrampub/screens/login_signup_screen/login_screen.dart';
import 'package:instagrampub/services/api/auth_service.dart';
import 'package:instagrampub/utilities/themes.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  bool _isLoading = false;
  // ignore: non_constant_identifier_names
  bool EmailSent = false;

  _submit() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      //Logging the user
      try {
        await AuthService.changePassword(
          _email.trim(),
        );
        setState(() {
          EmailSent = true;
        });
      } on PlatformException catch (err) {
        _showErrorDialog(err.message);
        setState(() {
          _isLoading = false;
        });
        throw (err);
      }
    }
  }

  _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EmailSent != true
            ? GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Faceclub',
                          style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'Billabong',
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 10.0),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Email'),
                                  validator: (input) => !input.contains('@')
                                      ? 'Please enter a valid email'
                                      : null,
                                  onSaved: (input) => _email = input,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              if (_isLoading) CircularProgressIndicator(),
                              if (!_isLoading)
                                Container(
                                  width: 250.0,
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                    onPressed: _submit,
                                    color: Colors.blue,
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Get Password Change Email',
                                      style: kFontColorWhiteSize18TextStyle,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ))
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Faceclub',
                          style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'Billabong',
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              child: Center(
                                child: Text(
                                  'Email for changing password is sent to you If You have changed your password then go ahead and login with your account',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              width: 250.0,
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginScreen()));
                                },
                                color: Colors.blue,
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Login Now',
                                  style: kFontColorWhiteSize18TextStyle,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                )));
  }
}
