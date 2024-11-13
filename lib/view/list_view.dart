import 'package:flutter/material.dart';
import 'package:integrade/provider/itemProvider.dart';
import 'package:provider/provider.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ItemProvider>(context, listen: false);
    provider.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Lista Dinâmica")),
          body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!provider.isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                provider.fetchItems();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: provider.items.length + (provider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.items.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final item = provider.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(
                          height: 4), // Espaçamento entre título e subtítulo
                      Text(
                        item['body'],
                        maxLines: 2, // Limita a 2 linhas
                        overflow: TextOverflow
                            .ellipsis, // Mostra "..." se o texto for longo
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const Divider(), // Linha divisória entre itens
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
