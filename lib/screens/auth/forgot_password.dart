import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _emailC.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _sending = true);

    try {
      // TODO: ganti dengan layanan reset password beneran
      // Contoh Firebase:
      // await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailC.text.trim());

      // simulasi request
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Tautan reset password telah dikirim ke ${_emailC.text.trim()}",
          ),
        ),
      );

      // opsional: kembali ke login
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengirim tautan reset. Coba lagi."),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  String? _emailValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return "Email wajib diisi";
    final emailReg =
        RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$"); // cek sederhana format email
    if (!emailReg.hasMatch(value)) return "Format email tidak valid";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Kata Sandi")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header / ilustrasi singkat
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary, cs.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reset kata sandi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Masukkan email yang terdaftar. Kami akan mengirimkan tautan untuk mengatur ulang kata sandi.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailC,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: _emailValidator,
                decoration: const InputDecoration(
                  labelText: "Email terdaftar",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _sending ? null : _sendResetLink,
                child: _sending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Kirim Tautan Reset"),
              ),
            ),

            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: _sending ? null : () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Kembali ke Login"),
            ),
          ],
        ),
      ),
    );
  }
}
