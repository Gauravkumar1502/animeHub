import 'package:animexhub/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _length = 50;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
    _scrollController.addListener(_hideBottomNavigation);
  }

  void _hideBottomNavigation() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isVisible = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isVisible = true;
      });
    }
  }

  _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _length += 50;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 8,
        backgroundColor:
            Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Center(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Item $index'),
              subtitle: Text('Subtitle $index'),
              leading: const Icon(Icons.ac_unit),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            );
          },
        ),
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: _isVisible ? 1 : null,
        tooltip: 'Filter',
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(Icons.filter_alt_sharp),
      ),
      floatingActionButtonLocation:
          _isVisible
              ? FloatingActionButtonLocation.endContained
              : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigation(isVisible: _isVisible),
    );
  }
}
