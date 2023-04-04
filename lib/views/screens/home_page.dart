import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/helpar/firebase_db_helper.dart';
import 'package:keep_notes/model/notes.dart';
import '../../global.dart';
import '../../helpar/firebase_auth_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  TextEditingController titleUpDateController = TextEditingController();
  TextEditingController notesUpDateController = TextEditingController();

  String? title;
  String? notes;

  @override
  Widget build(BuildContext context) {
    Massage data = ModalRoute.of(context)!.settings.arguments as Massage;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Notes",
          style: TextStyle(color: Colors.orange),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.logout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login_page', (route) => false);
            },
          ),
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(data.user.photoURL ?? ""),
                ),
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
              ),
              Text(
                " ${data.user.displayName}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                " ${data.user.email}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("keep").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot<Map<String, dynamic>> data =
                  snapshot.data as QuerySnapshot<Map<String, dynamic>>;

              List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                  data.docs;

              return ListView.builder(
                itemCount: allDocs.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/notes_page");
                        Map data = {
                          "id": allDocs[i].id,
                          "title": allDocs[i].data()["title"],
                          "notes": allDocs[i].data()['notes'],
                        };
                        Global.notes = data;
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white.withOpacity(0.6),
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            "${allDocs[i].data()['title']}",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${allDocs[i].data()['notes']}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              FirebaseDBHelper.firebaseDBHelper
                                  .deleteNote(id: allDocs[i].id);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "Add",
          style: TextStyle(color: Colors.cyan),
        ),
        icon: const Icon(Icons.add, color: Colors.cyan),
        onPressed: () async {
          addNotes(context);
        },
        backgroundColor: Colors.white,
      ),
    );
  }

  dynamic addNotes(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notes"),
          content: SizedBox(
            height: 300,
            width: 250,
            child: Form(
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
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                }

                Map<String, dynamic> recode = {
                  "title": title,
                  "notes": notes,
                };

                await FirebaseDBHelper.firebaseDBHelper
                    .insertNote(data: recode);

                setState(() {
                  Navigator.pop(context);

                  titleController.clear();
                  notesController.clear();

                  title = null;
                  notes = null;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Recode inserted successfully..."),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Insert"),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
