import 'package:c_box/screens/rental_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'utils/shared_preferences_util.dart';

class QRScanPage extends StatefulWidget {
  final String itemName;
  final bool isRenting;

  const QRScanPage({
    super.key,
    required this.itemName,
    required this.isRenting,
  });

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _scanned = false;

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    ctrl.scannedDataStream.listen((scanData) async {
      if (_scanned) return;
      _scanned = true;
      controller?.pauseCamera();

      final qrData = scanData.code;
      if (qrData == null || !qrData.startsWith('rental:')) {
        _showDialog('QR 오류', '잘못된 QR 코드입니다.', null);
        return;
      }

      final parts = qrData.split(':');
      if (parts.length != 3) {
        _showDialog('QR 오류', 'QR 코드 형식이 잘못되었습니다.', null);
        return;
      }

      final itemId = int.tryParse(parts[1]);
      final item = parts[2];

      final now = DateTime.now();
      final due = now.add(const Duration(days: 3));

      if (widget.isRenting) {
        final rentalInfo = {
          "itemId": itemId,
          "item": item,
          "dueDate": due.toIso8601String().substring(0, 10),
          "statusMessage": "반납까지 3일 남음"
        };

        _showDialog('성공', '대여 완료되었습니다.', () {
          Provider.of<RentalStatusProvider>(context, listen: false).addRental(rentalInfo);
          Navigator.pop(context, rentalInfo);
        });
      } else {
        _showDialog('성공', '반납 완료되었습니다.', () {
          Navigator.pop(context, {"returnedItemId": itemId});
        });
      }
    });
  }

  void _showDialog(String title, String message, VoidCallback? onConfirm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onConfirm != null) {
                onConfirm();
              }
            },
            child: const Text('확인'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isRenting ? '대여 QR 스캔' : '반납 QR 스캔')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(widget.isRenting ? '대여할 QR을 스캔하세요' : '반납할 QR을 스캔하세요'),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
