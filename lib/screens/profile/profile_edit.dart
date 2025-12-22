import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileDetailPage extends StatefulWidget {
  final String nama;
  final String usia;
  final String hobi;
  final String peran;

  const EditProfileDetailPage({
    super.key,
    required this.nama,
    required this.usia,
    required this.hobi,
    required this.peran,
  });

  @override
  State<EditProfileDetailPage> createState() => _EditProfileDetailPageState();
}

class _EditProfileDetailPageState extends State<EditProfileDetailPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _hobiController;

  String? _selectedUsia;
  String? _selectedPeran;

  bool _isSaving = false; // ✅ LOADING STATE

  final List<String> _listPeran = [
    "Ibu Rumah Tangga",
    "Wanita Karir",
    "Ibu Anak Berkebutuhan Khusus",
    "Ibu Muslimah",
  ];

  @override
  void initState() {
    super.initState();

    _namaController = TextEditingController(text: widget.nama);
    _hobiController = TextEditingController(text: widget.hobi);

    // set usia awal
    if (widget.usia.contains("Tahun")) {
      _selectedUsia = widget.usia;
    } else if (int.tryParse(widget.usia) != null) {
      _selectedUsia = "${widget.usia} Tahun";
    }

    // set peran awal
    _selectedPeran =
        _listPeran.contains(widget.peran) ? widget.peran : null;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hobiController.dispose();
    super.dispose();
  }

  Future<void> _simpanProfile() async {
    if (!_formKey.currentState!.validate() ||
        _selectedUsia == null ||
        _selectedPeran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pastikan semua field terisi dengan benar"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true); // 🔥 AKTIFKAN LOADING

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 1️⃣ Update nama di FirebaseAuth
      await user.updateDisplayName(_namaController.text.trim());

      // 2️⃣ Update data di Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'nama': _namaController.text.trim(),
        'usia': int.parse(_selectedUsia!.replaceAll(' Tahun', '')),
        'peran': _selectedPeran!,
        'hobi': _hobiController.text.trim(),
      });

      if (!mounted) return;

      // 3️⃣ Kembali ke Profile + kirim data
      Navigator.pop(context, {
        'nama': _namaController.text.trim(),
        'usia': _selectedUsia!,
        'hobi': _hobiController.text.trim(),
        'peran': _selectedPeran!,
        'tagline': "Wellness Enthusiast 🌿",
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan perubahan"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Edit Profil Saya"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _namaController,
                  label: "Nama Lengkap",
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),

                // Usia
                DropdownButtonFormField<String>(
                  value: _selectedUsia,
                  items: [
                    for (int i = 17; i <= 50; i++)
                      DropdownMenuItem(
                        value: "$i Tahun",
                        child: Text("$i Tahun"),
                      ),
                  ],
                  onChanged: (v) => setState(() => _selectedUsia = v),
                  validator: (v) =>
                      v == null ? "Pilih usia terlebih dahulu" : null,
                  decoration: _inputDecoration(
                    label: "Usia",
                    icon: Icons.cake,
                  ),
                ),

                const SizedBox(height: 16),

                // Peran
                DropdownButtonFormField<String>(
                  value: _selectedPeran,
                  items: _listPeran
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text(p),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedPeran = v),
                  validator: (v) =>
                      v == null ? "Pilih peran terlebih dahulu" : null,
                  decoration: _inputDecoration(
                    label: "Peran",
                    icon: Icons.person_pin,
                  ),
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _hobiController,
                  label: "Hobi",
                  icon: Icons.favorite,
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _simpanProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Simpan Perubahan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      validator: (v) => v == null || v.isEmpty ? "Tidak boleh kosong" : null,
      decoration: _inputDecoration(label: label, icon: icon),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.green),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
