import 'package:app/bookuser.dart';
import 'package:app/doctorInfo.dart';
import 'package:app/registrationuser.dart';
import 'package:app/service/notificationService.dart';
import 'package:app/viewmyAppointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Function signOut;
  GoogleSignInAccount user;

  Dashboard(this.user, this.signOut);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isUser = false;
  bool isWorking = true;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _read() async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore
          .collection('docusers')
          .doc(widget.user.email.toString())
          .get();
      print(documentSnapshot.data());
      if (documentSnapshot.data() != null) {
        setState(() {
          isUser = true;
        });
      }
      setState(() {
        isWorking = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _read();
  }

  Widget _buildBody() {
    if (isUser == false) {
      return RegistrationUserPage(widget.user, widget.signOut);
    } else {
      return Container(
        child: Stack(
          children: [
            // Positioned(
            //     top: 0,
            //     bottom: 0,
            //     right: -160,
            //     child: Container(
            //       // constraints: BoxConstraints.expand(),
            //       // decoration: BoxDecoration(
            //       //     image: DecorationImage(
            //       //         image: AssetImage("asset/blurdentist.png"),
            //       //         fit: BoxFit.cover)),

            //       child: Image.asset('asset/blurdentist.png'),
            //     )),

            Positioned(child: Container(color: Colors.white)),

            Positioned(
                top: 430,
                left: -27,
                child: Container(
                  height: 490,
                  width: 452,
                  child: Image.asset("asset/doccheckup.png"),
                )),

            Positioned(
              left: MediaQuery.of(context).size.width - 365,
              top: 70,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.6,
                        color: Color.fromRGBO(68, 133, 238, 1),
                      ),
                    ),
                    margin: EdgeInsets.only(),
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(68, 133, 238, 1),
                      radius: 28,
                      backgroundImage:
                          NetworkImage(widget.user.photoUrl.toString()),
                    ),
                  ),
                  Container(
                    width: 160,
                  ),
                  // Container(
                  //   height: 20,
                  //   width: 20,
                  //   child: Image.asset(
                  //     'asset/logouticon.png',
                  //   ), //icon
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       isWorking = true;
                  //     });
                  //     Navigator.pop(context);
                  //     widget.signOut();
                  //     widget.user.clearAuthCache();
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.all(15),
                  //     //alignment: Alignment.topRight,
                  //     child: Text(
                  //       'Log out',
                  //       style: TextStyle(fontSize: 20),
                  //       textAlign: TextAlign.left,
                  //     ),
                  //   ),
                  // ),

                  Container(
                      width: 180,
                      child: IconButton(
                          onPressed: () {
                            _drawerKey.currentState!.openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            size: 35,
                          ))),
                ],
              ),
            ),

            Positioned(
              left: MediaQuery.of(context).size.width - 365,
              top: 170,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(),
                    child: Text(
                      'Hello, ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 49, 89, 1),
                          fontSize: 27),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(),
                    child: Text(
                      widget.user.displayName.toString() + '!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(254, 112, 98, 1),
                          fontSize: 27),
                    ),
                  ),
                ],
              ),
            ),

            //+ widget.user.displayName.toString() + '!',

            Positioned(
              left: MediaQuery.of(context).size.width - 365,
              top: 220,
              height: 75,
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Text(
                  'Welcome to DocAppoint,' +
                      '\n'
                          'An Appointment-Booking App for Bright Dental' +
                      '\n'
                          'Foundation.',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 68), fontSize: 16),
                ),
              ),
            ),

            Positioned(
                left: MediaQuery.of(context).size.width - 365,
                top: 315,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorInfo()),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          'View Doctors Profile',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(68, 133, 238, 1)),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.arrow_forward_sharp,
                          color: Color.fromRGBO(68, 133, 238, 1),
                        ),
                      ),
                    ],
                  ),
                )),

            Positioned(
              top: 380,
              left: MediaQuery.of(context).size.width - 371,
              child: Container(
                width: 345,
                height: 60,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookUserpage(widget.user)),
                    );
                  },
                  child: Card(
                    //elevation: 30,
                    shape: RoundedRectangleBorder(
                        //side: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Book Appoinment',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    color: Color.fromRGBO(68, 133, 238, 1),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 440,
              left: MediaQuery.of(context).size.width - 371,
              child: Container(
                width: 345,
                height: 59,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewmyAppointment(widget.user)),
                    );
                  },
                  child: Card(
                    //elevation: 30,
                    shape: RoundedRectangleBorder(
                        //side: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'View Appoinment',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    color: Color.fromRGBO(254, 112, 98, 1),
                  ),
                ),
              ),
            ),

            // Positioned(
            //   left: MediaQuery.of(context).size.width - 150,
            //   top: 50,
            //   child: Container(
            //       width: 180,
            //       child: IconButton(
            //           onPressed: () {
            //             _drawerKey.currentState!.openDrawer();
            //           },
            //           icon: Icon(
            //             Icons.menu,
            //             size: 35,
            //           ))),
            // ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      // ),
      key: _drawerKey,
      backgroundColor: isWorking ? Colors.white : Colors.white,
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 100,
            ),
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(widget.user.photoUrl.toString()),
            ),
            Container(
              height: 20,
            ),
            Text(
              widget.user.displayName.toString(),
              style: TextStyle(fontSize: 18),
            ),
            Container(
              height: 20,
            ),
            Text(
              widget.user.email,
              style: TextStyle(fontSize: 18),
            ),
            Container(
              height: 30,
            ),
            Divider(),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12),
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'asset/calendaricon.png',
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Book Appoitnment',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12),
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'asset/timeicon.png',
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'View Appoitnment',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorInfo()),
                );
              },
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 25,
                      width: 25,
                      child: Icon(Icons.person)),
                  Container(
                    margin: EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Doctor Info',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                setState(() {
                  isWorking = true;
                });
                Navigator.pop(context);
                widget.signOut();
                widget.user.clearAuthCache();
              },
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 12),
                    height: 25,
                    width: 25,
                    child: Image.asset(
                      'asset/logouticon.png',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Log out',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
      body: Center(
        child: isWorking ? CircularProgressIndicator() : _buildBody(),
      ),
    );
  }
}
