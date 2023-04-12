import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocous = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _formData = Map<String, Object>();
  @override
  void dispose() {
    super.dispose();
    _priceFocous.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductList>(context, listen: false)
        .saveProduct(_formData)
        .then((value) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de produtos'),
        actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['name']?.toString(),
                        decoration: InputDecoration(labelText: 'Nome'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocous);
                        },
                        onSaved: (name) => _formData['name'] = name ?? '',
                        validator: (_name) {
                          final name = _name ?? '';
                          if (name.trim().isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          if (name.trim().length < 3) {
                            return 'Nome precisa no mínimo 3 letras.';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price']?.toString(),
                        decoration: InputDecoration(labelText: 'Preço'),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocous,
                        onSaved: (price) =>
                            _formData['price'] = double.parse(price ?? '0'),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        validator: (_price) {
                          final priceString = _price ?? '';
                          final price = double.tryParse(priceString) ?? -1;

                          if (price <= 0) {
                            return 'Informe um preço válido';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['description']?.toString(),
                        decoration: InputDecoration(labelText: 'Descrição'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        onSaved: (description) =>
                            _formData['description'] = description ?? '',
                        maxLines: 3,
                        focusNode: _descriptionFocus,
                        validator: (_description) {
                          final description = _description ?? '';
                          if (description.trim().isEmpty) {
                            return 'Descrição é obrigatório';
                          }
                          if (description.trim().length < 10) {
                            return 'Nome precisa no mínimo 10 letras.';
                          }

                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Url da imagem'),
                              onSaved: (imageurl) =>
                                  _formData['imageUrl'] = imageurl ?? '',
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocus,
                              controller: _imageUrlController,
                              onFieldSubmitted: (value) => _submitForm(),
                              validator: (_imageUrl) {
                                final imageUrl = _imageUrl ?? '';
                                if (!isValidImageUrl(imageUrl)) {
                                  return 'Informe uma Url válida';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 10, left: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? Text('Informe a URL')
                                : Image.network(_imageUrlController.text),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
