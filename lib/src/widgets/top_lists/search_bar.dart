import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BottomSearchBar extends StatefulWidget {
  const BottomSearchBar({
    super.key,
    required this.searchList,
    required this.itemScrollController,
  });
  final List<dynamic> searchList;
  final ItemScrollController itemScrollController;

  @override
  State<BottomSearchBar> createState() => _BottomSearchBarState();
}

class _BottomSearchBarState extends State<BottomSearchBar> {
  String _searchText = '';
  int _currentIndex = 0;
  List<int> indexes = [];

  getIndexes(String value) {
    widget.searchList.forEach((element) {
      if (element.toString().toLowerCase().startsWith(value.toLowerCase())) {
        indexes.add(widget.searchList.indexWhere((item) => item == element));
      }
    });
  }

  scrollTo(int index) {
    widget.itemScrollController.scrollTo(
        index: index,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOutCubic);
  }

  search(String value) {
    if (value.isNotEmpty) {
      print('searching for $value');
      setState(() {
        indexes.clear();
        getIndexes(value);
      });
      if (indexes.isNotEmpty) {
        scrollTo(indexes[_currentIndex]);
      }
    }
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: _controller,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none),
              filled: true,
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchText.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (_currentIndex > 0) {
                                scrollTo(indexes[_currentIndex - 1]);
                                setState(() {
                                  _currentIndex--;
                                });
                              }
                            },
                            icon: Icon(Icons.expand_less)),
                        IconButton(
                            onPressed: () {
                              if (_currentIndex < indexes.length - 1) {
                                scrollTo(indexes[_currentIndex + 1]);
                                setState(() {
                                  _currentIndex++;
                                });
                              }
                            },
                            icon: Icon(Icons.expand_more)),
                        indexes.length > 0
                            ? Text('${_currentIndex + 1} of ${indexes.length}')
                            : Text('No results'),
                        IconButton(
                          onPressed: () => {
                            setState(() {
                              _searchText = '';
                              _currentIndex = 0;
                              indexes.clear();
                              _controller.clear();
                            })
                          },
                          icon: Icon(Icons.clear),
                        ),
                      ],
                    )
                  : null,
              constraints: BoxConstraints(maxHeight: 65),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  _searchText = '';
                  _currentIndex = 0;
                  indexes.clear();
                });
              } else {
                setState(() => _searchText = value);
                search(value);
              }
            },
          )),
          IconButton(
              onPressed: () => print('TODO: Implement sort functionality'),
              icon: Icon(Icons.sort))
        ],
      ),
    );
  }
}
