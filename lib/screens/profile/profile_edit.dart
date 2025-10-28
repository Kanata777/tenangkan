import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _hobiController = TextEditingController(text: widget.hobi);

    // Pastikan format usia cocok dengan dropdown item (misalnya "17 Tahun")
    if (widget.usia.contains("Tahun")) {
      _selectedUsia = widget.usia;
    } else if (int.tryParse(widget.usia) != null) {
      _selectedUsia = "${widget.usia} Tahun";
    } else {
      _selectedUsia = null;
    }

    _selectedPeran =
        [
          "Ibu Rumah Tangga",
          "Wanita Karir",
          "Ibu Anak Berkebutuhan Khusus",
          "Ibu Muslimah",
        ].contains(widget.peran)
        ? widget.peran
        : null;
  }

  void _simpanProfile() {
    if (_formKey.currentState!.validate() &&
        _selectedUsia != null &&
        _selectedPeran != null) {
      Navigator.pop(context, {
        'nama': _namaController.text,
        'usia': _selectedUsia!,
        'hobi': _hobiController.text,
        'peran': _selectedPeran!,
        'tagline': "Wellness Enthusiast 🌿", // ✅ tambahkan ini
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil berhasil diperbarui!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pastikan semua field terisi dengan benar!"),
          backgroundColor: Colors.red,
        ),
      );
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_namaController, "Nama Lengkap", Icons.person),
                const SizedBox(height: 16),

                // Dropdown Usia
                DropdownButtonFormField<String>(
                  value: _selectedUsia,
                  items: [
                    for (int usia = 17; usia <= 50; usia++)
                      DropdownMenuItem(
                        value: "$usia Tahun",
                        child: Text("$usia Tahun"),
                      ),
                  ],
                  onChanged: (value) => setState(() => _selectedUsia = value),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: "Usia",
                    prefixIcon: const Icon(Icons.cake, color: Colors.green),
                  ),
                  validator: (value) =>
                      value == null ? 'Pilih usia terlebih dahulu' : null,
                ),

                const SizedBox(height: 16),

                // Dropdown Peran
                DropdownButtonFormField<String>(
                  value:
                      [
                        "Ibu Rumah Tangga",
                        "Wanita Karir",
                        "Ibu Anak Berkebutuhan Khusus",
                        "Ibu Muslimah",
                      ].contains(_selectedPeran)
                      ? _selectedPeran
                      : null,
                  items: const [
                    DropdownMenuItem(
                      value: "Ibu Rumah Tangga",
                      child: Text("Ibu Rumah Tangga"),
                    ),
                    DropdownMenuItem(
                      value: "Wanita Karir",
                      child: Text("Wanita Karir"),
                    ),
                    DropdownMenuItem(
                      value: "Ibu Anak Berkebutuhan Khusus",
                      child: Text("Ibu Anak Berkebutuhan Khusus"),
                    ),
                    DropdownMenuItem(
                      value: "Ibu Muslimah",
                      child: Text("Ibu Muslimah"),
                    ),
                  ],
                  onChanged: (value) => setState(() => _selectedPeran = value),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: "Peran",
                    prefixIcon: const Icon(
                      Icons.person_pin,
                      color: Colors.green,
                    ),
                  ),
                  validator: (value) =>
                      value == null ? 'Pilih peran terlebih dahulu' : null,
                ),

                const SizedBox(height: 16),

                _buildTextField(_hobiController, "Hobi", Icons.favorite),
                const SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: _simpanProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
