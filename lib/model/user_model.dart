import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String tujuan;
  final String kelamin;
  final String tanggalLahir;
  final double heartRate;
  final String tinggkatAktivitas;
  final String beratBadan;
  final String tinggiBadan;

  final Timestamp createdAt;

  const UserModel(
      {required this.createdAt,
      required this.uid,
      required this.email,
      required this.tujuan,
      required this.beratBadan,
      required this.kelamin,
      required this.tanggalLahir,
      required this.heartRate,
      required this.tinggiBadan,
      required this.tinggkatAktivitas});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        createdAt: snapshot["createdAt"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        beratBadan: snapshot["beratBadan"],
        kelamin: snapshot["kelamin"],
        tanggalLahir: snapshot["tglLahir"],
        heartRate: snapshot["heartRate"],
        tinggiBadan: snapshot["tinggiBadan"],
        tinggkatAktivitas: snapshot["tingkatAktivitas"],
        tujuan: snapshot["tujuan"]);
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "beratBadan": beratBadan,
        "kelamin": kelamin,
        "tglLahir": tanggalLahir,
        "heartRate": heartRate,
        "tinggiBadan": tinggiBadan,
        "tingkatAktivitas": tinggkatAktivitas,
        "tujuan": tujuan,
        "createdAt": Timestamp.now()
      };
}
