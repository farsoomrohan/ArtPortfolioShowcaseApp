import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioCreationScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  PortfolioCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Portfolio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                  labelText: 'Image URLs (comma "," -separated)'),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _artistNameController,
              decoration: const InputDecoration(labelText: 'Artist Name'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                final List<String> imageUrls =
                    _imageUrlController.text.split(',');
                FirebaseFirestore.instance.collection('portfolios').add({
                  'imageUrls': imageUrls,
                  'title': _titleController.text,
                  'artistName': _artistNameController.text,
                  'category': _categoryController.text,
                  'emailAddress': _emailController.text,
                });
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
            SizedBox(height: 10.0), // Add space below the button
            Text(
              "If you need to change your portfolio, create a new one with the desired changes and contact us at empowerartistsMAD@gmail to delete the previous one. We will save and forward any comments from clients on your previous portfolio.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
