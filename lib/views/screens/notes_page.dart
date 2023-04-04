import 'package:flutter/material.dart';
import '../../global.dart';
import '../../helpar/firebase_db_helper.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  String? title;
  String? notes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = Global.notes["title"];
    notesController.text = Global.notes["notes"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amber,
        actions: [
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
              }
              Map<String, dynamic> recode = {
                "title": title,
                "notes": notes,
              };
              await FirebaseDBHelper.firebaseDBHelper
                  .updateNote(data: recode, id: Global.notes["id"]);
              Navigator.of(context).pop();
              setState(() {
                titleController.clear();
                notesController.clear();
                title = null;
                notes = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Notes update successfully...",
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              "Update",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter The title...";
                  }
                  return null;
                },
                onSaved: (val) {
                  title = val;
                },
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Enter The title...",
                  label: Text("title"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter The body...";
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                maxLines: 5,
                onSaved: (val) {
                  notes = val;
                },
                controller: notesController,
                decoration: const InputDecoration(
                  hintText: "Enter The body...",
                  label: Text("body"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
