import 'package:flutter/material.dart';

class SearchableDropdownExample extends StatefulWidget {
  const SearchableDropdownExample({super.key});

  @override
  State createState() => _SearchableDropdownExampleState();
}

class _SearchableDropdownExampleState extends State<SearchableDropdownExample> {
  List<String> _items = [];
  List<String> _filteredItems = [];
  String? _selectedItem;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _controller.addListener(() {
      _filterItems(_controller.text);
    });
  }

  // Simulate an async API call to fetch items
  Future<void> _loadItems() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate delay
    List<String> fetchedItems = [
      'Apple',
      'Banana',
      'Orange',
      'Pineapple',
      'Mango'
    ];
    setState(() {
      _items = fetchedItems;
      _filteredItems = fetchedItems; // Initially show all items
    });
  }

  // Filter the items based on the search query
  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = _items;
      });
    } else {
      setState(() {
        _filteredItems = _items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search input field
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),

          // Dropdown Button
          if (_items.isEmpty) // Show a loading indicator until data is fetched
            Center(child: CircularProgressIndicator())
          else
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Select an item'),
              value: _selectedItem,
              items: _filteredItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedItem = value;
                });
              },
            ),

          // Display selected item
          if (_selectedItem != null)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Selected Item: $_selectedItem',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
