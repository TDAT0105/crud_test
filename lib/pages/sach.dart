import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_test/services/firestoreSach.dart';
import 'package:crud_test/services/firestoreTacGia.dart';
import 'package:flutter/material.dart';

class SachPage extends StatefulWidget {
  const SachPage({super.key});

  @override
  State<SachPage> createState() => _SachPageState();
}

class _SachPageState extends State<SachPage> {
  final FireStoreSach fireStoreSach = FireStoreSach();

  String? selectedTacGia = "0";

  void openNoteBox({String? docID}) {
    TextEditingController tenSach = TextEditingController();
    TextEditingController idTacGia = TextEditingController();
    TextEditingController giaTien = TextEditingController();
    TextEditingController ngayXuatBan = TextEditingController();

  

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                stream:
                    FirebaseFirestore.instance.collection('TacGia').snapshots(),
                builder: (context, snapshot) {
                  List<DropdownMenuItem> tacgiaItem = [];
                  if (!snapshot.hasData) {
                    const CircularProgressIndicator();
                  } else {
                    final tacgias = snapshot.data?.docs.reversed.toList();
                    tacgiaItem.add(DropdownMenuItem(
                      value: "0",
                      child: Text('Chọn tác giả'),
                      )
                    );
                    
                    for (var tacgia in tacgias!) {
                      tacgiaItem.add(
                        DropdownMenuItem(
                          value: tacgia.id,
                          child: Text(
                            tacgia['TenTacGia'],
                          ),
                        ),
                      );
                    }
                  }
                  return DropdownButton(
                    items: tacgiaItem,
                    onChanged: (tacgiaValue) {
                      setState(() {
                        selectedTacGia = tacgiaValue;
                      });
                      print(tacgiaValue);
                    },
                    value: selectedTacGia,
                    isExpanded: false,
                  );
                }),

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
          // ElevatedButton(
          //   onPressed: () {

          //     if (docID == null) {
          //       fireStoreSach.addSaches(
          //         tenSach.text,
          //         giaTien.text,
          //         ngayXuatBan.text,
          //       );
          //     } else {
          //       fireStoreSach.updateSach(
          //         docID,
          //         tenSach.text,
          //         giaTien.text,
          //         ngayXuatBan.text,
          //       );
          //     }

          //     tenTacGia.clear();
          //     emailTacGia.clear();
          //     sdtTacGia.clear();
          //     Navigator.pop(context);
          //   },
          //   child: const Text('Add'),
          // ),
        ],
      ),
    );
  }

  final FireStoreSach sachService = FireStoreSach();
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
          stream: fireStoreSach.getSaches(),
          builder: (context, snapshot) {
            //if we have data, get all the docs
            if (snapshot.hasData) {
              List tenSachList = snapshot.data!.docs;

              if (tenSachList.isNotEmpty && !snapshot.hasData) {
                return ListView.builder(
                    itemCount: tenSachList.length,
                    itemBuilder: (context, index) {
                      //get each individual doc
                      DocumentSnapshot documentSnapshot = tenSachList[index];
                      String docID = documentSnapshot.id;

                      //get note from each doc
                      Map<String, dynamic> data =
                          documentSnapshot.data() as Map<String, dynamic>;
                      String tenSach = data['TenSach'];

                      //display as a list tile
                      return ListTile(
                        title: Text(tenSach),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //update button
                            IconButton(
                              onPressed: () => openNoteBox(docID: docID),
                              icon: const Icon(Icons.settings),
                            ),

                            //delete button
                            IconButton(
                              onPressed: () => fireStoreSach.deleteSach(docID),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return const Text('No data');
              }
            }
            //if there is no data return nothing
            else {
              return const Text('No data');
            }
          }),
    );
  }
}
