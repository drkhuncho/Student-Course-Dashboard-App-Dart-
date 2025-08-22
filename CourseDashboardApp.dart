import 'package:flutter/material.dart';

void main() {
  runApp(const CourseDashboardApp());
}

class CourseDashboardApp extends StatelessWidget {
  const CourseDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  bool _isExpanded = false; // For animated button
  String _selectedCategory = "Science"; // For dropdown

  // Dummy course list
  final List<Map<String, String>> courses = [
    {"name": "Mathematics", "instructor": "Dr. Smith"},
    {"name": "Physics", "instructor": "Prof. Johnson"},
    {"name": "Computer Science", "instructor": "Dr. Williams"},
    {"name": "Literature", "instructor": "Prof. Brown"},
    {"name": "History", "instructor": "Dr. Taylor"},
  ];

  // Navigation bar items
  static const List<String> _tabNames = ["Home", "Courses", "Profile"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Exit confirmation dialog
  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to exit the app?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // No
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Yes
            child: const Text("Yes"),
          ),
        ],
      ),
    ).then((exit) {
      if (exit == true) {
        // Close the app
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    // Tab content switcher
    if (_selectedIndex == 1) {
      bodyContent = Column(
        children: [
          // Dropdown for course categories
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              items: const [
                DropdownMenuItem(value: "Science", child: Text("Science")),
                DropdownMenuItem(value: "Arts", child: Text("Arts")),
                DropdownMenuItem(value: "Technology", child: Text("Technology")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          Text("Selected Category: $_selectedCategory"),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(courses[index]["name"]!),
                  subtitle: Text("Instructor: ${courses[index]["instructor"]}"),
                );
              },
            ),
          ),
        ],
      );
    } else if (_selectedIndex == 2) {
      bodyContent = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile Page"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showExitDialog,
              child: const Text("Logout"),
            ),
          ],
        ),
      );
    } else {
      bodyContent = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to ${_tabNames[_selectedIndex]}",
                style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            // Animated Button
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: _isExpanded ? 200 : 120,
                height: _isExpanded ? 60 : 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Enroll in a Course",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Course Dashboard")),
      body: bodyContent,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Courses"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}