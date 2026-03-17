import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_auth_app/add_post_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ref=FirebaseDatabase.instance.ref('Post');
  final searchController =TextEditingController();
  final editController = TextEditingController();
  Future<void> updateDialogue(String title, String id) async{
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Update"),
            content: TextFormField(
                controller: editController,
                decoration: InputDecoration(
                  hintText: "Edit",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    ref.child(id).update({
                      'title' : editController.text.toLowerCase()
                    }
                    ).then((value) {
                      Fluttertoast.showToast(msg: "Updated successfully");
                    }
                    ).onError((error, StackTrace){
                      Fluttertoast.showToast(msg: "Can't update value");
                    }

                    );
                  },
                  child: Text("Update"))
            ],

          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post App"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              onChanged: (String value){
                setState(() {

                });
              },
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),

              ),
            ),
          ),
          // Expanded(
          // child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {
          //
          //       if(!snapshot.hasData){
          //        return Center(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               CircularProgressIndicator()
          //             ],
          //           ),
          //         );
          //       }
          //       if(snapshot.data!.snapshot.value == null){
          //         return Text("No data");
          //       }
          //       Map<dynamic, dynamic> map=snapshot.data!.snapshot.value as dynamic;
          //       List<dynamic> list = [];
          //       list.clear();
          //       list=map.values.toList();
          //        return ListView.builder(
          //             itemCount: snapshot.data!.snapshot.children.length,
          //             itemBuilder: (context, index){
          //               return ListTile(
          //                 title: Text(list[index]['title']),
          //                 subtitle: Text(list[index]['id'].toString()),
          //               );
          //             });
          //       }
          //     ),
          // ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index){
                  final title = snapshot.child('title').value.toString();
                  if(searchController.text.isEmpty){
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    updateDialogue(title, snapshot.child('id').value.toString());
                                  },
                                  leading: Icon(Icons.edit_outlined),
                                  title: Text("Edit"),
                                )
                            ),
                            PopupMenuItem(
                                value: 1,
                                onTap: (){
                                  ref.child(snapshot.child('id').value.toString()).remove().then((onValue){
                                    Fluttertoast.showToast(msg: "Deleted Successfully");
                                  }).onError((error, StackTrace){
                                    Fluttertoast.showToast(msg: "Error Occurred");
                                  });
                                },
                                child: ListTile(
                                  leading: Icon(Icons.delete_outlined),
                                  title: Text("Delete"),
                                )
                            )
                          ]
                      )
                    );
                  }
                  else if(snapshot.child('title').value.toString().toLowerCase().contains(searchController.text.toLowerCase().toLowerCase())){
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  }
                  else{
                    return Container();
                  }

                }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return AddPostScreen();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}