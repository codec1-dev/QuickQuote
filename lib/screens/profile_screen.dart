import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, FirebaseFirestore;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/legel_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final _nameController = TextEditingController(text: "Guest User");

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ValueNotifier<ThemeMode>>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade300,
              backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
              child:
                  _profileImage == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
            ),
          ),
          const SizedBox(height: 16),

          // Editable Name
          TextField(
            controller: _nameController,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
          const SizedBox(height: 30),
          // Settings Section
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // Dark Mode Toggle
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: isDark,
              onChanged: (val) {
                themeProvider.value = val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About App"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Quote App",
                applicationVersion: "1.0.0",
                applicationIcon: const Icon(Icons.format_quote, size: 50),
                applicationLegalese: "© 2025 Quick Quote. All rights reserved.",
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      LegelText.aboutApp,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Privacy Policy"),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Privacy Policy"),
                      content: const SingleChildScrollView(
                        child: Text(
                          LegelText.privacyPolicy,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text("Terms and Conditions"),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Terms and Conditions"),
                      content: const SingleChildScrollView(
                        child: Text(
                          LegelText.termsAndConditions,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text("Send Feedback"),
            onTap: () {
              final _name = TextEditingController();
              final _email = TextEditingController();
              final _message = TextEditingController();

              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Send Feedback"),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _name,
                              decoration: const InputDecoration(
                                labelText: "Name",
                              ),
                            ),
                            TextField(
                              controller: _email,
                              decoration: const InputDecoration(
                                labelText: "Email",
                              ),
                            ),
                            TextField(
                              controller: _message,
                              decoration: const InputDecoration(
                                labelText: "Message",
                              ),
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            try {
                              await FirebaseFirestore.instance
                                  .collection('feedbacks')
                                  .add({
                                    'name': _name.text,
                                    'email': _email.text,
                                    'message': _message.text,
                                    'timestamp': FieldValue.serverTimestamp(),
                                  });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Feedback sent. Thank you!"),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Failed to send: $e")),
                              );
                            }
                          },
                          child: const Text("Send Feedback"),
                        ),
                      ],
                    ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("Share App"),
            onTap: () async {
              const filePath = "/storage/emulated/0/Download/quote_app.apk";
              final apkFile = File(filePath);

              // Check and request storage permission
              PermissionStatus status;

              if (Platform.isAndroid) {
                status = await Permission.manageExternalStorage.request();
              } else {
                status = await Permission.storage.request();
              }

              if (status.isGranted) {
                if (await apkFile.exists()) {
                  await Share.shareXFiles([
                    XFile(apkFile.path),
                  ], text: "Install my Quote App! 📱✨");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("APK not found in Downloads folder."),
                    ),
                  );
                }
              } else {
                // Open app settings if permission denied
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Storage permission is required."),
                  ),
                );
                await openAppSettings();
              }
            },
          ),
        ],
      ),
    );
  }
}
