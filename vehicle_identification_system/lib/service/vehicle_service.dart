import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../enum/direction.dart';
import '../models/log.dart';
import '../models/vehicle.dart';
import '../utils/utils.dart';

class VehicleService {
  CollectionReference vehiclesRef =
      FirebaseFirestore.instance.collection('vehicles');
  CollectionReference logsRef = FirebaseFirestore.instance.collection('logs');
  CollectionReference liveVehiclesRef =
      FirebaseFirestore.instance.collection("livevehicles");
  CollectionReference scansRef = FirebaseFirestore.instance.collection("scans");

  Future<String?> getApiUrl() async {
    // getting the apiUrl from firebase since flask server isnt deployed and the url changes every time we run the server.
    // so we store the apiUrl in firebase and can directly change the url in firebase instead of changing the code and
    // runnign the app again
    var data =
        await FirebaseFirestore.instance.collection('api').doc('uri').get();
    if (data.data() != null) {
      print(data.data());
      return data.data()!["apiUrl"];
    } else {
      return null;
    }
  }

  Future<void> addVehicle({required Vehicle vehicle, bool isEdit = false}) {
    if (!isEdit) {
      // SmsUtil.sendWelcomeSms(
      //   name: vehicle.ownerName,
      //   number: vehicle.ownerMobileNo,
      //   licensePlate: vehicle.licensePlateNo,
      //   expiryDate: vehicle.expires,
      // );
    } else {
      // SmsUtil.sendExpiryUpdateSms(
      //   name: vehicle.ownerName,
      //   number: vehicle.ownerMobileNo,
      //   licensePlate: vehicle.licensePlateNo,
      //   expiryDate: vehicle.expires,
      // );
    }

    return vehiclesRef.doc(vehicle.licensePlateNo).set(vehicle.toMap());
  }

  Future<Vehicle?> getVehicle({required String licensePlateNo}) async {
    var data = await vehiclesRef.doc(licensePlateNo).get();
    if (data.data() != null) {
      Vehicle vehicle = Vehicle.fromMap(data.data() as dynamic);
      print(vehicle.licensePlateNo);
      return vehicle;
    } else {
      return null;
    }
  }

  Future<void> addLog({required Vehicle vehicle}) {
    var currTime = DateTime.now().toString();
    Log log = Log(
      vehicle: vehicle.toMap(),
      direction: vehicle.isInCampus
          ? Utils.directionToNum(Direction.Leaving)
          : Utils.directionToNum(Direction.Entering),
      time: currTime,
    );

    // update vehicle status isInCampus
    vehiclesRef.doc(vehicle.licensePlateNo).update({
      'isInCampus': !vehicle.isInCampus,
    });
    // add log

    return logsRef.add(log.toMap());
  }

  Future<void> addLiveVehicle(
      {Vehicle? vehicle,
      bool? isExpired,
      bool? success,
      String errorMsg = ""}) async {
    var timestamp = DateTime.now().toString();
    liveVehiclesRef.doc(timestamp).set({
      "isAllowed": !isExpired!,
      "isExpired": isExpired,
      "success": success,
      "errorMsg": errorMsg,
      "vehicle": vehicle?.toMap(),
      "timestamp": timestamp,
    });

    Future.delayed(const Duration(seconds: 20), () {
      print("DELETE Document");
      liveVehiclesRef.doc(timestamp).delete();
    });
  }

  Future<void> deleteTopmostLiveVehicle() {
    return liveVehiclesRef
        .orderBy("timestamp", descending: false)
        .limit(1)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Stream liveVehiclesStream() {
    return liveVehiclesRef.orderBy("timestamp", descending: false).snapshots();
  }

  Future<String> uploadImageToFirestoreAndStorage(
      File image, String licensePlate) async {
    String mFileName = licensePlate;
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('profile/$mFileName.png')
          .putFile(image);
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('profile/$mFileName.png')
          .getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      print(e);
      return 'Error';
    }
  }

  Future<void> updateScans() async {
    var date = DateTime.now();
    var currDate = date.subtract(Duration(
      hours: date.hour,
      minutes: date.minute,
      seconds: date.second,
      milliseconds: date.millisecond,
      microseconds: date.microsecond,
    ));
    var data = await scansRef.doc(currDate.toString()).get();
    // if document exists already then update the document
    if (data.data() != null) {
      return scansRef.doc(currDate.toString()).update({
        'count': FieldValue.increment(1),
        'timestamp': currDate.toString(),
      });
    }
    // else create new doc
    else {
      return scansRef.doc(currDate.toString()).set({
        'count': 1,
        'timestamp': currDate.toString(),
      });
    }
  }
}
