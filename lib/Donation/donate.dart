// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:instagram/utilities/themes.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// ignore: camel_case_types
// class DonateScreen extends StatefulWidget {
//   @override
//   _DonateScreenState createState() => _DonateScreenState();
// }

// ignore: camel_case_types
// class _DonateScreenState extends State<DonateScreen> {
//   Razorpay _razorpay;
//   String email;
//   String amount;
//   int _amount;

//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }

//   void openCheckout() async {
//     var option = {
//       "key":
//           'rzp_live_rXj7Em2UMeg0mR', //"rzp_live_rXj7Em2UMeg0mR", //'rzp_test_rkbMfLcwVZtwyk',
//       'amount': _amount,
//       'name': 'Donate To Faceclub',
//       'image':
//           'https://firebasestorage.googleapis.com/v0/b/faceclub-official.appspot.com/o/faceclub_logo.png?alt=media&token=05561bd8-4bd9-4506-960d-a86ecc949cd6',
//       'external': {
//         'wallet': [
//           'paytm',
//           'phonepe',
//           'paypal',
//           'amazonpay',
//         ]
//       }
//     };
//     try {
//       _razorpay.open(option);
//     } catch (e) {
//       debugPrint(e);
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//               title: Text('Thanks For Your Support'),
//               content: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   children: [
//                     Text('Please Enjoy The App'),
//                     Text('Give Suggetions in Send Feedback Screen'),
//                   ],
//                 ),
//               ),
//             ));
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//               title: Text('Payment Failed'),
//               content: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   children: [
//                     Text('Please Try Again'),
//                     Text('Or Try Reporting this issue in Send Feedback'),
//                     Text(
//                         'Error: ${response.code.toString()}-${response.message}')
//                   ],
//                 ),
//               ),
//             ));
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     SnackBar(content: Text('External Wallet: ${response.walletName}'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Donate',
//           style: kFontSize18FontWeight600TextStyle,
//         ),
//         actions: <Widget>[
//           Row(
//             children: [
//               Text(
//                 'Thanks You',
//                 style: kFontSize18FontWeight600TextStyle,
//               ),
//               SizedBox(
//                 width: 1,
//               ),
//               IconButton(
//                 icon: Icon(
//                   CupertinoIcons.heart_circle,
//                 ),
//                 onPressed: () {},
//               ),
//               SizedBox(
//                 width: 15,
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: ListView(
//           children: [
//             Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 30.0, vertical: 10.0),
//                   child: TextField(
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.allow(RegExp("[0-9]")),
//                       ],
//                       decoration:
//                           InputDecoration(labelText: 'Amount in rupees'),
//                       onChanged: (input) =>
//                           _amount = int.parse(input.trim().toString()) * 100),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Center(
//                   child: Container(
//                     width: 110,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         openCheckout();
//                       },
//                       child: Row(
//                         children: [
//                           Text('Donate', style: TextStyle(color: Colors.white)),
//                           Icon(
//                             CupertinoIcons.heart_circle,
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
