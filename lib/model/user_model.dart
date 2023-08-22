import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String nama;
  final String kelamin;
  final DateTime tanggalLahir;
  final double heartRate;
  final String tinggkatAktivitas;
  final String beratBadan;
  final String tinggiBadan;
  final double bmi;
  final double bmr;
  final double kalori;
  final String katBmi;
  final double myAge;
  final double hasilBmr;
  final String kaloriPagi;
  final String kaloriSiang;
  final String kaloriMalam;

  final Timestamp createdAt;

  const UserModel(
      {required this.createdAt,
      required this.uid,
      required this.nama,
      required this.email,
      required this.beratBadan,
      required this.kelamin,
      required this.tanggalLahir,
      required this.heartRate,
      required this.tinggiBadan,
      required this.tinggkatAktivitas,
      required this.bmi,
      required this.bmr,
      required this.kalori,
      required this.katBmi,
      required this.myAge,
      required this.hasilBmr,
      required this.kaloriMalam,
      required this.kaloriPagi,
      required this.kaloriSiang});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        createdAt: snapshot["createdAt"],
        uid: snapshot["uid"],
        nama: snapshot['nama'],
        email: snapshot["email"],
        beratBadan: snapshot["beratBadan"],
        kelamin: snapshot["kelamin"],
        tanggalLahir: snapshot["tglLahir"],
        heartRate: snapshot["heartRate"],
        tinggiBadan: snapshot["tinggiBadan"],
        tinggkatAktivitas: snapshot["tingkatAktivitas"],
        bmi: snapshot['bmi'],
        bmr: snapshot['bmr'],
        hasilBmr: snapshot['hasilBmr'],
        kalori: snapshot['kalori'],
        katBmi: snapshot['katBmi'],
        myAge: snapshot['myAge'],
        kaloriMalam: snapshot['kaloriMalam'],
        kaloriPagi: snapshot['kaloriPagi'],
        kaloriSiang: snapshot['kaloriSiang']);
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "nama": nama,
        "beratBadan": beratBadan,
        "kelamin": kelamin,
        "tglLahir": tanggalLahir,
        "heartRate": heartRate,
        "tinggiBadan": tinggiBadan,
        "tingkatAktivitas": tinggkatAktivitas,
        "bmi": bmi,
        "bmr": bmr,
        "hasilBmr": hasilBmr,
        "kalori": kalori,
        "katBmi": katBmi,
        "myAge": myAge,
        "kaloriSiang": kaloriSiang,
        "kaloriPagi": kaloriPagi,
        "kaloriMalam": kaloriMalam,
        "createdAt": Timestamp.now()
      };
}
