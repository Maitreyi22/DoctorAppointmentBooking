import 'package:app/dashboard.dart';
import 'package:app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegistrationUserPage extends StatefulWidget {
  Function signOut;
  GoogleSignInAccount user;

  RegistrationUserPage(this.user, this.signOut);

  @override
  _RegistrationUserPageState createState() => _RegistrationUserPageState();
}

class _RegistrationUserPageState extends State<RegistrationUserPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final successnackbar = SnackBar(content: Text('Registered Successfully!'));
  final nameWarning = SnackBar(content: Text('Please Enter a User Name!'));
  final mobileWarning =
      SnackBar(content: Text('Please Enter a valid contact number!'));
  final addressWarning = SnackBar(content: Text('Please enter your Address! '));
  final dobWarning =
      SnackBar(content: Text('Please enter a valid Date of Birth!'));
  DateTime selectedDate = DateTime.now();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      nameController.text = widget.user.displayName.toString();
    });
  }

  int _radioValue = 0;

  void _handleRadioValueChange(value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(188, 227, 243, 1),
      //backgroundColor: Color.fromRGBO(229, 244, 241, 1),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, left: 0, right: 200),
                  alignment: Alignment.topLeft,
                  height: 30,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(
                            widget.signOut(), widget.user.clearAuthCache());
                      },
                      icon: Icon(Icons.arrow_back, size: 35)),
                ),

                Container(
                  margin: EdgeInsets.only(left: 0, top: 34),
                  child: Text(
                    'Enter Personal Details',
                    style: TextStyle(
                        fontSize: 20,
                        //color: Color.fromRGBO(68, 133, 238, 1),
                        color: Color.fromRGBO(74, 64, 64, 1),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),

                Container(
                  height: 25,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundImage:
                          NetworkImage(widget.user.photoUrl.toString()),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .8,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Name',
                      hintStyle: TextStyle(
                        color: Colors.black, // <-- Change this
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                      contentPadding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      suffixIcon: Icon(Icons.person, size: 30),
                      // border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(30),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //),
                Container(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .7,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    controller: mobileController,
                    decoration: InputDecoration(
                      hintText: 'Enter Contact Number',
                      hintStyle: TextStyle(
                        color: Colors.black, // <-- Change this
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                      contentPadding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      suffix: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                Container(
                  height: 20,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Text('Gender : ', style: TextStyle(fontSize: 17.0)),
                    Radio(
                      value: 0,
                      activeColor: Color.fromRGBO(68, 133, 238, 1),
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    Text(
                      'Male',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      value: 1,
                      activeColor: Color.fromRGBO(68, 133, 238, 1),
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    Text(
                      'Female',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .8,
                  child: TextField(
                    maxLines: 2,
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: 'Enter Address',
                      hintStyle: TextStyle(
                        color: Colors.black, // <-- Change this
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                      contentPadding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      suffix: Icon(Icons.location_city, size: 30),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                Container(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 20,
                    ),
                    Text(
                      "Select your DOB  : ",
                      style: TextStyle(fontSize: 17),
                    ),
                    Container(
                      width: 20,
                    ),
                    Container(
                      width: 120,
                      child: RaisedButton(
                        //shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(30)),
                        onPressed: () => _selectDate(context), // Refer step 3
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        color: Color.fromRGBO(68, 133, 238, 1),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      height: 46,
                      width: 230,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          switch (validateFields()) {
                            case 0:
                              _registerUser();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(successnackbar);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Dashboard(widget.user, widget.signOut)),
                              );
                              break;

                            case 1:
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(nameWarning);
                              break;
                            case 2:
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(mobileWarning);
                              break;
                            case 3:
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(addressWarning);
                              break;
                            case 4:
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(dobWarning);
                              break;
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 15.5),
                        ),
                        color: Color.fromRGBO(254, 112, 98, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1930),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  int validateFields() {
    if (nameController.text.length == 0) {
      return 1;
    } else if (mobileController.text.length != 10) {
      return 2;
    } else if (addressController.text.length < 5) {
      return 3;
    } else if (selectedDate.year > DateTime.now().year - 10) {
      return 4;
    } else {
      return 0;
    }
  }

  void _registerUser() async {
    try {
      await firestore
          .collection('docusers')
          .doc(widget.user.email.toString())
          .set({
        'name': nameController.text.toString(),
        'gender': _radioValue == 0 ? 'Male' : 'Female',
        'address': addressController.text.toString(),
        'dob': selectedDate,
        'mobile': mobileController.text.toString(),
      });
    } catch (e) {
      print(e);
    }
  }
}
