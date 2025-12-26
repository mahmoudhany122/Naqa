import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/journey_entry_model.dart';
import '../models/progress_model.dart';

class ExportService {
  Future<void> exportToPdf({
    required List<JourneyEntryModel> entries,
    required List<ProgressModel> weeklyProgress,
    required int currentStreak,
    required int totalDays,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'تقرير التقدم',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Statistics
              pw.Text(
                'الإحصائيات:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('الأيام الحالية: $currentStreak'),
              pw.Text('إجمالي الأيام: $totalDays'),
              pw.SizedBox(height: 20),

              // Weekly Progress
              pw.Text(
                'التقدم الأسبوعي:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...weeklyProgress.map((progress) =>
                  pw.Text('${progress.day}: ${progress.progress}%'),
              ),
              pw.SizedBox(height: 20),

              // Journey Entries
              pw.Text(
                'اليوميات:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...entries.take(10).map((entry) =>
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          entry.timestamp.toString().split(' ')[0],
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey,
                          ),
                        ),
                        pw.Text(entry.text),
                        pw.Divider(),
                      ],
                    ),
                  ),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/progress_report.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'تقرير التقدم');
  }

  Future<void> exportToCsv({
    required List<JourneyEntryModel> entries,
    required List<ProgressModel> weeklyProgress,
  }) async {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('التاريخ,النص');

    // Journey Entries
    for (var entry in entries) {
      final date = entry.timestamp.toString().split(' ')[0];
      final text = entry.text.replaceAll(',', ';');
      buffer.writeln('$date,$text');
    }

    buffer.writeln('');
    buffer.writeln('اليوم,التقدم');

    // Weekly Progress
    for (var progress in weeklyProgress) {
      buffer.writeln('${progress.day},${progress.progress}');
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/progress_data.csv');
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles([XFile(file.path)], text: 'بيانات التقدم');
  }
}