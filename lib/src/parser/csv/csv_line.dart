
class CsvLine {
  final DateTime date;
  final String description;
  final double amount;

  const CsvLine({required this.date, required this.description, required this.amount});

  @override
  String toString() => 'CsvLine(${date.year}-${date.month}-${date.day}, "$description", $amount)';

  @override
  bool operator ==(Object other) => (other is CsvLine) && (other.date.year == date.year) && (other.date.month == date.month) && (other.date.day == date.day) && (other.description == description) && (other.amount == amount);

  @override
  int get hashCode => Object.hash(date, description, amount);
}