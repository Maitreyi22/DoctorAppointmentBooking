import 'package:app/userinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'appointment.dart';

class DoctorView extends StatefulWidget {
  Function signOut;
  GoogleSignInAccount user;

  DoctorView(this.user, this.signOut);

  @override
  _DoctorViewState createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  DateTime _selectedValue = DateTime.now();
  String selectedBatch = '';
  Set<String> diseasesList = new Set();
  List<Appointment> appointmentList = [];
  TextEditingController diseaseController = TextEditingController();
  Map dayScheduleMap = {};
  Timestamp dayOfAppointment = Timestamp.fromMillisecondsSinceEpoch(34567890);
  String appointmentTime = '';
  String nameid = " ";
  Timestamp bookingTime = Timestamp.fromMillisecondsSinceEpoch(34567890);
  String bookingId = '', problem = '';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      diseaseController.text = diseasesList
          .toString()
          .substring(1, diseasesList.toString().length - 1);
    });
    //  _read();
    readTodayScheduleMap();
  }

  void readAppointment(String docref) async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot =
          await firestore.collection('doctorAppointments').doc(docref).get();

      setState(() {
        nameid = (documentSnapshot.data() as dynamic)['user'];
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

  String getCleanDateString(DateTime dt) {
    print(DateTime(dt.year, dt.month, dt.day).toString());
    return DateTime(dt.year, dt.month, dt.day).toString();
  }

  void readTodayScheduleMap() async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore
          .collection('docperdaybookings')
          .doc(getCleanDateString(_selectedValue))
          .get();

      if (documentSnapshot.data() != null) {
        setState(() {
          dayScheduleMap =
              (documentSnapshot.data() as dynamic)['todaySchedule'];
        });
      } else {
        setState(() {
          dayScheduleMap = {};
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.6,
                        color: Color.fromRGBO(68, 133, 238, 1),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 0),
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(68, 133, 238, 1),
                      radius: 27,
                      backgroundImage:
                          NetworkImage(widget.user.photoUrl.toString()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0, left: 240),
                    height: 50,
                    child: IconButton(
                        onPressed: () {
                          widget.signOut();
                        },
                        icon: Icon(Icons.logout, size: 27)),
                  ),
                ],
              ),
            ),
            Container(
              child:
                  Text('Hello Dr ' + widget.user.displayName.toString() + '!',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(74, 64, 64, 1),
                      )),
            ),

            // ListTile(
            //   trailing: IconButton(
            //       onPressed: () {
            //         widget.signOut();
            //       },
            //       icon: Icon(Icons.logout)),
            // ),

            Container(
              height: 20,
            ),
            Container(
              height: 85,
              margin: EdgeInsets.only(left: 10),
              // color: Color.fromRGBO(160, 214, 237, 1),
              //color: Color.fromRGBO(0, 179, 154, 1),
              child: DatePicker(
                DateTime.now(),
                initialSelectedDate: DateTime.now(),
                //selectionColor: Color.fromRGBO(0, 49, 89, 1),
                selectionColor: Color.fromRGBO(254, 112, 98, 1),
                selectedTextColor: Colors.white,
                daysCount: 14 - DateTime.now().weekday,
                onDateChange: (date) {
                  // New date selected
                  setState(() {
                    _selectedValue = date;
                  });
                  readTodayScheduleMap();
                },
              ),
            ),
            Divider(),
            Container(
                margin: EdgeInsets.all(18),
                child: Wrap(
                  children: <Widget>[
                    Container(
                      child: Text('Time Slots',
                          style: TextStyle(
                              fontSize: 15,
                              //color: Color.fromRGBO(0, 179, 154, 1),
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      height: 5,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            if (dayScheduleMap.containsKey('10:00am')) {
                              setState(() {
                                selectedBatch = '10:00am';
                              });
                              readAppointment(
                                  dayScheduleMap['10:00am'].toString());
                              print(dayScheduleMap['10:00am']);
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '10:00am'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('10:00am')
                                    ? 'Booked'
                                    : '10:00am',
                                style: TextStyle(
                                  color: selectedBatch == '10:00am'
                                      ? Colors.white
                                      : Colors.black54,
                                  //fontWeight: FontWeight.bold
                                ),
                              ))),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            if (dayScheduleMap.containsKey('10:30am')) {
                              setState(() {
                                selectedBatch = '10:30am';
                              });
                              readAppointment(
                                  dayScheduleMap['10:30am'].toString());
                              print(dayScheduleMap['10:30am']);
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '10:30am'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('10:30am')
                                    ? 'Booked'
                                    : '10:30am',
                                style: TextStyle(
                                  color: selectedBatch == '10:30am'
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ))),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            if (dayScheduleMap.containsKey('11:00am')) {
                              setState(() {
                                selectedBatch = '11:00am';
                              });
                              readAppointment(
                                  dayScheduleMap['11:00am'].toString());
                              print(dayScheduleMap['11:00am']);
                            }
                          },
                          child: Card(
                              //  elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '11:00am'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('11:00am')
                                    ? 'Booked'
                                    : '11:00am',
                                style: TextStyle(
                                    color: selectedBatch == '11:00am'
                                        ? Colors.white
                                        : Colors.black54),
                              ))),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            if (dayScheduleMap.containsKey('11:30am')) {
                              setState(() {
                                selectedBatch = '11:30am';
                              });
                              readAppointment(
                                  dayScheduleMap['11:30am'].toString());
                              print(dayScheduleMap['11:30am']);
                            }
                          },
                          child: Card(
                              //  elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '11:30am'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('11:30am')
                                    ? 'Booked'
                                    : '11:30am',
                                style: TextStyle(
                                  color: selectedBatch == '11:30am'
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ))),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            if (dayScheduleMap.containsKey('12:00pm')) {
                              setState(() {
                                selectedBatch = '12:00pm';
                              });
                              readAppointment(
                                  dayScheduleMap['12:00pm'].toString());
                              print(dayScheduleMap['12:00pm']);
                            }
                          },
                          child: Card(
                              // elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '12:00pm'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('12:00pm')
                                    ? 'Booked'
                                    : '12:00pm',
                                style: TextStyle(
                                  color: selectedBatch == '12:00pm'
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ))),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            if (!dayScheduleMap.containsKey('12:30pm')) {
                              setState(() {
                                selectedBatch = '12:30pm';
                              });
                            }
                          },
                          child: Card(
                              //  elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '12:30pm'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('12:30pm')
                                    ? 'Booked'
                                    : '12:30pm',
                                style: TextStyle(
                                    color: selectedBatch == '12:30pm'
                                        ? Colors.white
                                        : Colors.black54),
                              ))),
                        )),
                    Container(
                      height: 5,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedBatch = '5:00pm';
                            });
                            readAppointment(
                                dayScheduleMap['5:00pm'].toString());
                            print(dayScheduleMap['5:00pm']);
                          },
                          child: Card(
                              //  elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '5:00pm'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('5:00pm')
                                    ? 'Booked'
                                    : '5:00pm',
                                style: TextStyle(
                                  color: selectedBatch == '5:00pm'
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ))),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedBatch = '5:30pm';
                            });
                            readAppointment(
                                dayScheduleMap['5:30pm'].toString());
                            print(dayScheduleMap['5:30pm']);
                          },
                          child: Card(
                              // elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '5:30pm'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('5:30pm')
                                    ? 'Booked'
                                    : '5:30pm',
                                style: TextStyle(
                                  color: selectedBatch == '5:30pm'
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ))),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedBatch = '6:00pm';
                            });
                            readAppointment(
                                dayScheduleMap['6:00pm'].toString());
                            print(dayScheduleMap['6:00pm']);
                          },
                          child: Card(
                              // elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '6:00pm'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('6:00pm')
                                    ? 'Booked'
                                    : '6:00pm',
                                style: TextStyle(
                                  color: selectedBatch == '6:00pm'
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ))),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedBatch = '6:30pm';
                            });
                            readAppointment(
                                dayScheduleMap['6:30pm'].toString());
                            print(dayScheduleMap['6:30pm']);
                          },
                          child: Card(
                              // elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '6:30pm'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('6:30pm')
                                    ? 'Booked'
                                    : '6:30pm',
                                style: TextStyle(
                                    color: selectedBatch == '6:30pm'
                                        ? Colors.white
                                        : Colors.black54),
                              ))),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedBatch = '7:00pm';
                            });
                            readAppointment(
                                dayScheduleMap['7:00pm'].toString());
                            print(dayScheduleMap['7:00pm']);
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '7:00pm'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('7:00pm')
                                    ? 'Booked'
                                    : '7:00pm',
                                style: TextStyle(
                                  color: selectedBatch == '7:00pm'
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ))),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedBatch = '7:30pm';
                            });
                            readAppointment(
                                dayScheduleMap['7:30pm'].toString());
                            print(dayScheduleMap['7:30pm']);
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(254, 112, 98, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              color: selectedBatch == '7:30pm'
                                  ? Color.fromRGBO(254, 112, 98, 1)
                                  : Colors.white,
                              child: Center(
                                  child: Text(
                                dayScheduleMap.containsKey('7:30pm')
                                    ? 'Booked'
                                    : '7:30pm',
                                style: TextStyle(
                                  color: selectedBatch == '7:30pm'
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ))),
                        )),
                  ],
                )),

            Container(
              child: ListTile(
                leading: Text(
                  'Time : ',
                  style: TextStyle(fontSize: 15),
                ),
                title: Text(
                  appointmentTime,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),

            Container(
              child: ListTile(
                leading: Text(
                  'Email Id : ',
                  style: TextStyle(fontSize: 15),
                ),
                title: Text(
                  nameid,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),

            Container(
              child: ListTile(
                leading: Text(
                  'Existing Symptoms : ',
                  style: TextStyle(fontSize: 15),
                ),
                title: Text(
                  problem,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            Container(
              height: 25,
            ),

            Container(
              height: 46,
              width: 230,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserInfo(nameid)),
                  );
                },
                child: Text(
                  'View more info',
                  style: TextStyle(color: Colors.white, fontSize: 15.5),
                ),
                color: Color.fromRGBO(68, 133, 238, 1),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
