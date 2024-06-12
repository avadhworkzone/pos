import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/ProductsData.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/restapi/sales/model/NewSaleRequest.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_pos/AppPreference.dart';
import 'package:jakel_pos/modules/newsale/NewSaleViewModel.dart';
import 'package:jakel_pos/modules/products/ProductsViewModel.dart';
import 'package:easy_debounce/easy_debounce.dart';

import '../dialog/show_product_batch_dialog.dart';

class NewSaleSearchWidget extends StatefulWidget {
  final Function onProductSelected;

  const NewSaleSearchWidget({Key? key, required this.onProductSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewSaleSearchWidgetState();
  }
}

class _NewSaleSearchWidgetState extends State<NewSaleSearchWidget> {
  final viewModel = NewSaleViewModel();
  final productsViewModel = ProductsViewModel();
  final searchController = TextEditingController();
  final FocusNode searchNode = FocusNode();
  String? searchText;
  List<ProductsData>? allLists;
  List<ProductsData>? filteredLists;
  List<Products>? allProductsList;
  bool isBach = false;

  @override
  void initState() {
    super.initState();
    _onTextSearched();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(flex: 3, child: getAllProductsList()),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Theme.of(context).dividerColor)),
      height: 50,
      child: Row(
        children: [
          refreshItemList(),
          startSearchWidget(),
          Expanded(
            child: TextField(
              key: widget.key,
              controller: searchController,
              focusNode: searchNode,
              onSubmitted: (value) {
                // In some cases of barcode scanning, both onSubmit & onChanged is getting called.
                // setState(() {
                //   searchText = value;
                // });
              },
              onChanged: (value) {
                isBach = false;
                EasyDebounce.debounce(
                    'search-debouncer', const Duration(milliseconds: 500), () {
                  MyLogUtils.logDebug("search-debouncer value : $value");
                  _onTextEntered(value);
                });
              },
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.0, color: Colors.transparent),
                ),
                fillColor: getWhiteColor(context),
                hintText: 'Search or scan item or enter upc ...',
                hintStyle: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
          Container(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
          Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  border: Border.all(
                      width: 0.1, color: Theme.of(context).dividerColor)),
              child: InkWell(
                child: Icon(
                  Icons.clear,
                  color: Theme.of(context).indicatorColor,
                ),
                onTap: () {
                  setState(() {
                    searchText = '';
                    searchController.text = '';
                  });
                },
              ))
        ],
      ),
    );
  }

  void _onTextEntered(String value) {
    if (value.isEmpty) {
      setState(() {
        searchText = '';
      });
    } else {
      setState(() {
        searchText = value;
      });
    }
  }

  Widget refreshItemList() {
    return Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
            color: Theme.of(context).colorScheme.tertiaryContainer,
            border:
                Border.all(width: 0.1, color: Theme.of(context).dividerColor)),
        child: InkWell(
          child: Icon(
            Icons.refresh,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () {
            setState(() {
              searchController.text = "";
              searchText = null;
              allProductsList = null;
            });
          },
        ));
  }

  Widget startSearchWidget() {
    return Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            border:
                Border.all(width: 0.1, color: Theme.of(context).dividerColor)),
        child: InkWell(
          child: Icon(
            Icons.search,
            color: Theme.of(context).indicatorColor,
          ),
          onTap: () {
            setState(() {
              searchText = searchController.text;
            });
          },
        ));
  }

  Widget getAllProductsList() {
    MyLogUtils.logDebug(
        "getAllProductsList refreshProductsData: ${AppPreference().refreshProductsData}");

    if (AppPreference().refreshProductsData) {
      AppPreference().refreshProductsData = false;
      return getAllProductsApiWidget();
    }
    if (allProductsList != null) {
      AppPreference().refreshProductsData = false;
      return searchWidgetWithList();
    }

    return getAllProductsApiWidget();
  }

  FutureBuilder<List<Products>> getAllProductsApiWidget() {
    return FutureBuilder(
        future: productsViewModel.getAllProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Products>?> snapshot) {
          if (snapshot.hasData) {
            allProductsList = snapshot.data;
            return searchWidgetWithList();
          }
          return const SizedBox(
            height: 50,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("  Loading ..."),
            ),
          );
        });
  }

  Widget searchWidgetWithList() {
    return IntrinsicHeight(
      child: Column(
        children: [searchWidget(), getSearchedItemsWidget()],
      ),
    );
  }

  Widget getSearchedItemsWidget() {
    //When no items are searched
    if (searchText == null || searchText!.isEmpty) {
      return const SizedBox(
        height: 9,
      );
    }

    return AnimatedContainer(
        height: 400,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 1),
        child: searchingWidget());
  }

  Widget searchedItemsListWidget() {
    if (filteredLists == null || filteredLists!.isEmpty) {
      return const NoDataWidget();
    }

    if (filteredLists!.length == 1 && !isBach) {
      if (productsViewModel.isUpcOrEanMatching(
          filteredLists!.first, searchText)) {
        onWidgetsLoaded(filteredLists!.first);
      }
    }

    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).dividerColor,
            ),
        shrinkWrap: true,
        itemCount: filteredLists!.length,
        itemBuilder: (context, index) {
          return searchedItemRowWidget(filteredLists![index], index);
        });
  }

  Widget searchingWidget() {
    return FutureBuilder(
        future: productsViewModel.filterList(allProductsList ?? [], searchText),
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductsData>?> snapshot) {
          if (snapshot.hasData) {
            filteredLists = snapshot.data;
            if (filteredLists != null && filteredLists!.length > 200) {
              filteredLists = filteredLists?.sublist(0, 200);
            }
            return searchedItemsListWidget();
          }
          return const Text("Loading ...");
        });
  }

  Widget searchedItemRowWidget(ProductsData productData, int index) {
    return InkWell(
      onTap: () {
        onProductSelected(productData);
      },
      child: Row(
        children: [
          Text(
            '${index + 1}. ',
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${productData.getProductName()} (${productData.product?.id}) (${productData.product?.articleNumber ?? ''})',
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Flexible(
                        child: RichText(
                      text: TextSpan(
                          text: "${productData.product!.upc}",
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: " ${productData.product!.ean}",
                            ),
                            TextSpan(
                              text: productData.product!.color == null
                                  ? ""
                                  : " ${productData.getProductColor()}",
                            ),
                            TextSpan(
                              text: productData.product!.size == null
                                  ? ""
                                  : " ${productData.getProductSize()}",
                            ),
                            TextSpan(
                              text: productData.product!.style == null
                                  ? ""
                                  : " ${productData.getProductStyle()}",
                            ),
                            TextSpan(
                              text: productData.product!.brand == null
                                  ? ""
                                  : " ${productData.getProductBrand()}",
                            ),
                          ]),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.pushNamed(context, PRODUCT_SOH_ROUTE,
                        //     arguments: product);
                      },
                      child: const Icon(
                        Icons.remove_red_eye_outlined,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
          ),
          Text(getOnlyReadableAmount(productData.getProductPrice())),
        ],
      ),
    );
  }

  void onProductSelected(ProductsData productData) {
    if (productData.product?.hasBatch != null &&
        productData.product?.hasBatch == true) {
      _showBatchProductsDialog(productData);
      isBach = true;
    } else {
      _onProductSelected(productData, null, null);
    }
  }

  void _onTextSearched() {
    // searchController.addListener(() {
    //   setState(() {
    //     searchText = searchController.text;
    //   });
    // });
  }

  void _showBatchProductsDialog(ProductsData product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ShowProductBatchDialog(
          productsData: product,
          onBatchSelected: (batch, bachExpiryDate) {
            isBach = false;
            _onProductSelected(product, batch, bachExpiryDate);
          },
        );
      },
    );
  }

  void _onProductSelected(
      ProductsData product, String? batch, String? bachExpiryDate) {
    MyLogUtils.logDebug("ProductsData hasBatch : ${product.product?.hasBatch}");

    FocusScope.of(context).requestFocus(searchNode);
    searchController.text = "";
    CartItem cartItem = CartItem();
    if (batch != null && batch.isNotEmpty) {
      cartItem.batchNumber = batch;
      cartItem.batchDetails = [];
      if (bachExpiryDate != null && bachExpiryDate.isNotEmpty) {
        cartItem.batchDetails?.add(BatchDetails(
            batchNumber: batch, quantity: 1, batchExpiryDate: bachExpiryDate));
      } else {
        cartItem.batchDetails
            ?.add(BatchDetails(batchNumber: batch, quantity: 1));
      }
    }
    cartItem.product = product.product;
    cartItem.derivatives = product.derivatives;
    cartItem.unitOfMeasures = product.unitOfMeasures;
    cartItem.taxPercentage = product.taxPercentage;
    cartItem.qty = 1;
    searchText = null;
    widget.onProductSelected(cartItem);
  }

  void onWidgetsLoaded(ProductsData product) async {
    MyLogUtils.logDebug('onWidgetsLoaded');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onProductSelected(product);
    });
  }
}