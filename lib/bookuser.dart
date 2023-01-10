//import 'dart:html';
import 'dart:ffi';

import 'package:app/appointment.dart';
import 'package:app/service/notificationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:date_picker_timeline/extra/dimen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class BookUserpage extends StatefulWidget {
  GoogleSignInAccount user;

  BookUserpage(this.user);

  @override
  _BookUserpageState createState() => _BookUserpageState();
}

class _BookUserpageState extends State<BookUserpage> {
  DateTime _selectedValue = DateTime.now();
  String selectedBatch = '';
  Set<String> diseasesList = new Set();
  List<Appointment> appointmentList = [];
  TextEditingController diseaseController = TextEditingController();
  Map dayScheduleMap = {};

  final successnackbar =
      SnackBar(content: Text('Appointment Booked Successfully'));
  final notsucesssnakbar = SnackBar(
      content:
          Text('Failed to book an Appointment. Please check all the fields'));

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
      print(documentSnapshot.data());

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
    return Scaffold(
      //backgroundColor: Color.fromRGBO(229, 244, 241, 1),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          // scrollDirection: Axis.horizontal,
          children: <Widget>[
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
                    // child: Image.asset(
                    //   'asset/backicon.png',
                    // ), //icon
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 60),
                    child: Text(
                      'New Appointment',
                      style: TextStyle(
                        fontSize: 18,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 10,
            ),
            Divider(),
            Column(
              children: [
                Container(
                  height: 85,
                  margin: EdgeInsets.only(left: 18),
                  child: DatePicker(
                    DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: Color.fromRGBO(254, 112, 98, 1),
                    selectedTextColor: Colors.white,
                    daysCount: 14 - DateTime.now().weekday,
                    onDateChange: (date) {
                      // New date selected
                      setState(() {
                        _selectedValue = date;
                        selectedBatch = '';
                      });
                      readTodayScheduleMap();
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
                margin: EdgeInsets.all(18),
                child: Wrap(
                  children: <Widget>[
                    Container(
                      child: Text('Available Time',
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
                            if (!dayScheduleMap.containsKey('10:00am') &&
                                validate('10:00am')) {
                              setState(() {
                                selectedBatch = '10:00am';
                              });
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
                                  fontWeight:
                                      dayScheduleMap.containsKey('10:00am')
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('10:30am') &&
                                validate('10:30am')) {
                              setState(() {
                                selectedBatch = '10:30am';
                              });
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                  fontWeight:
                                      dayScheduleMap.containsKey('10:30am')
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('11:00am') &&
                                validate('11:00am')) {
                              setState(() {
                                selectedBatch = '11:00am';
                              });
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                    fontWeight:
                                        dayScheduleMap.containsKey('11:00am')
                                            ? FontWeight.bold
                                            : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('11:30am') &&
                                validate('11:30am')) {
                              setState(() {
                                selectedBatch = '11:30am';
                              });
                            }
                          },
                          child: Card(
                              // elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                  fontWeight:
                                      dayScheduleMap.containsKey('11:30am')
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('12:00pm') &&
                                validate('12:00pm')) {
                              setState(() {
                                selectedBatch = '12:00pm';
                              });
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                  fontWeight:
                                      dayScheduleMap.containsKey('12:00pm')
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('12:30pm') &&
                                validate('12:30pm')) {
                              setState(() {
                                selectedBatch = '12:30pm';
                              });
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                    fontWeight:
                                        dayScheduleMap.containsKey('12:30pm')
                                            ? FontWeight.bold
                                            : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('5:00pm') &&
                                validate('5:00pm')) {
                              setState(() {
                                selectedBatch = '5:00pm';
                              });
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                  fontWeight:
                                      dayScheduleMap.containsKey('5:00pm')
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('5:30pm') &&
                                validate('5:30pm')) {
                              setState(() {
                                selectedBatch = '5:30pm';
                              });
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                  fontWeight:
                                      dayScheduleMap.containsKey('5:30pm')
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('6:00pm') &&
                                validate('6:00pm')) {
                              setState(() {
                                selectedBatch = '6:00pm';
                              });
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                  fontWeight:
                                      dayScheduleMap.containsKey('6:00pm')
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('6:30pm') &&
                                validate('6:30pm')) {
                              setState(() {
                                selectedBatch = '6:30pm';
                              });
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                    fontWeight:
                                        dayScheduleMap.containsKey('6:30pm')
                                            ? FontWeight.bold
                                            : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('7:00pm') &&
                                validate('7:00pm')) {
                              setState(() {
                                selectedBatch = '7:00pm';
                              });
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                  fontWeight:
                                      dayScheduleMap.containsKey('7:00pm')
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                            if (!dayScheduleMap.containsKey('7:30pm') &&
                                validate('7:30pm')) {
                              setState(() {
                                selectedBatch = '7:30pm';
                              });
                            }
                          },
                          child: Card(
                              //elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(254, 112, 98, 1)),
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
                                  fontWeight:
                                      dayScheduleMap.containsKey('7:30pm')
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color: selectedBatch == '7:30pm'
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ))),
                        )),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 5, left: 0, right: 225, bottom: 0),
              child: Text('Existing Symptoms',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: EdgeInsets.all(14),
              child: TextField(
                enabled: false,
                controller: diseaseController,
                decoration: InputDecoration(
                  hintText: 'Please select symptoms from below.',
                  hintStyle: TextStyle(
                    color: Colors.black54, // <-- Change this
                    fontSize: 14,

                    // fontWeight: FontWeight.w400,
                    //fontStyle: FontStyle.normal,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 2, right: 2),
              child: Wrap(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .24,
                    height: 43,
                    child: InkWell(
                      onTap: () {
                        if (diseasesList.contains('Bad Breath')) {
                          setState(() {
                            diseasesList.remove('Bad Breath');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        } else {
                          setState(() {
                            diseasesList.add('Bad Breath');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        }
                      },
                      child: Card(
                          //elevation: 5,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromRGBO(68, 133, 238, 1)),
                              borderRadius: BorderRadius.circular(25)),
                          //color: Color.fromRGBO(129, 153, 234, 1),
                          color: Color.fromRGBO(238, 243, 254, 1),
                          child: Center(
                              child: Text(
                            'Bad Breath',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(68, 133, 238, 1),
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .24,
                    height: 43,
                    child: InkWell(
                      onTap: () {
                        if (diseasesList.contains('Tooth Ache')) {
                          setState(() {
                            diseasesList.remove('Tooth Ache');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        } else {
                          setState(() {
                            diseasesList.add('Tooth Ache');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        }
                      },
                      child: Card(
                          //elevation: 5,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromRGBO(68, 133, 238, 1)),
                              borderRadius: BorderRadius.circular(25)),
                          color: Color.fromRGBO(238, 243, 254, 1),
                          child: Center(
                              child: Text(
                            'Tooth Ache',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(68, 133, 238, 1),
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .24,
                    height: 43,
                    child: InkWell(
                      onTap: () {
                        if (diseasesList.contains('Ulcers')) {
                          setState(() {
                            diseasesList.remove('Ulcers');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        } else {
                          setState(() {
                            diseasesList.add('Ulcers');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        }
                      },
                      child: Card(
                          //elevation: 5,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color.fromRGBO(68, 133, 238, 1),
                              ),
                              borderRadius: BorderRadius.circular(25)),
                          color: Color.fromRGBO(238, 243, 254, 1),
                          child: Center(
                              child: Text(
                            'Ulcers',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(68, 133, 238, 1),
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .24,
                    height: 43,
                    child: InkWell(
                      onTap: () {
                        if (diseasesList.contains('Tooth Decay')) {
                          setState(() {
                            diseasesList.remove('Tooth Decay');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        } else {
                          setState(() {
                            diseasesList.add('Tooth Decay');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        }
                      },
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
                            'Tooth Decay',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(68, 133, 238, 1),
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .24,
                    height: 43,
                    child: InkWell(
                      onTap: () {
                        if (diseasesList.contains('Sensitivity')) {
                          setState(() {
                            diseasesList.remove('Sensitivity');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        } else {
                          setState(() {
                            diseasesList.add('Sensitivity');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        }
                      },
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
                            'Sensitivity',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(68, 133, 238, 1),
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .24,
                    height: 43,
                    child: InkWell(
                      onTap: () {
                        if (diseasesList.contains('Tooth Erosion')) {
                          setState(() {
                            diseasesList.remove('Tooth Erosion');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        } else {
                          setState(() {
                            diseasesList.add('Tooth Erosion');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        }
                      },
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
                            'Tooth Erosion',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(68, 133, 238, 1),
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .24,
                    height: 43,
                    child: InkWell(
                      onTap: () {
                        if (diseasesList.contains('Gum Diseases')) {
                          setState(() {
                            diseasesList.remove('Gum Diseases');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        } else {
                          setState(() {
                            diseasesList.add('Gum Diseases');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        }
                      },
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
                            'Gum Diseases',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(68, 133, 238, 1),
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .24,
                    height: 43,
                    child: InkWell(
                      onTap: () {
                        if (diseasesList.contains('Other')) {
                          setState(() {
                            diseasesList.remove('Other');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        } else {
                          setState(() {
                            diseasesList.add('Other');
                            diseaseController.text = diseasesList
                                .toString()
                                .substring(
                                    1, diseasesList.toString().length - 1);
                          });
                        }
                      },
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
                            'Other',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(68, 133, 238, 1),
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            // Container(
            //   height: 50,
            //   width: 300,
            //   margin: EdgeInsets.all(10),
            //   child: FlatButton(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10)),
            //     color: selectedBatch != '' && diseasesList.length != 0
            //         ? Color.fromRGBO(0, 179, 154, 1)
            //         : Colors.grey,
            //     onPressed: () {
            //       if (selectedBatch != '' && diseasesList.length != 0) {
            //         print(dayScheduleMap);
            //         ScaffoldMessenger.of(context).showSnackBar(successnackbar);
            //         Navigator.pop(context);
            //       } else {
            //         ScaffoldMessenger.of(context)
            //             .showSnackBar(notsucesssnakbar);
            //       }
            //     },
            //     child: Text(
            //       'Set Appointment',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),

            selectedBatch != '' && diseasesList.length != 0
                ? TextButton(
                    onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                  'You need to pay a deposit of 100Rs for Booking Confirmation'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                Consumer<NotificationService>(
                                  builder: (context, model, _) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              if (selectedBatch != '' &&
                                                  diseasesList.length != 0) {
                                                _bookAppointment();
                                                model.stylishNotification(
                                                    _selectedValue,
                                                    selectedBatch);
                                                model.sheduledNotification(
                                                    _selectedValue,
                                                    selectedBatch);
                                                print(dayScheduleMap);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        successnackbar);
                                                Navigator.pop(context);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        notsucesssnakbar);
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Pay ')),
                                      ]),
                                ),
                              ],
                            )),
                    child: Container(
                        height: 50,
                        width: 350,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: selectedBatch != '' && diseasesList.length != 0
                              ? Color.fromRGBO(68, 133, 238, 1)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '                             Set Appointment',
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                : Container()
          ],
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print(dayScheduleMap);
      //   },
      // ),
    );
  }

  void _bookAppointment() async {
    try {
      await firestore.collection("doctorAppointments").add({
        'appointmentTime': selectedBatch.toString(),
        'appointmentDay': _selectedValue,
        'bookingTime': DateTime.now(),
        'diseases': diseasesList
            .toString()
            .substring(1, diseasesList.toString().length - 1),
        'user': widget.user.email.toString()
      }).then((value) {
        print(value.id);
        setState(() {
          dayScheduleMap.putIfAbsent(selectedBatch, () => value.id);
        });
        firestore
            .collection("docperdaybookings")
            .doc(DateTime(_selectedValue.year, _selectedValue.month,
                    _selectedValue.day)
                .toString())
            .set({"todaySchedule": dayScheduleMap}).then((value) {
          //     print(value);
        });

        firestore
            .collection("docusers")
            .doc(widget.user.email.toString())
            .update({"booking": value.id});
      });
    } catch (e) {
      print(e);
    }
  }

  bool validate(String selectedBatch) {
    if (DateTime.now().microsecondsSinceEpoch <
        _selectedValue.microsecondsSinceEpoch) {
      return true;
    }
    int selectedBatch24hrs =
        int.parse(selectedBatch.substring(0, selectedBatch.indexOf(':')));

    if (selectedBatch24hrs < 8) {
      selectedBatch24hrs = selectedBatch24hrs + 12;
    }
    print(selectedBatch24hrs);

    if ((DateTime.now().hour) < selectedBatch24hrs) {
      print((DateTime.now().hour).toString() +
          ' can book ' +
          selectedBatch24hrs.toString());
      return true;
    } else {
      print((DateTime.now().hour).toString() +
          ' cannot book ' +
          selectedBatch24hrs.toString());
      return false;
    }
  }
}
