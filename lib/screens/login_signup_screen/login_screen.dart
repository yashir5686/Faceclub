import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagrampub/screens/login_signup_screen/change_password.dart';
import 'package:instagrampub/screens/screens.dart';
import 'package:instagrampub/services/services.dart';
import 'package:instagrampub/utilities/themes.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _isLoading = false;
  bool _obscurepass = true;

  @override
  void initState() {
    super.initState();
    _obscurepass = false;
  }

  _submit() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      //Logging the user
      try {
        await AuthService.loginUser(_email.trim(), _password.trim());
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
              TextButton(
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
      body: GestureDetector(
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
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (input) => !input.contains('@')
                              ? 'Please enter a valid email'
                              : null,
                          onSaved: (input) => _email = input,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _obscurepass
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _obscurepass = !_obscurepass;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurepass,
                          validator: (input) => input.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                          onSaved: (input) => _password = input,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ChangePassword()
                              )
                            );
                        },
                        child: Text('Forgot Password?'),
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
                              'Login',
                              style: kFontColorWhiteSize18TextStyle,
                            ),
                          ),
                        ),
                      SizedBox(height: 20.0),
                      if (!_isLoading)
                        Container(
                          width: 250.0,
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, SignupScreen.id),
                            color: Colors.blue,
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'New? Signup',
                              style: kFontColorWhiteSize18TextStyle,
                            ),
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
