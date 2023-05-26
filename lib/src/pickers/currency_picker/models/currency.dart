// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Currency {
  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
    required this.number,
    required this.decimalDigits,
    required this.namePlural,
    required this.decimalSeparator,
    required this.thousandsSeparator,
    required this.symbolOnLeft,
    required this.spaceBetweenAmountAndSymbol,
  });

  ///The currency code
  final String code;

  ///The currency name in English
  final String name;

  ///The currency symbol
  final String symbol;

  ///The currency flag code
  ///
  /// To get flag unicode(Emoji) use [CurrencyUtils.currencyToEmoji]
  final String flag;

  ///The currency number
  final int number;

  ///The currency decimal digits
  final int decimalDigits;

  ///The currency plural name in English
  final String namePlural;

  ///The decimal separator
  final String decimalSeparator;

  ///The thousands separator
  final String thousandsSeparator;

  ///True if symbol is on the Left of the amount
  final bool symbolOnLeft;

  ///True if symbol has space with amount
  final bool spaceBetweenAmountAndSymbol;

  static const Map<String, dynamic> defaultCurrency = {
    "code": "INR",
    "name": "Indian Rupee",
    "symbol": "₹",
    "flag": "INR",
    "decimalDigits": 2,
    "number": 356,
    "namePlural": "Indian rupees",
    "thousandsSeparator": ",",
    "decimalSeparator": ".",
    "spaceBetweenAmountAndSymbol": false,
    "symbolOnLeft": true,
  };

  factory Currency.inr() {
    return Currency.fromMap(
      {
        "code": "INR",
        "name": "Indian Rupee",
        "symbol": "₹",
        "flag": "INR",
        "decimalDigits": 2,
        "number": 356,
        "namePlural": "Indian rupees",
        "thousandsSeparator": ",",
        "decimalSeparator": ".",
        "spaceBetweenAmountAndSymbol": false,
        "symbolOnLeft": true,
      },
    );
  }

  Currency copyWith({
    String? code,
    String? name,
    String? symbol,
    String? flag,
    int? number,
    int? decimalDigits,
    String? namePlural,
    String? decimalSeparator,
    String? thousandsSeparator,
    bool? symbolOnLeft,
    bool? spaceBetweenAmountAndSymbol,
  }) {
    return Currency(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      flag: flag ?? this.flag,
      number: number ?? this.number,
      decimalDigits: decimalDigits ?? this.decimalDigits,
      namePlural: namePlural ?? this.namePlural,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      thousandsSeparator: thousandsSeparator ?? this.thousandsSeparator,
      symbolOnLeft: symbolOnLeft ?? this.symbolOnLeft,
      spaceBetweenAmountAndSymbol:
          spaceBetweenAmountAndSymbol ?? this.spaceBetweenAmountAndSymbol,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'name': name,
      'symbol': symbol,
      'flag': flag,
      'number': number,
      'decimalDigits': decimalDigits,
      'namePlural': namePlural,
      'decimalSeparator': decimalSeparator,
      'thousandsSeparator': thousandsSeparator,
      'symbolOnLeft': symbolOnLeft,
      'spaceBetweenAmountAndSymbol': spaceBetweenAmountAndSymbol,
    };
  }

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      code: map['code'] as String,
      name: map['name'] as String,
      symbol: map['symbol'] as String,
      flag: map['flag'] as String,
      number: map['number'] as int,
      decimalDigits: map['decimalDigits'] as int,
      namePlural: map['namePlural'] as String,
      decimalSeparator: map['decimalSeparator'] as String,
      thousandsSeparator: map['thousandsSeparator'] as String,
      symbolOnLeft: map['symbolOnLeft'] as bool,
      spaceBetweenAmountAndSymbol: map['spaceBetweenAmountAndSymbol'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Currency.fromJson(String source) =>
      Currency.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Currency(code: $code, name: $name, symbol: $symbol, flag: $flag, number: $number, decimalDigits: $decimalDigits, namePlural: $namePlural, decimalSeparator: $decimalSeparator, thousandsSeparator: $thousandsSeparator, symbolOnLeft: $symbolOnLeft, spaceBetweenAmountAndSymbol: $spaceBetweenAmountAndSymbol)';
  }

  @override
  bool operator ==(covariant Currency other) {
    if (identical(this, other)) return true;

    return other.code == code &&
        other.name == name &&
        other.symbol == symbol &&
        other.flag == flag &&
        other.number == number &&
        other.decimalDigits == decimalDigits &&
        other.namePlural == namePlural &&
        other.decimalSeparator == decimalSeparator &&
        other.thousandsSeparator == thousandsSeparator &&
        other.symbolOnLeft == symbolOnLeft &&
        other.spaceBetweenAmountAndSymbol == spaceBetweenAmountAndSymbol;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        name.hashCode ^
        symbol.hashCode ^
        flag.hashCode ^
        number.hashCode ^
        decimalDigits.hashCode ^
        namePlural.hashCode ^
        decimalSeparator.hashCode ^
        thousandsSeparator.hashCode ^
        symbolOnLeft.hashCode ^
        spaceBetweenAmountAndSymbol.hashCode;
  }
}
