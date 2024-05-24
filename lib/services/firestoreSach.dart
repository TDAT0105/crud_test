import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreSach {
  final CollectionReference saches =
      FirebaseFirestore.instance.collection('Sach');

  Future<void> addSaches(
      String tenSach, String idTacGia, String giaTien, String ngayXuatBan) {
    return saches.add({
      'TenSach': tenSach,
      'IDTacGia': idTacGia,
      'GiaTien': giaTien,
      'NgayXuatBan': ngayXuatBan,
    });
  }

  Stream<QuerySnapshot> getSaches() {
    final sachStream = saches.orderBy('TenSach', descending: true).snapshots();
    return sachStream;
  }

  Future<void> updateSach(
      String docID, String tenSach, String idTacGia, String giaTien, String ngayXuatBan) {
    return saches.doc(docID).update({
      'TenSach': tenSach,
      'IDTacGia': idTacGia,
      'GiaTien': giaTien,
      'NgayXuatBan': ngayXuatBan,
    });
  }

  Future<void> deleteSach(String docID) {
    return saches.doc(docID).delete();
  }
}
