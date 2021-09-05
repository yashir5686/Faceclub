import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagrampub/models/models.dart';
import 'package:instagrampub/screens/screens.dart';
import 'package:instagrampub/utilities/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? false;

    //Set Navigation bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: darkModeOn ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            darkModeOn ? Brightness.light : Brightness.dark));

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserData>(create: (context) => UserData()),
          ChangeNotifierProvider<ThemeNotifier>(
              create: (context) =>
                  ThemeNotifier(darkModeOn ? darkTheme : lightTheme))
        ],
        child: MyApp(IsfromotherPage: false),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final bool IsfromotherPage;
  // ignore: non_constant_identifier_names
  MyApp({@required this.IsfromotherPage});
  @override
  _MyAppState createState() => _MyAppState(this.IsfromotherPage);
}

class _MyAppState extends State<MyApp> {
  bool _isTimerDone = false;
  // ignore: non_constant_identifier_names
  bool IsfromotherPage;
  _MyAppState(this.IsfromotherPage);
  String postId;
  String userId;
  String currentUserId;
  String profileId;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () => setState(() => _isTimerDone = true));
    super.initState();
  }

  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (IsfromotherPage = true && snapshot.hasData) {
          Provider.of<UserData>(context, listen: false).currentUserId =
              snapshot.data.uid;
          return HomeScreen(
            currentUserId: snapshot.data.uid,
          );
        } else {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !_isTimerDone) {
            return SplashScreen();
          }
          if (snapshot.hasData && _isTimerDone) {
            Provider.of<UserData>(context, listen: false).currentUserId =
                snapshot.data.uid;
            return HomeScreen(
              currentUserId: snapshot.data.uid,
            );
          } else {
            return LoginScreen();
          }
        }
        // if (snapshot.connectionState == ConnectionState.waiting ||
        //     !_isTimerDone) {
        //   return SplashScreen();
        // }
        // if (snapshot.hasData && _isTimerDone) {
        //   Provider.of<UserData>(context, listen: false).currentUserId =
        //       snapshot.data.uid;
        //   return HomeScreen(
        //     currentUserId: snapshot.data.uid,
        //   );
        // } else {
        //   return LoginScreen();
        // }
      },
    );
  }

  // PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  //   return MaterialPageRoute(
  //       settings: RouteSettings(
  //         name: routeName,
  //       ),
  //       builder: (_) => viewToShow);
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'faceclub',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: _getScreenId(),
      // onGenerateRoute: (settings) {
      //   switch (settings.name) {
      //     case '/post':
      //       final args =
      //           ModalRoute.of(context).settings.arguments as ScreenArguments;
      //       postId = args.postId;
      //       currentUserId = args.currentUserId;
      //       return _getPageRoute(
      //           routeName: '/post',
      //           viewToShow: PostPage(postId, currentUserId));

      //     case '/profile':
      //       final argument =
      //           ModalRoute.of(context).settings.arguments as ProfileArguments;
      //       profileId = argument.profileId;
      //       currentUserId = argument.currentUserId;
      //       return _getPageRoute(
      //           routeName: '/profile',
      //           viewToShow: Center(child: Text('${profileId} & ${currentUserId}'))
      //           // ProfileScreen(
      //           //     userId: profileId,
      //           //     currentUserId: Provider.of<UserData>(context, listen: false)
      //           //         .currentUserId,
      //           //     goToCameraScreen: () =>
      //           //         CustomNavigation.navigateToHomeScreen(
      //           //             context,
      //           //             Provider.of<UserData>(context, listen: false)
      //           //                 .currentUserId,
      //           //             initialPage: 0),
      //           //     isCameFromBottomNavigation: false)
      //               );

      //     // case 'feed_screen':
      //     //   return _getPageRoute(
      //     //       routeName: FeedScreen.id, viewToShow: FeedScreen());

      //     // case 'login_screen':
      //     //   return _getPageRoute(
      //     //       routeName: LoginScreen.id, viewToShow: LoginScreen());

      //     // case 'signup_screen':
      //     //   return _getPageRoute(
      //     //       routeName: SignupScreen.id, viewToShow: SignupScreen());
      //     default:
      //       return MaterialPageRoute(
      //           builder: (_) => Scaffold(
      //                 body: Center(
      //                     child: Text('No route defined for ${settings.name}')),
      //               ));
      //   }
      // },
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        FeedScreen.id: (context) => FeedScreen(),
        // '/post': (context) => PostPage(postId, currentUserId),
        // '/profile': (context) => Center(child: Text('${profileId} & ${currentUserId}')),
        // ProfileScreen(
        //             userId: profileId,
        //             currentUserId: Provider.of<UserData>(context, listen: false)
        //                 .currentUserId,
        //             goToCameraScreen: () =>
        //                 CustomNavigation.navigateToHomeScreen(
        //                     context,
        //                     Provider.of<UserData>(context, listen: false)
        //                         .currentUserId,
        //                     initialPage: 0),
        //             isCameFromBottomNavigation: false),
      },
    );
  }
}

// class ScreenArguments {
//   final String postId;
//   final String currentUserId;
//   ScreenArguments(this.postId, this.currentUserId);
// }

// class ProfileArguments {
//   final String profileId;
//   final String currentUserId;
//   ProfileArguments(this.profileId, this.currentUserId);
// }
