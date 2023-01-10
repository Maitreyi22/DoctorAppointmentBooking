import 'package:flutter/material.dart';

class DoctorInfo extends StatefulWidget {
  const DoctorInfo({Key? key}) : super(key: key);

  @override
  _DoctorInfoState createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(188, 227, 243, 1),
      body: SafeArea(
        child: Center(
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
                      margin: EdgeInsets.only(top: 17, left: 69),
                      child: Text(
                        'Doctors Profile',
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
                  height: 110,
                  margin: EdgeInsets.only(top: 40),
                  // height: MediaQuery.of(context).size.height * .2,
                  // width: MediaQuery.of(context).size.height * .2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      'asset/docphoto.jpeg',
                    ),
                  )),
              Container(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.only(left: 20),
                  alignment: Alignment.center,
                  child: Text(
                    'Dr Abhijit Deshpande ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 20),
                  alignment: Alignment.center,
                  child: Text(
                    'BDS, MDS - Periodontics',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(68, 133, 238, 1)),
                  )),

              Container(
                height: 36,
              ),

              // Container(
              //     margin: EdgeInsets.only(left: 20, right: 20),
              //     child: Divider(color: Colors.cyan)),

              const Divider(
                height: 20,
                thickness: 2,
                indent: 16,
                endIndent: 16,
              ),

              Container(
                  margin: EdgeInsets.only(left: 25, top: 10, bottom: 10),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'About',
                    style: TextStyle(
                        fontSize: 18,
                        //color: Colors.cyan,
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 25, bottom: 15),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Dr. Abhijit Deshpande is a Dentist practicing at Bright Dental Foundation, Wakad and has 2 more clinics in' +
                        '\n' +
                        'Pimple Saudagar and Pune. He has an experience of' +
                        '\n' +
                        '17 years in this field. He completed BDS from Dr. D.Y.' +
                        '\n' +
                        'Patil Dental College Hospital, Pune in 2004 and MDS- Periodontics from DY Patil University in 2017.' +
                        '\n\n' +
                        'Contact : 098232 34778',
                    style: TextStyle(
                        fontSize: 14, color: Color.fromRGBO(115, 115, 115, 1)),
                  )),

              Container(
                  margin: EdgeInsets.only(left: 25, top: 10, bottom: 5),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Specialisation',
                    style: TextStyle(
                        fontSize: 18,
                        //color: Colors.cyan,
                        fontWeight: FontWeight.bold),
                  )),

              Container(
                margin: EdgeInsets.only(left: 12, top: 4),
                height: 32,
                child: ListTile(
                  horizontalTitleGap: -18,
                  leading: Container(
                    padding: EdgeInsets.only(top: 7.5),
                    child: CircleAvatar(
                      radius: 5.0,
                      backgroundColor: Color.fromRGBO(254, 112, 98, 1),
                    ),
                  ),
                  title: Container(
                    child: Text(
                      'Impaction / Impacted Tooth Extraction.',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(115, 115, 115, 1)),
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                  left: 12,
                  top: 0,
                ),
                height: 32,
                child: ListTile(
                  horizontalTitleGap: -18,
                  // leading: Icon(
                  //   Icons.circle_rounded,
                  //   size: 12,
                  // ),
                  leading: Container(
                    padding: EdgeInsets.only(top: 7.5),
                    child: CircleAvatar(
                      radius: 5.0,
                      backgroundColor: Color.fromRGBO(254, 112, 98, 1),
                    ),
                  ),
                  title: Container(
                    child: Text(
                      'Dental Fillings.',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(115, 115, 115, 1)),
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                  left: 12,
                  top: 0,
                ),
                height: 32,
                child: ListTile(
                  horizontalTitleGap: -18,
                  // leading: Icon(
                  //   Icons.circle_rounded,
                  //   size: 12,
                  // ),
                  leading: Container(
                    padding: EdgeInsets.only(top: 7.5),
                    child: CircleAvatar(
                      radius: 5.0,
                      backgroundColor: Color.fromRGBO(254, 112, 98, 1),
                    ),
                  ),
                  title: Container(
                    child: Text(
                      'Artificial Teeth and Crowns and Bridges Fixing.',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(115, 115, 115, 1)),
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                  left: 12,
                  top: 0,
                ),
                height: 30,
                child: ListTile(
                  horizontalTitleGap: -18,
                  // leading: Icon(
                  //   Icons.circle_rounded,
                  //   size: 12,
                  // ),
                  leading: Container(
                    padding: EdgeInsets.only(top: 7.5),
                    child: CircleAvatar(
                      radius: 5.0,
                      backgroundColor: Color.fromRGBO(254, 112, 98, 1),
                    ),
                  ),
                  title: Container(
                    child: Text(
                      'Gum Disease Treatment/ Surgery etc.',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(115, 115, 115, 1)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
