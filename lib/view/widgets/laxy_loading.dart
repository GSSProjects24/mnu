import 'package:flutter/material.dart';

class LazyListView extends StatefulWidget {
  @override
  _LazyListViewState createState() => _LazyListViewState();
}

class _LazyListViewState extends State<LazyListView> {
  //list of items
  final List<String> items = List<String>.generate(30, (i) => "Item $i");
  //flag to check if loading
  bool isLoading = false;
  //flag to check if all items loaded
  bool isAllLoaded = false;

  ScrollController controller=ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        if (index >= items.length) {
          return _buildLoader();
        } else {
          return _buildItem(items[index]);
        }
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: items.length + 1,
      controller: controller
        ..addListener(() {
          if (controller.position.pixels == controller.position.maxScrollExtent) {
            _loadMore();
          }
        }),
    );
  }

  Widget _buildLoader() {
    return isLoading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Center(
      child: isAllLoaded
          ? Text("All items loaded")
          : Text("Reached end of list"),
    );
  }

  Widget _buildItem(String item) {
    return ListTile(
      title: Text(item),
    );
  }

  _loadMore() {
    if (!isLoading && !isAllLoaded) {
      setState(() {
        isLoading = true;
      });
      //simulate loading more items
      Future.delayed(Duration(seconds: 2), () {
        if (items.length < 50) {
          setState(() {
            items.addAll(List<String>.generate(10, (i) => "Item ${items.length + i}"));
            isLoading = false;
          });
        } else {
          setState(() {
            isAllLoaded = true;
            isLoading = false;
          });
        }
      });
    }
  }
}

