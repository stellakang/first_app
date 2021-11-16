import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:date_range_form_field/date_range_form_field.dart';

GlobalKey<FormState> myFormKey = GlobalKey();

void main() {
  runApp(MaterialApp(
    title: 'Todo List',
    home: MyApp(),
  ));
}

class Item {
  final String title;
  final String description;

  Item(this.title, this.description);
}

class TodoList with ChangeNotifier {
  List<List> todos = [];
  void add(String title, String description, String date) {
    todos.add([title, description, date]);
    notifyListeners();
  }

  List<List> getTodo() {
    return todos;
  }
}

class RoutineList with ChangeNotifier {
  List<Item> routines = [];
  void add(String title, String description) {
    routines.add(Item(title = title, description = description));
    notifyListeners();
  }

  List<Item> getRoutine() {
    return routines;
  }
}

class SelectedItem extends StatelessWidget {
  final String buttonName;
  final Widget selectionScreen;

  const SelectedItem(
      {Key? key, required this.buttonName, required this.selectionScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateAndDisplay(context);
      },
      child: Text(buttonName),
    );
  }

  _navigateAndDisplay(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => selectionScreen),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
  }
}

DateTimeRange? myDateRange;

class InputTitle extends StatelessWidget {
  final String labelText;
  final textController;
  InputTitle({Key? key, required this.labelText, required this.textController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
            controller: textController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: labelText,
            )));
  }
}

class InputDescription extends StatelessWidget {
  final String labelText;
  final textController;
  const InputDescription({Key? key, required this.labelText, required this.textController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
          controller: textController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
          )),
    );
  }
}

class TodoSubmitButton extends StatelessWidget {
  final titleController;
  final descController;
  final dateController;
  final String popText;
  final BuildContext context;

  TodoSubmitButton(
      {Key? key, required this.context, required this.popText, required this.titleController, required this.descController, required this.dateController})
      : super(key: key);

  void _submitForm() {
    final FormState? form = myFormKey.currentState;
    form!.save();
  }

  @override
  Widget build(BuildContext context) {
    TodoList todos = Provider.of<TodoList>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _submitForm();
          todos.add(titleController.text, descController.text, dateController.text);
          Navigator.pop(context, popText);
        },
        child: const Text('Submit'),
      ),
    );
  }
}

class RoutineSubmitButton extends StatelessWidget {
  final titleController;
  final descController;
  final String description = "";
  final String popText;
  final BuildContext context;

  const RoutineSubmitButton(
      {Key? key, required this.context, required this.popText, required this.titleController, required this.descController})
      : super(key: key);

  void _submitForm() {
    final FormState? form = myFormKey.currentState;
    form!.save();
  }

  @override
  Widget build(BuildContext context) {
    RoutineList routines = Provider.of<RoutineList>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _submitForm();
          Navigator.pop(context, popText);
          routines.add(titleController.text, descController.text);
        },
        child: const Text('Submit'),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final BuildContext context;

  const CancelButton({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, 'Canceled');
        },
        child: const Text('Cancel'),
      ),
    );
  }
}

class MyFormField extends StatefulWidget {
  @override
  _MyFormFieldState createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: myFormKey,
        child: SafeArea(
            child: DateRangeField(
                enabled: true,
                initialValue:
                    DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Data Range',
                  prefixIcon: Icon(Icons.date_range),
                  hintText: 'Please select a start and end date',
                ),
                validator: (value) {
                  if (value!.start.isBefore(DateTime.now())) {
                    return 'Please enter a valid date';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    myDateRange = value;
                  });
                })));
  }
}

class RoutineSelectionScreen extends StatefulWidget {
  @override
  _RoutineSelectionScreenState createState() => _RoutineSelectionScreenState();
}

final routineTitleController = TextEditingController();
final routineDescController = TextEditingController();

class _RoutineSelectionScreenState extends State<RoutineSelectionScreen> {
  final textTitle = InputTitle(
    labelText: 'Routine name',
    textController: routineTitleController,
  );
  final textDesc = InputDescription(labelText: 'Description', textController: routineDescController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: const Text('Add Routine'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textTitle,
              textDesc,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoutineSubmitButton(
                      context: context, popText: 'New Routine Added', titleController: routineTitleController, descController: routineDescController,),
                  CancelButton(context: context),
                ],
              ),
            ],
          ),
        ],
      )),
    );
  }
}

// class MemoSelectionScreen extends StatefulWidget {
//   @override
//   _MemoSelectionScreenState createState() => _MemoSelectionScreenState();
// }

// class _MemoSelectionScreenState extends State<MemoSelectionScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.indigo[100],
//       appBar: AppBar(
//         title: const Text('Write Memo'),
//       ),
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const InputTitle(labelText: 'Title'),
//               const InputDescription(labelText: 'Notes'),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SubmitButton(context: context, popText: 'New Memo Added.'),
//                   CancelButton(context: context),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       )),
//     );
//   }
// }

