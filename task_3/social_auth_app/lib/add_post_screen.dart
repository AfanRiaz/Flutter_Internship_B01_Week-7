import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}
class _AddPostScreenState extends State<AddPostScreen> {
  bool loading=false;
  final databaseRef=FirebaseDatabase.instance.ref('Post');
  final postController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              maxLines: 5,
              controller: postController,
              decoration: InputDecoration(
                hintText: "What's in your mind?",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0,right: 12,top: 12,bottom: 12),
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                    onPressed: (){
                    setState(() {

                    });
                    if(postController.text.isEmpty){
                      Fluttertoast.showToast(msg: "Field is empty",gravity: ToastGravity.BOTTOM);
                    }
                    else{
                      try{
                        loading = true;
                        String id=DateTime.now().millisecondsSinceEpoch.toString();
                        databaseRef.child(id).set({
                          'id': id,
                          'title': postController.text
                        }).then((value) {
                          Fluttertoast.showToast(
                              msg: "post added", gravity: ToastGravity.BOTTOM);
                          setState(() {
                            loading = false;
                          });
                        }).onError((error, StackTrace) {
                          Fluttertoast.showToast(msg: error.toString(),
                              gravity: ToastGravity.BOTTOM);
                          setState(() {
                            loading = false;
                          });
                        });
                      }
                      catch(e){
                        Fluttertoast.showToast(msg: e.toString());
                      }
                      finally{
                        setState(() {
                          loading=false;
                        });
                      }
                    }
                    postController.clear();
                },
                    child: loading ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ) : Text("Add")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
