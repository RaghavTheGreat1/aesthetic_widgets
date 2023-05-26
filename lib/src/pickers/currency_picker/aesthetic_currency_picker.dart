import 'package:flutter/material.dart';

import 'currency_menu.dart';
import 'models/currency.dart';
import 'utils/currency_utils.dart';

export 'models/currency.dart';

class AestheticCurrencyPicker extends StatefulWidget {
  const AestheticCurrencyPicker({
    super.key,
    required this.initialCurrency,
    required this.onSelected,
  });

  final Currency initialCurrency;
  final ValueChanged<Currency> onSelected;

  @override
  State<AestheticCurrencyPicker> createState() =>
      _AestheticCurrencyPickerState();
}

class _AestheticCurrencyPickerState extends State<AestheticCurrencyPicker> {
  late Currency selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.initialCurrency;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Text(CurrencyUtils.currencyToEmoji(selectedCountry)),
      label: Text(selectedCountry.name),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(21),
              topRight: Radius.circular(21),
            ),
          ),
          builder: (context) => CurrencyMenu(
            onSelected: (Currency country) {
              setState(() {
                selectedCountry = country;
              });
              widget.onSelected(selectedCountry);
            },
          ),
        );
        widget.onSelected(selectedCountry);
      },
    );
  }
}
