import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.image,
                width: 180,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(product.category),
            backgroundColor: Colors.teal.withOpacity(0.1),
          ),
          const SizedBox(height: 8),
          Text(
            product.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.menu_book, size: 16),
              const SizedBox(width: 4),
              Text("${product.pages} halaman"),
              const SizedBox(width: 16),
              const Icon(Icons.picture_as_pdf, size: 16),
              const SizedBox(width: 4),
              const Text("PDF"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              Text("${product.rating} (${product.reviews} review)"),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Rp ${product.price}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const Divider(height: 32),

          // Deskripsi
          const Text(
            "Deskripsi",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(product.description),
          const Divider(height: 32),

          // Bonus
          const Text(
            "Bonus yang Anda Dapatkan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Column(
            children: product.bonus
                .map((b) => ListTile(
                      leading: const Icon(Icons.download),
                      title: Text(b["title"]!),
                      subtitle: Text(b["type"]!),
                    ))
                .toList(),
          ),
          const Divider(height: 32),

          // Spesifikasi E-book
          const Text(
            "Spesifikasi E-book",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Table(
            columnWidths: const {0: IntrinsicColumnWidth()},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("Judul"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(product.title),
                ),
              ]),
              TableRow(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("Kategori"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(product.category),
                ),
              ]),
              TableRow(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("Jumlah Halaman"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("${product.pages}"),
                ),
              ]),
              const TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("Format"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("PDF"),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rp ${product.price}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                backgroundColor: Colors.teal,
              ),
              onPressed: () => _showPaymentMethods(context),
              child: const Text("Beli Sekarang"),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================
  //      PAYMENT WORKFLOW
  // ===========================

  void _showPaymentMethods(BuildContext context) {
    final banks = ["BCA", "Mandiri", "BNI", "BRI"];
    final wallets = ["GoPay", "OVO", "DANA", "ShopeePay"];

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Text(
                "Pilih Metode Pembayaran",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              const Text("Bank Transfer",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              ...banks.map((bank) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.account_balance),
                    title: Text(bank),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(ctx); // tutup sheet
                      _proceedPayment(context, method: "Bank - $bank");
                    },
                  )),

              const Divider(height: 24),
              const Text("E-Wallet",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              ...wallets.map((wallet) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.wallet),
                    title: Text(wallet),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(ctx);
                      _proceedPayment(context, method: "E-Wallet - $wallet");
                    },
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _proceedPayment(BuildContext context, {required String method}) {
    // Contoh data dummy
    final isBank = method.startsWith("Bank");
    final title = isBank ? "Instruksi Bank Transfer" : "Instruksi E-Wallet";
    final subtitle = isBank
        ? "Selesaikan pembayaran via Virtual Account"
        : "Scan QRIS berikut dengan aplikasi e-wallet";
    final code = isBank ? "8808 1234 5678 9012" : "INV-QR-2025-0001";
    final note = isBank
        ? "VA aktif 24 jam. Pembayaran otomatis terverifikasi."
        : "QR berlaku 15 menit. Jika gagal, buat ulang.";

    _showPaymentInstruction(
      context,
      title: title,
      method: method,
      subtitle: subtitle,
      codeLabel: isBank ? "Nomor Virtual Account" : "Kode/Ref QRIS",
      codeValue: code,
      note: note,
    );
  }

  void _showPaymentInstruction(
    BuildContext context, {
    required String title,
    required String method,
    required String subtitle,
    required String codeLabel,
    required String codeValue,
    required String note,
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final bottom = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(method, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 12),

              _infoRow(Icons.info_outline, subtitle),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(codeLabel,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SelectableText(
                            codeValue,
                            style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 0.6,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: codeValue));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Disalin ke clipboard")),
                              );
                            }
                          },
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text("Salin"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              _infoRow(Icons.note_alt_outlined, note),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Nanti"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Pembayaran diproses. Cek status di Riwayat/Orders."),
                            ),
                          );
                        }
                      },
                      child: const Text("Saya Sudah Bayar"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.teal),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}
