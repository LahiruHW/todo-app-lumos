import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

/// Used as a wrapper for the [DocumentSnapshot] class 
/// and provides a single access point for the data in the Firestore Database.
/// Also used as a way to avoid making models for each collection in the database.
class ServiceProvider extends ChangeNotifier{
    
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection("todolist");

    int index = 0;
    String enteredTitle = "";
    String enteredSubtitle = "";
    // List<Task> taskList = [];

    void changePageIndex(int newIndex){
      index = newIndex;
      notifyListeners();
    }

    void changeEnteredTitle(String newStr){
      // print("============================ CHANGED TITLE FROM '$enteredTitle' TO '$newStr'");
      enteredTitle = newStr;
      notifyListeners();
    }

    void changeEnteredSubtitle(String newStr) {
        // print("============================ CHANGED TITLE FROM '$enteredSubtitle' TO '$newStr'");
        enteredSubtitle = newStr;
        notifyListeners();
    }

    /// Pushes a new task to the Firestore database, and updates the current list
    Future<void> pushNewTask(Map<String, dynamic> newTask) async {
        collectionRef.add(newTask);
        // print("============================ PUSHED NEW DATA TO FIRESTORE");
        // getTasks();
        notifyListeners();
    }
    
    /// Deletes all the items in the list that are required to get th 
    void deleteAllTasks() async {
        var snapshots = await collectionRef.get();
        for (var doc in snapshots.docs){
            await doc.reference.delete();
        }
        // print("============================ DELETED ALL TASKS FROM FIRESTORE DATABASE");
        notifyListeners();
    }

    /// get the tick status of the current string
    Future<bool> getTickStatus(String id) async {
        bool val = false;
        var x = await collectionRef.doc(id).get().then(
            (value) => val = value['done']
        );
        return val;
    
    }

    Future<void> changeCheckboxTick(String id, bool newVal) async {
        collectionRef.doc(id).update({"done": newVal});
        // print("============================ CHANGED CHECKBOX TICK OF TASK WITH ID: $id");
        notifyListeners();
    }


    // Stream<List<Task>> retrieveTasks(){
    //     return collectionRef
    //     // .orderBy() here!!
    //     .snapshots()
    //     .map( (snapshot) => snapshot.docs
    //         .map((e) => Task( done: e['done'], title: e['title'], subtitle: e['subtitle']))
    //         .toList() 
    //     );
    // }

    // void getTasks() async {
    //     var allDocs = await collectionRef.get();
    //     taskList = allDocs.docs.map((e) {            
    //           print("${e.reference.id} ----------- ${e['done']} ----------- ${e['title']} --------- ${e['subtitle']}");
    //           return Task(
    //               id: e.reference.id,
    //               done: e['done'], 
    //               title: e['title'], 
    //               subtitle: e['subtitle']
    //           );
    //         }
    //     ).toList();
    //     print(taskList);
    //     print("============================ UPDATED TASK LIST");
    //     notifyListeners();
    // }


}