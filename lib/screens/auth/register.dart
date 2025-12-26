import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color topTeal = Color(0xFF6AAFA8);
const Color bottomTeal = Color(0xFF009F8A);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();


 final _usiaC = TextEditingController();
  final _hobiC = TextEditingController();

  String _peran = "Ibu Rumah Tangga";

  final List<String> _listPeran = [
    "Ibu Rumah Tangga",
    "Wanita Karir",
    "Ibu Anak Berkebutuhan Khusus",
    "Ibu Muslimah",
  ];
  bool _loading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
void dispose() {
  _nameC.dispose();
  _emailC.dispose();
  _passC.dispose();
  _confirmC.dispose();
  _usiaC.dispose();
  _hobiC.dispose();
  super.dispose();
}

Future<void> _doRegister() async {
  if (!(_formKey.currentState?.validate() ?? false)) return;

  if (_passC.text.trim() != _confirmC.text.trim()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password dan konfirmasi tidak sama")),
    );
    return;
  }

  setState(() => _loading = true);

  try {
    // ✅ SIMPAN CREDENTIAL
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailC.text.trim(),
      password: _passC.text.trim(),
    );

    // ✅ SIMPAN NAMA LENGKAP KE FIREBASE AUTH
    await credential.user!.updateDisplayName(_nameC.text.trim());
    

// ✅ SIMPAN DATA PROFILE KE FIRESTORE
final uid = credential.user!.uid;
Navigator.pushReplacementNamed(context, AppRoutes.profile);

await FirebaseFirestore.instance.collection('users').doc(uid).set({
  'nama': _nameC.text.trim(),
  'email': _emailC.text.trim(),
  'usia': int.parse(_usiaC.text.trim()),
  'peran': _peran,
  'hobi': _hobiC.text.trim(),
  'createdAt': FieldValue.serverTimestamp(),
});


    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registrasi berhasil, silakan login")),
    );

    Navigator.pushReplacementNamed(context, AppRoutes.profile);
  } on FirebaseAuthException catch (e) {
    String msg = "Gagal registrasi.";

    if (e.code == 'email-already-in-use') msg = "Email sudah digunakan.";
    if (e.code == 'invalid-email') msg = "Format email tidak valid.";
    if (e.code == 'weak-password') msg = "Password terlalu lemah.";

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    final primaryGreen = Colors.green.shade600;
    final lightGreen = Colors.green.shade100;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: bottomTeal,
        title: const Text(
          "Daftar Akun",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // HEADER ATAS
                    Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                           gradient: const LinearGradient(
  colors: [topTeal, bottomTeal],
),
boxShadow: [
  BoxShadow(
    color: bottomTeal.withOpacity(0.25),
    blurRadius: 18,
    offset: const Offset(0, 8),
  ),
],
                          ),
                          child: const Icon(
                            Icons.favorite_outline_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Buat akun Tenangkan.id 💚",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Daftar untuk mulai akses konten dan fitur ketenangan diri.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                    // CARD FORM REGISTER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                       border: Border.all(
  color: topTeal.withOpacity(0.35),
),

                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Isi data dirimu",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pastikan email dan password mudah kamu ingat.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Nama lengkap
                            TextFormField(
                              controller: _nameC,
                              decoration: InputDecoration(
                                labelText: "Nama Lengkap",
                                hintText: "contoh: Ibu Tenang Bahagia",
                                prefixIcon: const Icon(Icons.person_outline),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: primaryGreen,
                                    width: 1.6,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Nama wajib diisi";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // Email
                            TextFormField(
                              controller: _emailC,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email",
                                hintText: "contoh: ibu.tenang@gmail.com",
                                prefixIcon: const Icon(Icons.email_outlined),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: primaryGreen,
                                    width: 1.6,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Email wajib diisi";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),


                            const SizedBox(height: 12),
                            // Usia
                            TextFormField(
                              controller: _usiaC,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Usia",
                                hintText: "contoh: 30",
                                prefixIcon: const Icon(Icons.cake_outlined),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: bottomTeal,
                                    width: 1.6,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Usia wajib diisi";
                                }
                                if (int.tryParse(v) == null) {
                                  return "Usia harus berupa angka";
                                }
                                return null;
                              },
                            ),
                              const SizedBox(height: 12),

                            // Peran
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _peran,
                              decoration: InputDecoration(
                              labelText: "Peran",
                              prefixIcon: const Icon(Icons.woman_rounded),
                              filled: true,
                              fillColor: Colors.grey.shade50,

                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Colors.green.shade600,
                                  width: 1.6,
                                ),
                              ),
                            ),

                              items: _listPeran.map((role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _peran = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 12),

                            // Hobi
                            TextFormField(
                              controller: _hobiC,
                              decoration: InputDecoration(
                                labelText: "Hobi",
                                hintText: "contoh: Membaca",
                                prefixIcon: const Icon(Icons.menu_book_outlined),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.green.shade600,
                                    width: 1.6,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Hobi wajib diisi";
                                }
                                return null;
                              },
                            ),

                            // Password
                            TextFormField(
                              controller: _passC,
                              obscureText: _obscurePass,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                      () => _obscurePass = !_obscurePass),
                                  icon: Icon(
                                    _obscurePass
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: primaryGreen,
                                    width: 1.6,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Password wajib diisi";
                                }
                                if (v.length < 6) {
                                  return "Password minimal 6 karakter";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // Konfirmasi Password
                            TextFormField(
                              controller: _confirmC,
                              obscureText: _obscureConfirm,
                              decoration: InputDecoration(
                                labelText: "Konfirmasi Password",
                                prefixIcon:
                                    const Icon(Icons.lock_reset_outlined),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm),
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: primaryGreen,
                                    width: 1.6,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Konfirmasi password wajib";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Tombol daftar
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: bottomTeal,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: _loading ? null : _doRegister,
                                child: _loading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        "Daftar",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // BAWAH: Sudah punya akun?
                    Column(
                      children: [
                        Text(
                          "Sudah punya akun?",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        TextButton(
                          onPressed: _loading
                              ? null
                              : () => Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.login,
                                  ),
                          child: Text(
                            "Masuk di sini",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: bottomTeal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
