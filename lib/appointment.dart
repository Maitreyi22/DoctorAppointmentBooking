import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String appointmenttime;
  String bookingtime;
  String appointmentday;
  String user;
  String diseases;

  Appointment(this.appointmentday, this.appointmenttime, this.bookingtime,
      this.diseases, this.user);
}
