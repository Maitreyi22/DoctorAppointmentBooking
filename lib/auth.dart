import 'package:app/dashboard.dart';
import 'package:app/doctorview.dart';
import 'package:connectivity/connectivity.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class Auth extends StatefulWidget {
  @override
  State createState() => AuthState();
}

class AuthState extends State<Auth> {
  GoogleSignInAccount? _currentUser;
  bool isWorking = true, isconnected = true;

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('mobile internet');
      setState(() {
        isconnected = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('wifi internet');
      setState(() {
        isconnected = true;
      });
    } else {
      print('no internet');
      setState(() {
        isconnected = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });

      setState(() {
        isWorking = false;
      });
    });
    checkInternet();
    _googleSignIn.signInSilently();
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'];
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  void signOut() {
    _handleSignOut();
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      if (user.email != "maitreyi.kalantre@maharshikarvebcapune.org") {
        return Dashboard(user, signOut);
      } else {
        return DoctorView(user, signOut);
      }
    } else {
      return SafeArea(
          child: Stack(
        children: [
          // Positioned(
          //   child: Column(
          //     children: <Widget>[
          //       Expanded(
          //         child: Container(
          //           color: Color.fromRGBO(188, 227, 243, 1),
          //         ),
          //       ),
          //       Expanded(
          //         child: Container(color: Color.fromRGBO(160, 214, 237, 1)),
          //       )
          //     ],
          //   ),
          // ),
          Positioned(
            child: Container(
              color: Colors.white,
            ),
          ),
          Positioned(
              child: Container(
            height: 100,
            width: 110,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(left: 139, top: 32),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   border: Border.all(
            //     color: Color.fromRGBO(68, 133, 238, 1),
            //     width: 2.3,
            //   ),
            // ),
            child: Image.asset(
              'asset/applogo.png',
            ),
          )),

          Positioned(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 140, top: 110),
                  child: Text(
                    'Doc',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(68, 133, 238, 1),
                        fontSize: 20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 110),
                  child: Text(
                    'Appoint',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(254, 112, 98, 1),
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              child: Container(
            margin: EdgeInsets.only(left: 134, top: 136),
            child: Text(
              '"' + 'Its time to Smile Again!' + '"',
              style: TextStyle(
                color: Color.fromRGBO(115, 115, 115, 1),
                //color: Color.fromRGBO(68, 133, 238, 1),
                //color: Color.fromRGBO(254, 112, 98, 1),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),

          Positioned(
              top: 189,
              left: 30,
              child: Text(
                'Welcome!',
                style: TextStyle(
                    color: Color.fromRGBO(68, 133, 238, 1),
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              )),
          Positioned(
              top: 230,
              left: 30,
              child: Text(
                'Please login for an Appointment',
                style: TextStyle(
                  color: Color.fromRGBO(74, 64, 64, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Positioned(
              top: 240,
              child: Container(
                height: 410,
                child: Image.asset('asset/frontdoc.png'),
              )),
          Positioned(
              top: 650,
              width: 227,
              left: 78,
              height: 63,
              child: Center(
                widthFactor: 2.2,
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 100),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isWorking = true;
                      });
                      _handleSignIn();
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Color.fromRGBO(68, 133, 238, 1),
                      //elevation: 10,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              //height: 40,
                              child: Image.asset(
                                'asset/googleicon.png',
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Login from Google',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: isconnected
          ? _buildBody()
          : Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.signal_wifi_connected_no_internet_4,
                    //   size: 50,
                    // ),
                    //Text('please Connect Internet'),
                    Container(
                      margin: EdgeInsets.only(left: 75),
                      width: 410,
                      child: Image.asset('asset/404page.png'),
                    ),
                    Container(
                      child: Text(
                        "Ooops!",
                        style: TextStyle(
                            fontSize: 24,
                            color: Color.fromRGBO(68, 133, 238, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    Container(
                        height: 40,
                        child: Text(
                          'Looks like you have lost Internet Connection!',
                          style: TextStyle(
                            color: Color.fromRGBO(115, 115, 115, 1),
                            fontSize: 14,
                          ),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          checkInternet();
                        },
                        child: Text('Retry!'))
                  ],
                ),
              ),
            ),
    ));
  }
}
