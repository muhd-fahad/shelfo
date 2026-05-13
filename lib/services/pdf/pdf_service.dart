import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../models/sale/sale_model.dart';
import '../../models/business/business_model.dart';
import '../../utils/formatters/currency_formatter.dart';

class PdfService {
  static Future<void> generateAndPrintInvoice(Sale sale, Business? business, dynamic currency) async {
    final pdf = await _generatePdf(sale, business, currency);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> generateAndShareInvoice(Sale sale, Business? business, dynamic currency) async {
    final pdf = await _generatePdf(sale, business, currency);
    final bytes = await pdf.save();
    
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/invoice_${sale.id}.pdf');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], text: 'Invoice ${sale.id}');
  }

  static Future<void> generateAndDownloadInvoice(Sale sale, Business? business, dynamic currency) async {
    final pdf = await _generatePdf(sale, business, currency);
    final bytes = await pdf.save();
    
    // For mobile, we might just share it or save to documents
    // On web it would download. For now let's just share it as a proxy for "save"
    await generateAndShareInvoice(sale, business, currency);
  }

  static Future<pw.Document> _generatePdf(Sale sale, Business? business, dynamic currency) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        business?.name ?? "Business Name",
                        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(business?.address ?? "Business Address"),
                      pw.Text(business?.phoneNumber ?? ""),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "INVOICE",
                        style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                      ),
                      pw.Text("ID: ${sale.id}"),
                      pw.Text("Date: ${dateFormat.format(sale.dateTime)}"),
                      pw.Text("Time: ${timeFormat.format(sale.dateTime)}"),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Billed To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(sale.customerName),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Status:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(sale.status, style: pw.TextStyle(color: sale.status == 'Paid' ? PdfColors.green : PdfColors.red)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Table(
                border: const pw.TableBorder(
                  bottom: pw.BorderSide(color: PdfColors.grey300),
                  horizontalInside: pw.BorderSide(color: PdfColors.grey100),
                ),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Item", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Qty", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Price", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Total", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  ...sale.items.map((item) => pw.TableRow(
                        children: [
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(item.productName)),
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(item.quantity.toString())),
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrencyFormatter.format(item.price, currency))),
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrencyFormatter.format(item.total, currency))),
                        ],
                      )),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _buildSummaryRow("Subtotal", CurrencyFormatter.format(sale.subtotal, currency)),
                      _buildSummaryRow("Tax", CurrencyFormatter.format(sale.taxAmount, currency)),
                      pw.Divider(color: PdfColors.grey300),
                      _buildSummaryRow("Total", CurrencyFormatter.format(sale.total, currency), isBold: true, fontSize: 18),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Text("Payment Method: ${sale.paymentMethod}"),
              pw.Spacer(),
              pw.Center(
                child: pw.Text("Thank you for your business!", style: pw.TextStyle(fontStyle: pw.FontStyle.italic, color: PdfColors.grey500)),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildSummaryRow(String label, String value, {bool isBold = false, double fontSize = 12}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text("$label: ", style: pw.TextStyle(fontSize: fontSize)),
          pw.Text(value, style: pw.TextStyle(fontSize: fontSize, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      ),
    );
  }
}
