import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagrampub/main.dart';
import 'package:instagrampub/services/services.dart';
import 'package:instagrampub/utilities/themes.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _name;
  bool _isLoading = false;
  bool doesnameexist;
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
      //Signup user with Firebase
      try {
        await AuthService.signUpUser(
            context, _name.trim(), _email.trim(), _password.trim());
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => MyApp(IsfromotherPage: false,)));
          setState(() {
            _isLoading = false;
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
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(
                                "[0-9a-z.@अ-ज्ञट-नप-भय-वसहझश_ािीुूोौैत्रक्षश्रम]")),
                          ],
                          decoration: InputDecoration(labelText: 'Username'),
                          validator: (input) => input.trim().isEmpty
                              ? 'Please enter a valid Username'
                              : null,
                          onSaved: (input) => _name = input,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
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
                              'Signup',
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
                            onPressed: () => Navigator.pop(context),
                            color: Colors.blue,
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Have Account? Login',
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
