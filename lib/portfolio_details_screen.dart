import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioDetailsScreen extends StatelessWidget {
  final String portfolioId;

  const PortfolioDetailsScreen({super.key, required this.portfolioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('portfolios')
            .doc(portfolioId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final portfolio = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  portfolio['title'],
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: portfolio['imageUrls'].length,
                  itemBuilder: (context, index) {
                    return Image.network(portfolio['imageUrls'][index]);
                  },
                ),
                const SizedBox(height: 20.0),
                Text('Artist Name: ${portfolio['artistName']}'),
                Text('Category: ${portfolio['category']}'),
                Text('Email Address: ${portfolio['emailAddress']}'),
                const SizedBox(height: 20.0),
                CommentsSection(portfolioId: portfolioId),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CommentsSection extends StatefulWidget {
  final String portfolioId;

  const CommentsSection({super.key, required this.portfolioId});

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _commenterNameController =
      TextEditingController();
  final TextEditingController _commenterContactController =
      TextEditingController();

  void _postComment() {
    String commentText = _commentController.text;
    String commenterName = _commenterNameController.text;
    String commenterContact = _commenterContactController.text;
    // Check if comment is not empty
    if (commentText.isNotEmpty) {
      // Post comment to Firestore
      FirebaseFirestore.instance.collection('comments').add({
        'portfolioId': widget.portfolioId,
        'commentText': commentText,
        'commenterName': commenterName,
        'commenterContact': commenterContact,
      });
      // Clear the comment text field after posting
      _commentController.clear();
      _commenterNameController.clear();
      _commenterContactController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('comments')
              .where('portfolioId', isEqualTo: widget.portfolioId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final comments = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  title: Text(comment['commentText']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Commenter: ${comment['commenterName'] ?? "Anonymous"}'),
                      Text(
                          'Contact: ${comment['commenterContact'] ?? "Anonymous"}'),
                    ],
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 10.0),
        TextField(
          controller: _commentController,
          decoration: const InputDecoration(labelText: 'Add a comment'),
        ),
        const SizedBox(height: 10.0),
        TextField(
          controller: _commenterNameController,
          decoration: const InputDecoration(labelText: 'Your Name (Optional)'),
        ),
        const SizedBox(height: 10.0),
        TextField(
          controller: _commenterContactController,
          decoration:
              const InputDecoration(labelText: 'Your Contact (Optional)'),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: _postComment,
          child: const Text('Comment'),
        ),
      ],
    );
  }
}
