enum Currency {
  inr('INR', '₹'),
  usd('USD', '\$'),
  eur('EUR', '€'),
  gbp('GBP', '£');

  final String code;
  final String symbol;

  const Currency(this.code, this.symbol);
}
