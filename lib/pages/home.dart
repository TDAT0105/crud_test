import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_test/services/firestore.dart';
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
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                //button to save
                ElevatedButton(
                    onPressed: () {
                      //add note
                      if(docID == null)
                      {
                        firestoreService.addNote(textController.text);
                      }
                      //update
                      firestoreService.updateNote(docID!, textController.text);

                      //clear the text controller
                      textController.clear();

                      Navigator.pop(context);
                    },
                    child: const Text('Add')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotes(),
        builder: (context, snapshot) {
          //if we have data, get all the docs
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
              //get each individual doc
                DocumentSnapshot documentSnapshot = notesList[index];
                String docID = documentSnapshot.id;
                //get note from each doc
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                String noteText = data['note'];
                //display as a list tile

                return ListTile(
                  title: Text(noteText),
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
                        onPressed: () => firestoreService.deleteNote(docID),
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
