import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class MySeparator extends StatelessWidget {
  final double totalWidth, dashWidth, emptyWidth, dashHeight;
  final PdfColor dashColor;

  MySeparator(
    this.dashColor, {
    this.totalWidth = 300,
    this.dashWidth = 2,
    this.emptyWidth = 2,
    this.dashHeight = 0.1,
  });

  @override
  Widget build(Context context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalWidth ~/ (dashWidth + emptyWidth),
        (_) => Container(
          width: dashWidth,
          height: dashHeight,
          color: dashColor,
          margin:
              pw.EdgeInsets.only(left: emptyWidth / 2, right: emptyWidth / 2),
        ),
      ),
    );
  }
}
