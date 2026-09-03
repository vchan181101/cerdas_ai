import 'package:flutter/material.dart';
import '../../values/strings.dart';

class CustomSearchDelegate extends SearchDelegate<String?> {
  final List<String> searchDataList;

  CustomSearchDelegate({required this.searchDataList});

  @override
  String get searchFieldLabel => AppStrings.hintPencarian;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  // Menampilkan hasil setelah tombol "Search" ditekan (setara performSearch)
  @override
  Widget buildResults(BuildContext context) {
    final results = searchDataList
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.searchResultPrefix}"$query"',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('Tidak ada hasil ditemukan'))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.history_outlined),
                        title: Text(results[index]),
                        onTap: () => close(context, results[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Menampilkan rekomendasi kata kunci saat mengetik
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = searchDataList
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
