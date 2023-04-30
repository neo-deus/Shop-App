import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import './edit_product_screen.dart';

// class UserProductsScreen extends StatelessWidget {
//   static const routeName = '/user-products';

//   Future<void> _refreshProduct(BuildContext context) async {
//     await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productsData = Provider.of<Products>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Products'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).pushNamed(EditProductScreen.routeName);
//             },
//             icon: Icon(Icons.add),
//           ),
//         ],
//       ),
//       drawer: AppDrawer(),
//       body: RefreshIndicator(
//         onRefresh: () => _refreshProduct(context),
//         child: Padding(
//           padding: EdgeInsets.all(8),
//           child: ListView.builder(
//             itemBuilder: (_, index) => Column(
//               children: [
//                 UserProductItem(
//                   productsData.items[index].id,
//                   productsData.items[index].title,
//                   productsData.items[index].imageUrl,
//                 ),
//                 Divider(),
//               ],
//             ),
//             itemCount: productsData.items.length,
//           ),
//         ),
//       ),
//     );
//   }
// }

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  bool _isLoading = true;

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }

  @override
  void initState() {
    super.initState();
    // Set _isLoading to true when the screen is first displayed
    // and fetch the products data
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct()
        .then((_) => setState(() {
              _isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          // If products data is still loading, display a progress indicator
          ? Center(
              child: CircularProgressIndicator(),
            )
          // Otherwise, display the product items and a RefreshIndicator widget
          : productsData.items.isEmpty
              ? Center(
                  child: Text('No products found.'),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProduct(context),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemBuilder: (_, index) => Column(
                        children: [
                          UserProductItem(
                            productsData.items[index].id,
                            productsData.items[index].title,
                            productsData.items[index].imageUrl,
                          ),
                          Divider(),
                        ],
                      ),
                      itemCount: productsData.items.length,
                    ),
                  ),
                ),
    );
  }
}
