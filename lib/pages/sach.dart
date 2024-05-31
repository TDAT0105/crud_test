import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_test/services/firestoreSach.dart';
import 'package:flutter/material.dart';

class SachPage extends StatefulWidget {
  const SachPage({super.key});

  @override
  State<SachPage> createState() => _SachPageState();
}

class _SachPageState extends State<SachPage> {
  String? selectedTacGia;

  void openNoteBox({String? docID}) {
    TextEditingController tenSach = TextEditingController();
    TextEditingController giaTien = TextEditingController();
    TextEditingController ngayXuatBan = TextEditingController();

    if (docID != null) {
      FirebaseFirestore.instance
          .collection('Sach')
          .doc(docID)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            tenSach.text = snapshot['TenSach'];
            giaTien.text = snapshot['GiaTien'];
            ngayXuatBan.text = snapshot['NgayXuatBan'];
            selectedTacGia = snapshot['IDTacGia'];
          });
        }
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tenSach,
                    decoration: const InputDecoration(
                      hintText: 'Tên Sách',
                    ),
                  ),
                  const SizedBox(height: 8), // Add some spacing
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('TacGia')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        List<DropdownMenuItem<String>> tacgiaItems = [];
                        final tacgias = snapshot.data?.docs.reversed.toList();
                        if (tacgias != null) {
                          for (var tacgia in tacgias) {
                            tacgiaItems.add(
                              DropdownMenuItem(
                                value: tacgia.id,
                                child: Text(tacgia['TenTacGia']),
                              ),
                            );
                          }
                        }
                        return DropdownButton<String>(
                          isExpanded: true,
                          hint: Text("Chọn tác giả"),
                          value: selectedTacGia,
                          items: tacgiaItems,
                          onChanged: (value) {
                            setState(() {
                              selectedTacGia = value;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8), // Add some spacing
                  TextField(
                    controller: giaTien,
                    decoration: const InputDecoration(
                      hintText: 'Giá tiền',
                    ),
                  ),
                  const SizedBox(height: 8), // Add some spacing
                  TextField(
                    controller: ngayXuatBan,
                    decoration: const InputDecoration(
                      hintText: 'Ngày Xuất Bản',
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (docID == null) {
                      // Add
                      FireStoreSach.addSaches(tenSach.text, selectedTacGia!,
                          giaTien.text, ngayXuatBan.text);
                    } else {
                      // Update
                      FireStoreSach.updateSach(docID, tenSach.text,
                          selectedTacGia!, giaTien.text, ngayXuatBan.text);
                    }
                    tenSach.clear();
                    giaTien.clear();
                    ngayXuatBan.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sách"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Sach').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> tenSachList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: tenSachList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = tenSachList[index];
                String docID = documentSnapshot.id;
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                String tenSach = data['TenSach'];
                String giaTien = data['GiaTien'];
                String idTacGia = data['IDTacGia'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('TacGia').doc(idTacGia).get(),
                  builder: (context, authorSnapshot) {
                    if (authorSnapshot.connectionState == ConnectionState.waiting) {
                      return ListBody(
                        mainAxis: Axis.vertical,
                        children: [
                          Text(tenSach),
                          Text(giaTien),
                          Text(idTacGia),
                          CircularProgressIndicator(),
                          IconButton(
                            onPressed: () => openNoteBox(docID: docID),
                            icon: const Icon(Icons.settings),
                          ),
                          IconButton(
                            onPressed: () => FireStoreSach.deleteSach(docID),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      );
                    }
                    if (authorSnapshot.hasError || !authorSnapshot.hasData || !authorSnapshot.data!.exists) {
                      return ListBody(
                        mainAxis: Axis.vertical,
                        children: [
                          Text(tenSach),
                          Text(giaTien),
                          Text(idTacGia),
                          Text('Tác giả không tồn tại'),
                          IconButton(
                            onPressed: () => openNoteBox(docID: docID),
                            icon: const Icon(Icons.settings),
                          ),
                          IconButton(
                            onPressed: () => FireStoreSach.deleteSach(docID),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      );
                    }

                    Map<String, dynamic> authorData = authorSnapshot.data!.data() as Map<String, dynamic>;
                    String tenTacGia = authorData['TenTacGia'];

                    return ListBody(
                      mainAxis: Axis.vertical,
                      children: [
                        Text(tenSach),
                        Text(giaTien),
                        Text(idTacGia),
                        Text(tenTacGia),
                        IconButton(
                          onPressed: () => openNoteBox(docID: docID),
                          icon: const Icon(Icons.settings),
                        ),
                        IconButton(
                          onPressed: () => FireStoreSach.deleteSach(docID),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
