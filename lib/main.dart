import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumos_todo/screens/screen1_task_entry.dart';
import 'package:lumos_todo/screens/screen2_task_list.dart';
import 'package:lumos_todo/providers/service_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(
        ChangeNotifierProvider(
            create: (_) => ServiceProvider(),
            child: const MyApp(),
        )
    );
}

/// The class that defines the appbar and its acompanying icons, 
/// which persists across different pages
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

    @override
    State<StatefulWidget> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin{
  
    int _index = 0; 
    final PageController _pageController = PageController(initialPage: 0);
    late final AnimationController _animController;
    late final Animation<Color?> _animation;
    final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  
    _MyAppState({
        Key? key
    });

    @override
    void initState() {

        // animation controller for animating the appbar color
        _animController = AnimationController(
            duration: const Duration(milliseconds: 300), 
            reverseDuration: const Duration(milliseconds: 300), 
            vsync: this
        );
        _animation = ColorTween(
            begin: Colors.blue, 
            end: Colors.green)
        .animate(_animController)
        ..addListener(() { 
            setState(() {});
        });
        super.initState();
    }

    @override
    void dispose() {
        _animController.dispose();
        _pageController.dispose();
        super.dispose();
    }

    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        
        // getting the current index you are on
        _index = Provider.of<ServiceProvider>(context, listen: true).index;
        
        return MaterialApp(
            scaffoldMessengerKey: _messengerKey,
            title: 'Flutter Demo',
            
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),

            // ignore: prefer_const_constructors
            home: Scaffold(
                appBar: AppBar(
                    leading:   _index == 1 ? IconButton(
                        icon: const Icon(Icons.sort),
                        tooltip: 'Sort',
                        onPressed: () {
                            // Provider.of<ServiceProvider>(context, listen: false).sort();   // not implemented yet
                        },
                    ) : null,
                    title: AnimatedCrossFade(
                        firstChild: Text("To-do Entry", style: GoogleFonts.abel(fontSize: 30),),
                        secondChild: Text("To-do Checklist", style: GoogleFonts.abel(fontSize: 30),),
                        crossFadeState: _index == 0 ?  CrossFadeState.showFirst : CrossFadeState.showSecond  , 
                        duration: const Duration(milliseconds: 500),
                        reverseDuration: const Duration(milliseconds: 500),
                    ),
                    // Text(
                    //     _index == 0 ? "To-do Entry" : "To-do Checklist",
                    //     style: GoogleFonts.abel(fontSize: 30),
                    // ),
                    centerTitle: true,
                    backgroundColor:  _animation.value,
                    actionsIconTheme: const IconThemeData.fallback(),
                    actions: _index == 1 ? [
                        IconButton(
                            onPressed: () {
                                Provider.of<ServiceProvider>(context, listen: false).deleteAllTasks();
                                _messengerKey.currentState!.showSnackBar(
                                    const SnackBar(
                                        content: Text('All tasks deleted!'),
                                        backgroundColor: Colors.red,
                                    ),
                                );
                            }, 
                            icon: const Icon(Icons.delete, color: Colors.red,)
                        )
                    ] : null,
                ),

                body: PageView(
                    controller: _pageController,
                    onPageChanged: (newIndex){
                        Provider.of<ServiceProvider>(context, listen: false).changePageIndex(newIndex);
                        newIndex == 0 ? _animController.reverse() : _animController.forward();
                    },
                    children: const [
                        TaskEntryView(),   //////////////////////////////////////////////// the two pages you swipe in between
                        TaskListView()
                    ],
                ),

                bottomNavigationBar: BottomNavigationBar(
                    elevation: 20,
                    type: BottomNavigationBarType.fixed,
                    selectedFontSize: 20,
                    selectedItemColor: Colors.black,
                    backgroundColor:  _animation.value,
                    selectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500
                    ),
                    items: const [

                        BottomNavigationBarItem(
                            icon: Icon(Icons.input_outlined),
                            label: "Entry",
                        ),

                        BottomNavigationBarItem(
                            icon: Icon(Icons.list_alt_outlined),
                            label: "List",
                        )

                    ],

                    currentIndex: _index,
                    onTap: (newIndex) {
                        _index = newIndex;
                        _pageController.animateToPage(
                            newIndex, 
                            duration: const Duration(milliseconds: 300), 
                            curve: Curves.linear
                        );
                        Provider.of<ServiceProvider>(context).changePageIndex(newIndex);
                    },

                ),

            ),

        );
    }
}


