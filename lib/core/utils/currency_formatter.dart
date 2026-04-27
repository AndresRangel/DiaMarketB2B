import '../theme/app_config_model.dart';

/// Formatea valores monetarios según la config de locale del cliente.
/// Usar SIEMPRE este helper — nunca formatear moneda manualmente en los widgets.
class CurrencyFormatter {
  static String format(double amount, LocaleConfig config) {
    // Redondear según los decimales configurados
    final fixed = amount.toStringAsFixed(config.currencyDecimals);

    // Separar parte entera y decimal
    final parts = fixed.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? parts[1] : '';

    // Insertar separador de miles
    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(config.thousandSeparator);
      }
      buffer.write(intPart[i]);
    }

    final formatted = config.currencyDecimals > 0
        ? '${buffer.toString()}${config.decimalSeparator}$decPart'
        : buffer.toString();

    return '${config.currencySymbol}$formatted';
  }
}
