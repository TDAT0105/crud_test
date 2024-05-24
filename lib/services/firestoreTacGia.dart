import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTacGia {
  //get collection of notes
  final CollectionReference tacgias =
      FirebaseFirestore.instance.collection('TacGia');
  //create

  Future<void> addTacgias(String tenTacGia, String email, String sdt) {
    return tacgias.add({
      'TenTacGia': tenTacGia,
      'NgaySinh': Timestamp.now(),
      'Email': email,
      'SDT': sdt,
    });
  }
  
  //read
  Stream<QuerySnapshot> getTacGias() {
    final noteStream =
        tacgias.orderBy('NgaySinh', descending: true).snapshots();
    return noteStream;
  }
  
  //update
  Future<void> updateTacGia(
      String docID, String newtenTacGia, String newEmail, String newSDT) {
    return tacgias.doc(docID).update({
      'note': newtenTacGia,
      'NgaySinh': Timestamp.now(),
      'Email': newEmail,
      'SDT': newSDT,
    });
  }

  //delete
  Future<void> deleteTacGia(String docID) {
    return tacgias.doc(docID).delete();
  }
}
