import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreSach {
  static CollectionReference saches =
      FirebaseFirestore.instance.collection('Sach');

  static Future<void> addSaches(
      String tenSach, String idTacGia,String giaTien, String ngayXuatBan) {
    return saches.add({
      'TenSach': tenSach,
      'IDTacGia': idTacGia,
      'GiaTien': giaTien,
      'NgayXuatBan': ngayXuatBan,
    });
  }

  static Stream<QuerySnapshot> getSaches() {
    final sachStream = saches.orderBy('TenSach', descending: true).snapshots();
    return sachStream;
  }

  static Future<void> updateSach(
      String docID, String tenSach,  String idTacGia ,String giaTien, String ngayXuatBan) {
    return saches.doc(docID).update({
      'TenSach': tenSach,
      // 'TenTacGia': tenTacGia,
      'IDTacGia': idTacGia,
      'GiaTien': giaTien,
      'NgayXuatBan': ngayXuatBan,
    });
  }

  static Future<void> deleteSach(String docID) {
    return saches.doc(docID).delete();
  }
}
