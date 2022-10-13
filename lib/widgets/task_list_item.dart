import 'package:flutter/material.dart';
import 'package:lumos_todo/providers/service_provider.dart';
import 'package:provider/provider.dart';

class TaskListItem extends StatefulWidget {

    late final String id;
    late final bool isDone;
    late final String title;
    late final String subtitle;


    // ignore: prefer_const_constructors_in_immutables
    TaskListItem({
        Key? key,
        required this.id, 
        required this.title,
        required this.subtitle,
        required this.isDone,
    }) : super(key: key);
    
    @override
    // ignore: no_logic_in_create_state
    State<StatefulWidget> createState() => _TaskListItemState(
        id: id,
        title: title, 
        subtitle: subtitle, 
        isDone: isDone
    );

}

class _TaskListItemState extends State<TaskListItem> {

    late final String id;
    late bool isDone;
    late final String title;
    late final String subtitle;


    _TaskListItemState({
        required this.id,
        required this.title,
        required this.subtitle,
        required this.isDone,
    });


    @override
    Widget build(BuildContext context) {

        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: AnimatedContainer(
              width: double.infinity,
              height: MediaQuery.of(context).size.height/8,

              decoration: BoxDecoration(
                  color: isDone ? Colors.green.shade200 : Colors.red.shade200,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        spreadRadius: 0.25,
                        color: Colors.black,blurRadius: 10
                    )
                  ]
              ),

              duration: const Duration(milliseconds: 400),
              child: Row(
                  children: [

                      Expanded(
                          flex: 1,
                          child: Checkbox(
                              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                      // return Colors.green.withOpacity(.32);
                                      return Colors.black.withOpacity(.32);
                                  }
                                  // return Colors.green;
                                  return Colors.black;

                              }),
                              value: isDone, 
                              onChanged: (newValue) {
                                  
                                  isDone = newValue!;
                                  
                                  Provider.of<ServiceProvider>(context, listen: false).changeCheckboxTick(id, newValue);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: newValue ? Colors.green : Colors.red,
                                          content: Text(
                                              newValue ? "Completed '$title' " : "Not Completed: '$title' "
                                          ),
                                          duration: const Duration(seconds: 1),
                                      )
                                  );

                              }   
                          ),
                      ),

                      Expanded(
                          flex: 5,
                          child: Column(
                              children: 
                              
                              [

                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: 
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                // color: Colors.amber,
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Text(
                                                      title,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        overflow: TextOverflow.fade,
                                                        fontSize: MediaQuery.of(context).size.height/20 * 0.70,
                                                        decoration: isDone ? TextDecoration.lineThrough : null
                                                      ),
                                                  ),
                                                )
                                            ),
                                          )
                                      )
                                  ),

                                  subtitle != "" ?     
                                  
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: 
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                alignment: Alignment.centerLeft,
                                                // color: Colors.amber,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Text(
                                                      subtitle,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        overflow: TextOverflow.fade,
                                                        fontSize: MediaQuery.of(context).size.height/20 * 0.5,
                                                        decoration: isDone ? TextDecoration.lineThrough : null
                                                      ),
                                                  ),
                                                )
                                            ),
                                          ),
                                      )
                                  ) 
                                  
                                  : 

                                  const Expanded(
                                      flex: 0,
                                      child: 
                                      SizedBox(
                                          child: null, 
                                          height: 1, 
                                          width: double.infinity
                                      ),
                                  )
                                  
                              ],
                          )
                      ),

                  ]
              ),
          ),
        );


    }

}

