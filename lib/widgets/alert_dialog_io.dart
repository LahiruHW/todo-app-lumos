import 'package:flutter/material.dart';
import 'package:lumos_todo/providers/service_provider.dart';
import 'package:provider/provider.dart';

class IOAlertDialog extends StatelessWidget {

    late final GlobalKey<FormState> formKey;

    late final TextEditingController controller1 = TextEditingController();
    late final TextEditingController controller2 = TextEditingController();

    IOAlertDialog({
        required this.formKey,
    }){
        controller1.addListener(() { 
            controller1.text;
        });
        controller2.addListener(() { 
            controller2.text;
        });
    }


    @override
    Widget build(BuildContext context) {

        return AlertDialog(

            title: const Text(
                "New Task",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold
                ),
            ),

            content: 
              
              Form(
                  key: formKey,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                          Padding(
                              padding: const EdgeInsets.only( left: 0, right: 0, top: 8.0, bottom: 10 ),
                              child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) {
                                      if (value == null || value.isEmpty) { 
                                          return 'Please enter some text';
                                      }
                                      return null;
                                  },
                                  controller: controller1..text = Provider.of<ServiceProvider>(context).enteredTitle,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.blue.shade100,      
                                      suffix: IconButton(
                                          onPressed: () {
                                              controller1.clear();
                                              Provider.of<ServiceProvider>(context, listen: false).changeEnteredTitle("");
                                          },
                                          icon: const Icon(Icons.clear),
                                      ),                                                                            
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: 'Title',
                                      labelText: 'Title' 
                                  ),
                              ),
                          ),
              
                          Padding(
                              padding: const EdgeInsets.only( left: 0, right: 0, top: 10.0, bottom: 0 ),
                              child: TextField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: controller2..text = Provider.of<ServiceProvider>(context).enteredSubtitle,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.blue.shade100,
                                      suffix: IconButton(
                                          onPressed: () {
                                              controller2.clear();
                                              Provider.of<ServiceProvider>(context, listen: false).changeEnteredSubtitle("");
                                          },
                                          icon: const Icon(Icons.clear),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: 'Subtitle',
                                      labelText: 'Subtitle'
                                  ),
                              ),
                          ),
                      ]
                  ),  
              ),

            actions: [
                ElevatedButton(
                    onPressed: () {
                        Navigator.pop(context);
                    }, 
                    child: const Text("Cancel")
                ),

                ElevatedButton(
                    onPressed: () {    
                        bool state = formKey.currentState!.validate();    
                        if (state){
                            Provider.of<ServiceProvider>(context, listen: false).changeEnteredTitle(controller1.text);
                            Provider.of<ServiceProvider>(context, listen: false).changeEnteredSubtitle(controller2.text);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Added task "${controller1.text}"'),
                                    backgroundColor: Colors.black,
                                ),
                            );
                            Map<String,dynamic> obj = {
                                "title": controller1.text,
                                "subtitle": controller2.text,
                                "done": false
                            };
                          
                            Provider.of<ServiceProvider>(context, listen: false).pushNewTask(obj);
                            Provider.of<ServiceProvider>(context, listen: false).changeEnteredTitle(controller1.text);
                            Provider.of<ServiceProvider>(context, listen: false).changeEnteredSubtitle(controller2.text);
                        }
                        else{
                            print("--------------------- NO DATA WAS SUBMITTED!");
                        }
                    }, 
                    child: const Text("Submit")
                ),
            ]
        );




    }

}