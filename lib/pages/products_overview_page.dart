import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

enum FilterOptions { favoritos, todos }

class ProductsOverViewPage extends StatefulWidget {
  ProductsOverViewPage({super.key});

  @override
  State<ProductsOverViewPage> createState() => _ProductsOverViewPageState();
}

class _ProductsOverViewPageState extends State<ProductsOverViewPage> {
  bool _showFavorityOnly = false;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Somente favoritos'),
                value: FilterOptions.favoritos,
              ),
              const PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.todos,
              ),
            ],
            onSelected: (FilterOptions selectedVlaue) {
              setState(() {
                if (selectedVlaue == FilterOptions.favoritos) {
                  _showFavorityOnly = true;
                } else {
                  _showFavorityOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
              icon: Icon(Icons.shopping_cart),
            ),
            builder: (context, cart, child) => Badgee(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),

          // Consumer<Cart>(
          //   builder: (context, cart, child) => Badge(
          //     textStyle: TextStyle(
          //       fontSize: 10,
          //       color: Theme.of(context).accentColor,
          //     ),
          //     label: Text(cart.itemsCount.toString()),
          //     child: IconButton(
          //       onPressed: () {},
          //       icon: Icon(Icons.shopping_cart),
          //     ),
          //     alignment: AlignmentDirectional.centerStart,
          //   ),
          // )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavoriteOnly: _showFavorityOnly),
      drawer: AppDrawer(),
    );
  }
}
