import 'package:flutter/material.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';

class MyPaginationWidget extends StatefulWidget {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int totalPages;
  final int totalCount;
  final Function onPageSelected;

  const MyPaginationWidget(
      {Key? key,
      required this.currentPage,
      required this.lastPage,
      required this.perPage,
      required this.totalPages,
      required this.totalCount,
      required this.onPageSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyPaginationState();
  }
}

class _MyPaginationState extends State<MyPaginationWidget> {
  int currentPage = 0;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentPage = widget.currentPage;
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);

    getPageRowWidget(widgets);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: RichText(
              text: TextSpan(
                text: "Showing page ",
                style: Theme.of(context).textTheme.bodyMedium,
                children: <TextSpan>[
                  TextSpan(
                    text: '$currentPage',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: ' of ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: '${widget.totalPages}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 40,
            width: 250,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  IconButton(
                    iconSize: 25.0,
                    onPressed: () {
                      if (widget.currentPage > 1) {
                        setState(() {
                          currentPage = widget.currentPage - 1;
                          widget.onPageSelected(currentPage);
                        });
                      }
                    },
                    icon: Icon(Icons.chevron_left_outlined,
                        color: (widget.currentPage > 1)
                            ? Colors.black45
                            : Colors.grey),
                  ),
                  Expanded(
                    child: pagesWidget(widgets),
                  ),
                  IconButton(
                    iconSize: 25.0,
                    onPressed: () {
                      if (widget.lastPage > widget.currentPage) {
                        setState(() {
                          currentPage = widget.currentPage + 1;
                          widget.onPageSelected(currentPage);
                        });
                      }
                    },
                    icon: Icon(Icons.chevron_right_outlined,
                        color: (widget.currentPage <= widget.lastPage)
                            ? Colors.black45
                            : Colors.grey),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void getPageRowWidget(List<Widget> widgets) {
    if (widget.totalPages > 100) {
      return;
    }
    for (int i = 1; i <= widget.totalPages; i++) {
      widgets.add(InkWell(
        onTap: () {
          setState(() {
            currentPage = i;
            widget.onPageSelected(i);
          });
        },
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: currentPage == i
                  ? Theme.of(context).primaryColor
                  : getWhiteColor(context)),
          padding: const EdgeInsets.all(2),
          child: Center(
            child: currentPage == i
                ? Text(
                    "$i",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: getWhiteColor(context), fontSize: 14),
                  )
                : Text(
                    "$i",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
          ),
        ),
      ));
    }
  }

  Widget pagesWidget(List<Widget> widgets) {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets),
    );
  }
}
