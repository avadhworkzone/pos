import 'package:flutter/material.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';

class MultiSelectWidget<T> extends StatefulWidget {
  final List<T> data;
  final List<T> selected;
  final String? searchHint;
  final Function(List<T>) onDataSelected;
  final Function getValue;
  final Function getKey;

  const MultiSelectWidget(
      {Key? key,
      required this.data,
      required this.selected,
      this.searchHint,
      required this.onDataSelected,
      required this.getValue,
      required this.getKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MultiSelectWidgetState();
  }
}

class _MultiSelectWidgetState<T> extends State<MultiSelectWidget<T>> {
  final textController = TextEditingController();
  final node = FocusNode();
  String searchText = "";
  List<T> selectedList = [];

  @override
  void initState() {
    super.initState();

    for (var element in widget.data) {
      for (var selectedElement in widget.selected) {
        if (widget.getKey(selectedElement) == (widget.getKey(element))) {
          selectedList.add(element);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor)),
      height: 400,
      child: Column(
        children: [
          MyTextFieldWidget(
              controller: textController,
              node: node,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              hint: widget.searchHint ?? 'Search'),
          Expanded(
              child: Container(
            color: Theme.of(context).dividerColor,
            constraints: const BoxConstraints.expand(),
            child: getListWidget(),
          )),
        ],
      ),
    );
  }

  Widget getListWidget() {
    List<dynamic> filtered = List.empty(growable: true);

    for (var element in widget.data) {
      if (searchText.isEmpty ||
          (widget.getValue(element) as String)
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
        filtered.add(element);
      }
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          return listRowWidget(filtered[index]);
        });
  }

  Widget listRowWidget(dynamic data) {
    return InkWell(
      onTap: () {
        setState(() {
          if (checkIfAlreadySelected(data)) {
            selectedList = removeAlreadySelected(data);
          } else {
            selectedList.add(data);
          }
          widget.onDataSelected(selectedList);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: checkIfAlreadySelected(data)
                ? Colors.lightGreen.shade300
                : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        child: Text(widget.getValue(data)),
      ),
    );
  }

  bool checkIfAlreadySelected(dynamic data) {
    bool result = false;
    for (var element in selectedList) {
      if (widget.getKey(data) == widget.getKey(element)) {
        result = true;
      }
    }
    return result;
  }

  List<T> removeAlreadySelected(dynamic data) {
    List<T> updated = List.empty(growable: true);
    for (var element in selectedList) {
      if (widget.getKey(data) != widget.getKey(element)) {
        updated.add(element);
      }
    }
    return updated;
  }
}
