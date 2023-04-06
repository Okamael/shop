import 'package:flutter/material.dart';
import 'package:shop/components/product_grid.dart';

enum FilterOptions { favoritos, todos }

class ProductsOverViewPage extends StatefulWidget {
  ProductsOverViewPage({super.key});

  @override
  State<ProductsOverViewPage> createState() => _ProductsOverViewPageState();
}

class _ProductsOverViewPageState extends State<ProductsOverViewPage> {
  bool _showFavorityOnly = false;
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
        ],
      ),
      body: ProductGrid(showFavoriteOnly: _showFavorityOnly),
    );
  }
}
