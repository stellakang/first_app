import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:date_range_form_field/date_range_form_field.dart';

List<Item> todos = List.generate(
  20,
  (i) => Item(
    'Todo $i',
    'A description of what nees to be done for Todo $i',
  ),
);
List<Item> memos = [];
List<Item> routines = [];
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

  const InputTitle({Key? key, required this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
            decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        )));
  }
}

class InputDescription extends StatelessWidget {
  final String labelText;

  const InputDescription({Key? key, required this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
          decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      )),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final String popText;
  final BuildContext context;

  const SubmitButton({Key? key, required this.context, required this.popText})
      : super(key: key);

  void _submitForm() {
    final FormState? form = myFormKey.currentState;
    form!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _submitForm();
          todos.add(Item('a', 'bb'));
          Navigator.pop(context, popText);
        },
        child: const Text('Submit'),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final BuildContext context;

  const CancelButton({Key? key, required this.context})
      : super(key: key);

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

class _RoutineSelectionScreenState extends State<RoutineSelectionScreen> {
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
              const InputTitle(
                labelText: 'Routine name',
              ),
              const InputDescription(labelText: 'Description'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubmitButton(context: context, popText: 'New Routine Added'),
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

class MemoSelectionScreen extends StatefulWidget {
  @override
  _MemoSelectionScreenState createState() => _MemoSelectionScreenState();
}

class _MemoSelectionScreenState extends State<MemoSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: const Text('Write Memo'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const InputTitle(labelText: 'Title'),
              const InputDescription(labelText: 'Notes'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubmitButton(context: context, popText: 'New Memo Added.'),
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
              const InputTitle(
                labelText: 'Todo',
              ),
              const InputDescription(labelText: 'Description'),
              MyFormField(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubmitButton(context: context, popText: 'New Plan Added.'),
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
  ListView todosView = ListView.builder(
    itemCount: todos.length,
    itemBuilder: (context, index) {
      return ListTile(
          title: GestureDetector(
              child: Hero(
                tag: 'backToHome',
                child: Text(todos[index].title),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(item: todos[index]),
                  ),
                );
              }));
    },
  );
  Widget build(BuildContext context) {
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
  ListView routinesView = ListView.builder(
    itemCount: routines.length,
    itemBuilder: (context, index) {
      return ListTile(
          title: GestureDetector(
              child: Hero(
                tag: 'backToHome',
                child: Text(routines[index].title),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(item: routines[index]),
                  ),
                );
              }));
    },
  );
  @override
  Widget build(BuildContext context) {
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

class MemoWidget extends StatefulWidget {
  @override
  _MemoState createState() => _MemoState();
}

class _MemoState extends State<MemoWidget> {
  ListView memosView = ListView.builder(
    itemCount: memos.length,
    itemBuilder: (context, index) {
      return ListTile(
          title: GestureDetector(
              child: Hero(
                tag: 'backToHome',
                child: Text(memos[index].title),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(item: memos[index]),
                  ),
                );
              }));
    },
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.indigo[100],
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: SelectedItem(
                    buttonName: "+ Add Memo",
                    selectionScreen: MemoSelectionScreen(),
                  ))),
              Expanded(child: memosView),
            ]));
  }
}

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
    _pageController = PageController();
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
              children: <Widget>[Home(), Routine(), Report(), MemoWidget()])),
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
              title: const Center(child: Text('Daily Routine')),
              icon: const Icon(Icons.today),
              activeColor: Colors.lightGreen,
              inactiveColor: Colors.grey),
          BottomNavyBarItem(
              title: const Center(child: Text('Report')),
              icon: const Icon(Icons.note),
              activeColor: Colors.orange,
              inactiveColor: Colors.grey),
          BottomNavyBarItem(
              title: const Center(child: Text('Memo')),
              icon: const Icon(Icons.note_add_outlined),
              activeColor: Colors.indigo,
              inactiveColor: Colors.grey),
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
