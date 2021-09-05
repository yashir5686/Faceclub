import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instagrampub/models/feedback_model.dart';
import 'package:instagrampub/services/api/database_service.dart';
import 'package:instagrampub/utilities/custom_navigation.dart';

class ReportProblem extends StatefulWidget {
  final String currentuserid;
  ReportProblem(this.currentuserid);
  @override
  _ReportProblemState createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  // ignore: avoid_init_to_null
  String selectedissue = null;
  String feedbackinput = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  var issues = [
    'Login Issue',
    'Profile Issue',
    'Issue with Posting',
    'Issue with stories',
    'Issue in Donating',
    'Issue with chats',
    'Issue with feed',
    'Suggetion',
  ];

  _submit() {
    FocusScope.of(context).unfocus();

    if (!_isLoading && _formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      // IssueFeedback feedback = IssueFeedback(
      //   issue: selectedissue,
      //   message: feedbackinput.trim(),
      //   userid: widget.currentuserid,
      //   timestamp: DateTime.now(),
      // );
      //DatabaseService.sendfeedback(feedback);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.green),
                  Text('Thanks For Submitting Feedback'),
                ],
              ),
            );
          });

      _goToHomeScreen();
    }
  }

  void _goToHomeScreen() {
    CustomNavigation.navigateToHomeScreen(context, widget.currentuserid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        title: Text(
          "Feedback",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Please select the type of the feedback",
                    style: TextStyle(
                      color: Color(0xFFC5C5C5),
                    ),
                  ),
                  Center(
                    child: DropdownButton(
                      value: selectedissue,
                      hint: Text(
                        'Please Choose Feedback Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      iconSize: 30,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: issues.map((String categories) {
                        return DropdownMenuItem(
                            value: categories, child: Text(categories));
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          selectedissue = newValue;
                        });
                      },
                    ),
                  ),
                  buildFeedbackForm(),
                  !_isLoading
                      ? Center(
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () {
                              feedbackinput != null
                                  ? selectedissue != null
                                      ? _submit()
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: Text(
                                                    'Please Select Issue Type'),
                                              ))
                                  : showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: Text(
                                                    'Please Type Your Issue'),
                                              ));
                            },
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            color: Colors.blue,
                            padding: EdgeInsets.all(16.0),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                              width: 20,
                              height: 20,
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildFeedbackForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        maxLines: 10,
        onSaved: (input) => feedbackinput = input,
        onChanged: (input) => feedbackinput = input,
        decoration: InputDecoration(
          hintText: "Please briefly describe the issue",
          hintStyle: TextStyle(
            fontSize: 13.0,
            color: Color(0xFFC5C5C5),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFE5E5E5),
            ),
          ),
        ),
      ),
    );
  }
}
