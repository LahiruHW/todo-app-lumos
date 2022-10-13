import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumos_todo/widgets/alert_dialog_io.dart';
import 'package:lumos_todo/widgets/task_list_item.dart';
import 'package:lumos_todo/providers/service_provider.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatefulWidget {
    const TaskListView({Key? key}) : super(key: key);
    @override
    State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {

    late final TextEditingController _controller1 = TextEditingController();
    late final TextEditingController _controller2 = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    @override
    void initState() {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        _controller1.addListener(() { 
            _controller1.text;
        });
        _controller2.addListener(() { 
            _controller2.text;
        });
        super.initState();
    }

    @override
    void dispose() {
        _controller1.dispose();
        _controller2.dispose();
        super.dispose();
    }

    /// creates the alert dialog that's used to add new tasks in the list-page
    Widget createDialog(BuildContext context){
        return IOAlertDialog(
            formKey: _formKey, 
        );
    }

    @override
    Widget build(BuildContext context) {

        return Scaffold(

            body: StreamBuilder(  
                stream: Provider.of<ServiceProvider>(context).collectionRef.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> streamsnapshot){
                    if (streamsnapshot.hasData && streamsnapshot.data!.docs.isNotEmpty){    
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: streamsnapshot.data!.docs.length,
                            itemBuilder: (context, index){ 
                                final DocumentSnapshot docSnap = streamsnapshot.data!.docs[index];
                                return TaskListItem(
                                    id: docSnap.reference.id,
                                    title: docSnap['title'], 
                                    subtitle: docSnap['subtitle'], 
                                    isDone: docSnap['done']
                                );
                            }
                        );
                    }
                    return const Center(
                        child: 
                        // CircularProgressIndicator(color: Colors.black, ), 
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                                "You don't have any tasks right now.\n\nPress the + button to add one!",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                            ),
                        )
                    );
                }
            ),

            floatingActionButton: FloatingActionButton(
                onPressed: () {
                        showDialog(
                            context: context, 
                            builder: createDialog
                        );                        
                },                     
                child: const Icon(Icons.add),
            ),

        ); 
        
    }

}