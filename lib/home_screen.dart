import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> items = [];

  final key = GlobalKey<AnimatedListState>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(
                    Colors.pink,
                  ),
                  thickness: MaterialStateProperty.all(10),
                  crossAxisMargin: 8,
                  trackColor: MaterialStateProperty.all(Colors.pink.shade200),
                  trackBorderColor: MaterialStateProperty.all(Colors.pink),
                  radius:const Radius.circular(10),
                ),
              ),
              child: Scrollbar(
                controller: scrollController,
                interactive: true,
                trackVisibility: true,
                thumbVisibility: true,
                child: AnimatedList(
                  key: key,
                  controller: scrollController,
                  initialItemCount: items.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                    Animation<double> animation,
                  ) {
                    return ScaleTransition(
                      scale: animation,
                      child: AnimatedListItem(
                        title: items[index],
                        onPress: () {
                          deleteItemFromList(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(8),
            width: double.infinity,
            child: MaterialButton(
              onPressed: addItemToList,
              color: Colors.pink,
              child: const Text(
                'add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteItemFromList(int index) {
    final removedItem = items.removeAt(index);
    key.currentState!.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(1, 0),
            end: const Offset(0, 0),
          ),
        ),
        child: AnimatedListItem(
          title: removedItem,
          onPress: () {},
        ),
      ),
    );
  }

  void addItemToList() {
    var index = items.length;
    items.add('item ${index + 1}');
    key.currentState!.insertItem(index);
    Future.delayed(const Duration(milliseconds: 300), () {
      return scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
}

class AnimatedListItem extends StatelessWidget {
  const AnimatedListItem({
    Key? key,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.pink,
        ),
        title: Text(title),
        subtitle: const Text('subtitle'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onPress,
        ),
      ),
    );
  }
}