final todoTitleController = TextEditingController();
final todoDescController = TextEditingController();
final todoDateController = TextEditingController();

class TodoSelectionScreen extends StatefulWidget {
  @override
  _TodoSelectionScreenState createState() => _TodoSelectionScreenState();
}

class _TodoSelectionScreenState extends State<TodoSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[100],
      appBar: AppBar(
        title: Text('Add todo item'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputTitle(
                labelText: 'Todo',
                textController: todoTitleController,
              ),
              InputDescription(labelText: 'Description', textController: todoDescController,),
              MyFormField(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TodoSubmitButton(
                      context: context, popText: 'New Plan Added.', titleController: todoTitleController, descController: todoDescController, dateController: todoDateController,),
                  CancelButton(context: context),
                ],
              ),
              if (myDateRange != null)
                Text('Saved value is: ${myDateRange.toString()}')
            ],
          ),
        ],
      )),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget build(BuildContext context) {
    TodoList todos = Provider.of<TodoList>(context);
    List<List> todoList = todos.getTodo();
    ListView todosView = ListView.builder(
      itemCount: todos.getTodo().length,
      itemBuilder: (context, index) {
        return ListTile(
            title: GestureDetector(
                child: Hero(
                  tag: 'backToHome',
                  child: Text(todoList[index][0]),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                          item: Item(todoList[index][0], todoList[index][1])),
                    ),
                  );
                }));
      },
    );
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: SelectedItem(
                buttonName: "+ Add Todo List",
                selectionScreen: TodoSelectionScreen(),
              ))),
          Expanded(child: todosView),
        ]);
  }
}

class Routine extends StatefulWidget {
  @override
  _RoutineState createState() => _RoutineState();
}

class _RoutineState extends State<Routine> {
  @override
  Widget build(BuildContext context) {
    RoutineList routines = Provider.of<RoutineList>(context);
    List<Item> routineList = routines.getRoutine();

    ListView routinesView = ListView.builder(
      itemCount: routineList.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: GestureDetector(
                child: Hero(
                  tag: 'backToHome',
                  child: Text(routineList[index].title),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(item: routineList[index]),
                    ),
                  );
                }));
      },
    );
    return Container(
        color: Colors.lightGreen[100],
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: SelectedItem(
                  buttonName: "+ Add New Routine",
                  selectionScreen: RoutineSelectionScreen(),
                ))),
            Expanded(child: routinesView),
            // ListView(
            //   children: [

            //   ],
            // ),
          ],
        ));
  }
}

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.orange[100]);
  }
}

// class MemoWidget extends StatefulWidget {
//   @override
//   _MemoState createState() => _MemoState();
// }

// class _MemoState extends State<MemoWidget> {
//   ListView memosView = ListView.builder(
//     itemCount: memos.length,
//     itemBuilder: (context, index) {
//       return ListTile(
//           title: GestureDetector(
//               child: Hero(
//                 tag: 'backToHome',
//                 child: Text(memos[index].title),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DetailScreen(item: memos[index]),
//                   ),
//                 );
//               }));
//     },
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.indigo[100],
//         child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                       child: SelectedItem(
//                     buttonName: "+ Add Memo",
//                     selectionScreen: MemoSelectionScreen(),
//                   ))),
//               Expanded(child: memosView),
//             ]));
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  // This widget is the root of your application
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    if (_pageController == null) {
      _pageController = PageController();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[100],
      appBar: AppBar(
        title: const Center(
          child: Text('Planner'),
        ),
        backgroundColor: Colors.grey[700],
      ),
      body: SizedBox.expand(
          child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: <Widget>[Home(), Routine(), Report()])),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: const Center(child: Text('Todo list')),
            icon: const Icon(Icons.home),
            activeColor: Colors.deepOrange,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
              title: const Center(child: Text('Routine')),
              icon: const Icon(Icons.today),
              activeColor: Colors.lightGreen,
              inactiveColor: Colors.grey),
          BottomNavyBarItem(
              title: const Center(child: Text('Calendar')),
              icon: const Icon(Icons.note),
              activeColor: Colors.orange,
              inactiveColor: Colors.grey),
          // BottomNavyBarItem(
          //     title: const Center(child: Text('Memo')),
          //     icon: const Icon(Icons.note_add_outlined),
          //     activeColor: Colors.indigo,
          //     inactiveColor: Colors.grey),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Item item;

  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Hero(
            tag: 'backToHome',
            child: Scaffold(
              appBar: AppBar(
                title: Text(item.title),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(item.description),
              ),
            )));
  }
}
