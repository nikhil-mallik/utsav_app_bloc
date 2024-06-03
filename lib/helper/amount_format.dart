class AmountFormat {
  // Function to format the amount based on its amount
  static String formatAmount(int amount) {
    if ((amount >= 1000 && amount < 100000) ||
        (amount <= -1000 && amount > -100000)) {
      // Format amount in thousands
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else if ((amount >= 100000 && amount < 1000000000) ||
        (amount <= -100000 && amount > -1000000000)) {
      // Format amount in millions
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if ((amount >= 1000000000 && amount < 1000000000000) ||
        (amount <= -1000000000 && amount > -1000000000000)) {
      // Format amount in billions
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else {
      // Return the amount as it is
      return amount.toString();
    }
  }
}
