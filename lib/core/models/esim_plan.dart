class EsimPlan {
  final String name;
  final String slug;
  final double costUsd;
  final double retailUsd;
  final String directLink;
  final String shopLink;

  const EsimPlan({
    required this.name,
    required this.slug,
    required this.costUsd,
    required this.retailUsd,
    required this.directLink,
    required this.shopLink,
  });

  // Parse data amount from plan name
  String get dataAmount {
    final RegExp dataRegex = RegExp(r'(\d+(?:\.\d+)?)(MB|GB)');
    final match = dataRegex.firstMatch(name);
    if (match != null) {
      return '${match.group(1)}${match.group(2)}';
    }
    return '';
  }

  // Parse duration from plan name
  String get duration {
    if (name.contains('/Day')) {
      return 'per day';
    } else if (name.contains('Days')) {
      final RegExp durationRegex = RegExp(r'(\d+)\s*Days');
      final match = durationRegex.firstMatch(name);
      if (match != null) {
        final days = int.parse(match.group(1)!);
        if (days == 7) return '7 days';
        if (days == 15) return '15 days';
        if (days == 30) return '30 days';
        if (days == 90) return '90 days';
        if (days == 180) return '180 days';
        if (days == 365) return '365 days';
        return '$days days';
      }
    }
    return '';
  }

  // Get formatted price
  String get formattedPrice => '\$${retailUsd.toStringAsFixed(2)}';

  // Check if this plan is popular (example logic)
  bool get isPopular {
    return name.contains('500MB/Day') || name.contains('5GB 30Days') || name.contains('3GB 30Days');
  }

  factory EsimPlan.fromCsv(String csvRow) {
    final fields = _parseCsvRow(csvRow);
    if (fields.length < 6) {
      throw ArgumentError('Invalid CSV row: $csvRow');
    }

    // Use the 5th column (index 4) for the latest retail price if available,
    // otherwise fall back to the 4th column (index 3)
    double retailPrice;
    if (fields.length > 4 && fields[4].isNotEmpty) {
      retailPrice = double.parse(fields[4]);
    } else {
      retailPrice = double.parse(fields[3]);
    }

    return EsimPlan(
      name: fields[0].replaceAll('"', '').trim(),
      slug: fields[1].trim(),
      costUsd: double.parse(fields[2]),
      retailUsd: retailPrice,
      directLink: fields[5].replaceAll('"', '').trim(),
      shopLink: fields[6].replaceAll('"', '').trim(),
    );
  }

  static List<String> _parseCsvRow(String row) {
    final List<String> fields = [];
    bool inQuotes = false;
    StringBuffer currentField = StringBuffer();

    for (int i = 0; i < row.length; i++) {
      final char = row[i];
      
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        fields.add(currentField.toString());
        currentField.clear();
      } else {
        currentField.write(char);
      }
    }
    
    fields.add(currentField.toString());
    return fields;
  }
}
