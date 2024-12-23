import 'package:flutter_crud/service/auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  String _fetchedData = "Belum ada data";

  void handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await login(_emailController.text, _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleFetchData() async {
  try {
    final data = await fetchProtectedData();

    final formattedData = data.entries
        .map((entry) => "${entry.key}: ${entry.value}")
        .join("\n");

    setState(() {
      _fetchedData = formattedData;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data berhasil diambil!")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal mengambil data: $e")),
    );
  }
}


  void handleHapusToken() async {
    try {
      await logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access token berhasil dihapus!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus token: $e")),
      );
    }
  }

  String _parseJsonData(String jsonData) {
    try {
      final decoded = json.decode(jsonData) as Map<String, dynamic>;

      // Format data menjadi string
      return decoded.entries
          .map((entry) => "${entry.key}: ${entry.value}")
          .join("\n");
    } catch (e) {
      return "Format data tidak valid.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : handleLogin,
              child: Text(_isLoading ? "Loading..." : "Login"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleFetchData,
              child: const Text("Fetch Data"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleHapusToken,
              child: const Text("Hapus Access Token"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Hasil Fetch Data:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _fetchedData.isNotEmpty
                    ? _fetchedData
                    : "Belum ada data yang diambil.",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),

          ],
        ),
      ),
    );
  }
}
