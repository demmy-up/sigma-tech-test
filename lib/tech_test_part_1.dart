void main() {
  final result = cashWithdraw(360000) ?? 'Nominal tidak valid';
  print(result);
  final findPairTrans = findTransactionPair([25000, 10000, 25000, 40000], 50000);
  print(findPairTrans);
}


Map<int, int>? cashWithdraw(int amount) {
  if (amount <= 0) return null;
  final denom100k = 100000;
  final denom50k = 50000;
  final denom20k = 20000;
  for (int count100k = amount ~/ denom100k; count100k >= 0; count100k--) {
    final remaining = amount - (count100k * denom100k);
    for (int count50k = remaining ~/ denom50k; count50k >= 0; count50k-- ) {
      final remainder = remaining - (count50k * denom50k);
      if (remainder % denom20k == 0) {
        final count20k = remainder ~/ denom20k;
        return {
          denom100k: count100k,
          denom50k : count50k,
          denom20k : count20k
        };
      }
    }
  }
  return null;
}


List<int> findTransactionPair(List<int> transactions, int targetRefund) {
  Map<int, int> tempTransactions = {};
  for (int i = 0; i < transactions.length; i++) {
    final currentAmount = transactions[i];
    final pair = targetRefund - currentAmount;

    if (tempTransactions.containsKey(pair)) {
      return [tempTransactions[pair]!, i];
    }
    tempTransactions[currentAmount] = i;
  }
  return [];
}
