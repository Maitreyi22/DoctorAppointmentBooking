import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ViewmyAppointment extends StatefulWidget {
  GoogleSignInAccount user;

  ViewmyAppointment(this.user);

  @override
  _ViewmyAppointmentState createState() => _ViewmyAppointmentState();
}

class _ViewmyAppointmentState extends State<ViewmyAppointment> {
  Map daySheduleMap = {};
  List<Map> list = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Timestamp dayOfAppointment = Timestamp.fromMillisecondsSinceEpoch(34567890);
  String appointmentTime = '';
  Timestamp bookingTime = Timestamp.fromMillisecondsSinceEpoch(34567890);
  String bookingId = '', problem = '';
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readMyAppointment();
  }

  void readMyAppointment() async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore
          .collection('docusers')
          .doc(widget.user.email.toString())
          .get();
      print((documentSnapshot.data() as dynamic)['booking']);
      setState(() {
        bookingId = (documentSnapshot.data() as dynamic)['booking'];
      });
      documentSnapshot =
          await firestore.collection('doctorAppointments').doc(bookingId).get();

      setState(() {
        problem = (documentSnapshot.data() as dynamic)['diseases'];
        dayOfAppointment =
            (documentSnapshot.data() as dynamic)['appointmentDay'];
        appointmentTime =
            (documentSnapshot.data() as dynamic)['appointmentTime'];
        bookingTime = (documentSnapshot.data() as dynamic)['bookingTime'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 3, left: 17),
                    alignment: Alignment.topLeft,
                    height: 30,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, size: 29)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 17, left: 62),
                    child: Text(
                      'Your Appointment',
                      style: TextStyle(
                        fontSize: 18,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //   Container(
            //     margin: EdgeInsets.only(top: 18, left: 0, right: 18),
            //     child: Text('Hello ' + widget.user.displayName.toString() + '!',
            //         style: TextStyle(fontSize: 22)),
            //   ),
            //   Container(
            //     height: 20,
            //   ),

            // Container(
            //   height: 30,
            // ),

            // CircleAvatar(
            //   radius: 60,
            //   backgroundImage: NetworkImage(widget.user.photoUrl.toString()),
            // ),

            // Container(
            //   height: 30,
            // ),
            // Container(
            //   margin: EdgeInsets.only(right: 30),
            //   child: Text(
            //       'Patient Name  :  ' + widget.user.displayName.toString(),
            //       style: TextStyle(fontSize: 22)),
            // ),

            // Container(
            //   height: 50,
            // ),

            // Container(
            //   margin: EdgeInsets.only(right: 30),
            //   child: Text(
            //     'Your appointment is scheduled on ',
            //     style: TextStyle(fontSize: 22),
            //   ),
            // ),

            Container(
              margin: EdgeInsets.only(top: 15),
              height: 300,
              child: Image.asset("asset/toothclean.png"),
            ),

            Container(
              height: 13,
            ),

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 18),
              height: 30,
              child: Text(
                "Dr Abhijeet Deshpande",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              height: 13,
            ),

            Row(
              children: [
                Container(
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.location_pin, size: 20))),
                Container(
                  child: Text(
                    'Sentosa Paradise, Choudhary Park, Landmark:' '\n' +
                        'Near Petrol Pump, Pune-411057',
                    style: TextStyle(fontSize: 15),
                  ),
                  //'\n' 'Pune-411057'
                ),
              ],
            ),

            Container(
              height: 20,
            ),

            Row(
              children: [
                Container(
                  // child: ListTile(
                  //   leading: Text(
                  //     'Day : ',
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  //   title: Text(
                  //     timestampToDate(dayOfAppointment).day.toString() +
                  //         "  " +
                  //         months[timestampToDate(dayOfAppointment).month - 1]
                  //             .toString() +
                  //         "  " +
                  //         timestampToDate(dayOfAppointment).year.toString(),
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  // ),
                  margin: EdgeInsets.only(left: 18),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    //color: Color.fromRGBO(254, 112, 98, 1),
                    color: Color.fromRGBO(255, 234, 231, 1),

                    //elevation: 10,
                    child: Container(
                      height: 40,
                      width: 157,
                      padding: EdgeInsets.all(3),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 25,
                            child: Image.asset(
                              'asset/calendaricon.png',
                              color: Color.fromRGBO(254, 112, 98, 1),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            timestampToDate(dayOfAppointment).day.toString() +
                                " " +
                                months[timestampToDate(dayOfAppointment).month -
                                        1]
                                    .toString() +
                                " " +
                                timestampToDate(dayOfAppointment)
                                    .year
                                    .toString(),
                            style: TextStyle(
                                color: Color.fromRGBO(254, 112, 98, 1),
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 30,
                ),
                Container(
                  // child: ListTile(
                  //   leading: Text(
                  //     'Time : ',
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  //   title: Text(
                  //     appointmentTime,
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  // ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    //color: Color.fromRGBO(254, 112, 98, 1),
                    color: Color.fromRGBO(255, 234, 231, 1),

                    //elevation: 10,
                    child: Container(
                      height: 40,
                      width: 140,
                      //padding: EdgeInsets.all(3),
                      margin: EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 25,
                            child: Image.asset(
                              'asset/timeicon.png',
                              color: Color.fromRGBO(254, 112, 98, 1),
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            " " + appointmentTime,
                            style: TextStyle(
                                color: Color.fromRGBO(254, 112, 98, 1),
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              height: 30,
            ),

            Container(
              // child: ListTile(
              //   leading: Text(
              //     'Existing Symptoms : ',
              //     style: TextStyle(fontSize: 20),
              //   ),
              //   title: Text(
              //     problem,
              //     style: TextStyle(fontSize: 20),
              //   ),
              // ),
              margin: EdgeInsets.only(right: 210),
              child: Text(
                'Existing Symptoms',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(115, 115, 115, 1)),
              ),
            ),
            Container(
              height: 10,
            ),

            Container(
              height: 47,
              width: 130,
              margin: EdgeInsets.only(right: 224),
              child: Card(
                  //elevation: 5,

                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color.fromRGBO(68, 133, 238, 1),
                      ),
                      borderRadius: BorderRadius.circular(30)),
                  color: Color.fromRGBO(238, 243, 254, 1),
                  child: Center(
                      child: Text(
                    problem,
                    style: TextStyle(
                        fontSize: 10,
                        color: Color.fromRGBO(68, 133, 238, 1),
                        fontWeight: FontWeight.bold),
                  ))),
            ),
          ]),
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   print(dayOfAppointment);
      // }),
    );
  }

  DateTime timestampToDate(Timestamp t) {
    return DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
  }
}
