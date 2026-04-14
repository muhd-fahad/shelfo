import 'package:hive_ce/hive.dart';

part 'invoice_config_model.g.dart';

@HiveType(typeId: 4)
class InvoiceConfig {
  @HiveField(0)
  final String prefix;

  @HiveField(1)
  final int startingNumber;

  @HiveField(2)
  final String footerText;

  @HiveField(3)
  final bool showLogo;

  InvoiceConfig({
    required this.prefix,
    required this.startingNumber,
    required this.footerText,
    required this.showLogo,
  });

  InvoiceConfig copyWith({
    String? prefix,
    int? startingNumber,
    String? footerText,
    bool? showLogo,
  }) {
    return InvoiceConfig(
      prefix: prefix ?? this.prefix,
      startingNumber: startingNumber ?? this.startingNumber,
      footerText: footerText ?? this.footerText,
      showLogo: showLogo ?? this.showLogo,
    );
  }
}
