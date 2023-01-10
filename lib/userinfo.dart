import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserInfo extends StatefulWidget {
  String userMail;

  UserInfo(this.userMail);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String address = ' ';
  String name = ' ';
  String mobile = ' ';
  String gender = ' ';
  Timestamp dob = Timestamp.fromMillisecondsSinceEpoch(34567890);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void readUserData() async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore
          .collection('docusers')
          .doc(widget.userMail.toString())
          .get();

      setState(() {
        name = (documentSnapshot.data() as dynamic)['name'];
        address = (documentSnapshot.data() as dynamic)['address'];
        mobile = (documentSnapshot.data() as dynamic)['mobile'];
        gender = (documentSnapshot.data() as dynamic)['gender'];
        dob = (documentSnapshot.data() as dynamic)['dob'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.userMail);
    readUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: SafeArea(
              child: Column(
        children: [
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
                    'Patient Information',
                    style: TextStyle(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(),
          //   child: CircleAvatar(
          //     radius: 90,
          //     backgroundImage: NetworkImage(
          //         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIpyao3Dbz2P7W_b7q2EqycRQRkcyOmaFFLQ&usqp=CAU'),
          //   ),
          // ),

          Container(
            height: 38,
          ),

          Container(
            margin: EdgeInsets.only(left: 18, top: 2, right: 18),
            child: Image.asset(
              'asset/teethlearn.png',
            ),
          ),

          Container(
            child: ListTile(
              leading: Text(
                'Patient Name : ',
                style: TextStyle(fontSize: 15),
              ),
              title: Text(
                name,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            child: ListTile(
              leading: Text(
                'Gender : ',
                style: TextStyle(fontSize: 15),
              ),
              title: Text(
                gender,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            child: ListTile(
              leading: Text(
                'Address : ',
                style: TextStyle(fontSize: 15),
              ),
              title: Text(
                address,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            child: ListTile(
              leading: Text(
                'Contact number : ',
                style: TextStyle(fontSize: 15),
              ),
              title: Text(
                mobile,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ))),
    );
  }
}
