import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/provider/places.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  late Future _placeFuture;
  var listData = [];
  var nextPageToken = '';
  var loading = false;
  var error = false;

  Future _obtainPlaceFuture() {
    return Provider.of<Places>(context, listen: false).fetchShopList();
  }

  Future<void> onRefresh() {
    return Provider.of<Places>(context, listen: false).fetchShopList();
  }

  void handleScrolling() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {}
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _placeFuture = _obtainPlaceFuture();
    _scrollController = ScrollController()..addListener(handleScrolling);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final placeData = Provider.of<Places>(context);
    final list = placeData.items;
    final loading = placeData.loading;
    return FutureBuilder(
      future: _placeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return SafeArea(
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxScrolled) => [
              SliverAppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 80,
                floating: true,
                pinned: true,
                title: TextFieldContainer(
                  key: UniqueKey(),
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (value) => {placeData.queryText(value)},
                    decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: "Search for something?",
                        border: InputBorder.none),
                  ),
                ),
              ),
            ],
            body: RefreshIndicator(
              onRefresh: onRefresh,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          style: ListTileStyle.list,
                          key: UniqueKey(),
                          leading: CircleAvatar(
                            backgroundColor: list[index].iconBgColor.toColor(),
                            child: Image.network(
                              list[index].icon,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          title: Text(
                            list[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Prompt',
                            ),
                          ),
                          subtitle: Text(
                            list[index].address,
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Prompt',
                            ),
                          ),
                        );
                      },
                      itemCount: list.length,
                    ),
            ),
          ),
        );
      },
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    required Key key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: kInputColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
