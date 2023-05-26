import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import 'models/currency.dart';
import 'resources/currencies.dart';
import 'utils/currency_utils.dart';

class CurrencyMenu extends StatefulWidget {
  const CurrencyMenu({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  final ValueChanged<Currency> onSelected;

  @override
  State<CurrencyMenu> createState() => _CurrencyMenuState();
}

class _CurrencyMenuState extends State<CurrencyMenu> {
  List<Map<String, dynamic>> _currencyFilterList = [];
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.9,
      initialChildSize: 0.9,
      minChildSize: 0.8,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: "Try searching 'Indian Rupee'",
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  UniconsLine.search,
                ),
              ),
              onChanged: _filterSearchResults,
            ),
            Divider(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  _currencyFilterList.isEmpty
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return CurrencyListTile(
                                currency: Currency.fromMap(currencies[index]),
                                onChanged: widget.onSelected,
                              );
                            },
                            childCount: currencies.length,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return CurrencyListTile(
                                currency: Currency.fromMap(
                                    _currencyFilterList[index]),
                                onChanged: widget.onSelected,
                              );
                            },
                            childCount: _currencyFilterList.length,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterSearchResults(String query) {
    List<Map<String, dynamic>> searchResult = <Map<String, dynamic>>[];

    if (query.isEmpty) {
      searchResult = [];
    } else {
      searchResult = currencies
          .where((c) =>
              c['name'].toLowerCase().contains(query.toLowerCase()) ||
              c['code'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() => _currencyFilterList = searchResult);
  }
}

class CurrencyListTile extends StatelessWidget {
  const CurrencyListTile({
    Key? key,
    required this.currency,
    required this.onChanged,
  }) : super(key: key);

  final Currency currency;
  final ValueChanged<Currency> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      // Add Material Widget with transparent color
      // so the ripple effect of InkWell will show on tap
      color: Colors.transparent,
      child: InkWell(
        splashColor:
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        highlightColor: Colors.transparent,
        onTap: () async {
          onChanged(currency);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 9.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Text(
                      CurrencyUtils.currencyToEmoji(currency),
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currency.code,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            currency.name,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  currency.symbol,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
