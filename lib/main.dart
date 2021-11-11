
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

List<Todo>todos = [];

void main() {
  runApp(MaterialApp(
    title: 'Todo List',
    home: MyApp(),
  ));
}

class Todo{
  final String title;
  final String description;

  Todo(this.title, this.description);
}

class SelectedButton extends StatelessWidget{
  @override  
  Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: (){
        _navigateAndDisplay(context);
      },
      child: Text('+ Add'),
    );
  }

  _navigateAndDisplay(BuildContext context) async{
    final result = await Navigator.push(  
      context, 
      MaterialPageRoute(builder: (context) => SelectionScreen()),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
  }
}

class SelectionScreen extends StatelessWidget{
  @override  
  Widget build(BuildContext context){
    return Scaffold(  
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Todo',
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    )
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(  
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(  
                    onPressed: (){
                      todos.add(Todo('a', 'bb'));
                      Navigator.pop(context, 'New Plan added');
                    },
                    child: Text('Check'),
                  ),
                ),
                Padding(  
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(  
                    onPressed: (){
                      Navigator.pop(context, 'Canceled');
                    },
                    child: Text('Cancel'),
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ListView todosView = ListView.builder(  
      itemCount: todos.length,
      itemBuilder: (context, index){
        return ListTile(  
          title: Text(todos[index].title),
          onTap: (){
            Navigator.push(  
              context,
              MaterialPageRoute(  
                builder: (context) => DetailScreen(todo: todos[index]),
              ),
            );
          }
        );
      },
    );
    
    return Scaffold(  
        appBar: AppBar(  
          title: Text('Attractive Planner'),
        ),
        body: 
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Center(child: SelectedButton()),
              // Expanded(
              //   child: todosView
              // ),
              MyOutline(),
            ]
          ),
        
    );
  }
}

class MyOutline extends StatefulWidget{
  @override  
  _MyOutlineState createState() => _MyOutlineState(); 
}

class _MyOutlineState extends State<MyOutline>{
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override  
  void initState(){
    super.initState();
    _pageController = PageController();
  }

  @override  
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override  
  Widget build(BuildContext context){
    return Scaffold(  
      appBar: AppBar(title: Text("Attractive planner")),
      body: SizedBox.expand(  
        child: PageView(  
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[ 
            Container(color: Colors.blueGrey,),
            Container(color: Colors.red,),
            Container(color: Colors.green,),
            Container(color: Colors.blue,),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Item One'),
            icon: Icon(Icons.home)
          ),
          BottomNavyBarItem(
            title: Text('Item Two'),
            icon: Icon(Icons.apps)
          ),
          BottomNavyBarItem(
            title: Text('Item Three'),
            icon: Icon(Icons.chat_bubble)
          ),
          BottomNavyBarItem(
            title: Text('Item Four'),
            icon: Icon(Icons.settings)
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget{
  final Todo todo;

  const DetailScreen({Key? key, required this.todo}): super(key: key);

  @override  
  Widget build(BuildContext context){
    return Scaffold(  
      appBar: AppBar(  
        title: Text(todo.title),
      ),
      body: Padding(  
        padding: EdgeInsets.all(16.0),
        child: Text(todo.description),
      ),
    );
  }
}

