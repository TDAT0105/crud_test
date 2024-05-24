import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_test/services/firestoreTacGia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();
  
  

void openNoteBox({String? docID}) {
  TextEditingController tenTacGia = TextEditingController();
  TextEditingController emailTacGia = TextEditingController();
  TextEditingController sdtTacGia = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: tenTacGia,
            decoration: const InputDecoration(
              hintText: 'Tên Tác Giả',
            ),
          ),
          const SizedBox(height: 8), // Add some spacing
          TextField(
            controller: emailTacGia,
            decoration: const InputDecoration(
              hintText: 'Email Tác Giả',
            ),
          ),
          const SizedBox(height: 8), // Add some spacing
          TextField(
            controller: sdtTacGia,
            decoration: const InputDecoration(
              hintText: 'Số điện thoại Tác Giả',
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
           
            if (docID == null) {
              firestoreService.addTacgias(
                tenTacGia.text,
                emailTacGia.text,
                sdtTacGia.text,
              );
            } else {
              firestoreService.updateTacGia(
                docID,
                tenTacGia.text,
                emailTacGia.text,
                sdtTacGia.text,
              );
            }

           
            tenTacGia.clear();
            emailTacGia.clear();
            sdtTacGia.clear();
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tác Giả"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTacGias(),
        builder: (context, snapshot) {
          //if we have data, get all the docs
          if (snapshot.hasData) {
            List tacgiaList = snapshot.data!.docs;
            print(snapshot.hasData);
            print(tacgiaList.length);
            return ListView.builder(
              
              itemCount: tacgiaList.length,
              itemBuilder: (context, index) {

              //get each individual doc
                DocumentSnapshot documentSnapshot = tacgiaList[index];
                String docID = documentSnapshot.id;

                //get note from each doc
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                String tacgia = data['TenTacGia'];   
                           
                //display as a list tile
                return ListTile(
                  title: Text(tacgia),
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
                        onPressed: () => firestoreService.deleteTacGia(docID),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
             }
            );
          }
          //if there is no data return nothing
          else{
           
            return const Text('No data');
          }
        }
      ),
    );
  }
}
