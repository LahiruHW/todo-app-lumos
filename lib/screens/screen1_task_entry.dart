import 'package:flutter/material.dart';
import 'package:lumos_todo/providers/service_provider.dart';
import 'package:provider/provider.dart';


class TaskEntryView extends StatefulWidget {
    const TaskEntryView({Key? key}) : super(key: key);

    @override
    State<TaskEntryView> createState() => _TaskEntryViewState();
}

class _TaskEntryViewState extends State<TaskEntryView> {
  
    late final TextEditingController _controller1 = TextEditingController();
    late final TextEditingController _controller2 = TextEditingController();
    final _formKey = GlobalKey<FormState>();


    @override
    void initState() {
        super.initState();

        _controller1.addListener(() { 
            _controller1.text;
        });

        _controller2.addListener(() { 
            _controller2.text;
        });

    }

    @override
    void dispose() {
        _controller1.dispose();
        _controller2.dispose();
        super.dispose();
    }
    
    @override
    Widget build(BuildContext context) {
      
        return Scaffold( 

            body: Form(

                key: _formKey,

                child: SingleChildScrollView(
                  child: Column(
                    
                      children:  [
                
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  "Enter your to-do",
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold
                                  ),
                              ),
                          ),
                              
                          Padding(
                              padding: const EdgeInsets.only( left: 10, right: 10, top: 8.0, bottom: 8.0 ),
                              child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) {
                                      if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                      }
                                      return null;
                                  },
                                  controller: _controller1..text = Provider.of<ServiceProvider>(context).enteredTitle,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.blue.shade100,
                                      suffix: IconButton(
                                          onPressed: () {
                                              _controller1.clear();
                                              Provider.of<ServiceProvider>(context, listen: false).changeEnteredTitle("");
                                          },
                                          icon: const Icon(Icons.clear),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: 'Title',
                                      labelText: 'Title',
                                  ),
                              ),
                          ),
                              
                          Padding(
                              padding: const EdgeInsets.only( left: 10, right: 10, top: 8.0, bottom: 8.0 ),
                              child: TextField(
                                  
                                  autocorrect: false,
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: _controller2..text = Provider.of<ServiceProvider>(context).enteredSubtitle,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.blue.shade100,
                                      suffix: IconButton(
                                          onPressed: () {
                                              _controller2.clear();
                                              Provider.of<ServiceProvider>(context, listen: false).changeEnteredSubtitle("");
                                          },
                                          icon: const Icon(Icons.clear),
                                      ),
                                      border: OutlineInputBorder(
                                          // borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: 'Subtitle',
                                      labelText: 'Subtitle',
                                  ),
                              ),
                          ),
                              
                              
                          ElevatedButton(
                              
                              onPressed: () {
                              
                                  bool state = _formKey.currentState!.validate();
                                  
                                  if (state){
                
                                      Provider.of<ServiceProvider>(context, listen: false).changeEnteredTitle(_controller1.text);
                                      Provider.of<ServiceProvider>(context, listen: false).changeEnteredSubtitle(_controller2.text);
                
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text('Added task "${_controller1.text}"'),
                                              backgroundColor: Colors.black,
                                          ),
                                      );
                
                                      /////////////////////////////////////////// SAVE TASK TO A LIST IN STATE HERE
                
                                      Map<String,dynamic> obj = {
                                          "title": _controller1.text,
                                          "subtitle": _controller2.text,
                                          "done": false
                                      };
                                     
                                      Provider.of<ServiceProvider>(context, listen: false).pushNewTask(obj);
                                      Provider.of<ServiceProvider>(context, listen: false).changeEnteredTitle(_controller1.text);
                                      Provider.of<ServiceProvider>(context, listen: false).changeEnteredSubtitle(_controller2.text);
                
                                  }
                                  // else{
                                  //     print("--------------------- NO DATA WAS SUBMITTED!");
                                  // }
                
                              }, 
                              child: const Text("Submit")
                          ),
                
                      ]
                  ),
                ),
            )
        );


    }
}
