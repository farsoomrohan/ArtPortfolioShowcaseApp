import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/comments.dart';
import 'package:test/portfolio.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch portfolios from Firestore
  Stream<List<Portfolio>> getPortfolios() {
    return _firestore
        .collection('portfolios')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Portfolio(
                id: doc.id,
                imageUrls: List<String>.from(data['imageUrls']),
                title: data['title'],
                artistName: data['artistName'],
                category: data['category'],
                emailAddress: data['emailAddress'],
              );
            }).toList());
  }

  // Method to add a new portfolio to Firestore
  Future<void> addPortfolio(Portfolio portfolio) async {
    await _firestore.collection('portfolios').add({
      'imageUrls': portfolio.imageUrls,
      'title': portfolio.title,
      'artistName': portfolio.artistName,
      'category': portfolio.category,
      'emailAddress': portfolio.emailAddress,
    });
  }

  // Method to fetch comments for a portfolio from Firestore
  Stream<List<Comment>> getCommentsForPortfolio(String portfolioId) {
    return _firestore
        .collection('comments')
        .where('portfolioId', isEqualTo: portfolioId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment(
                  commenterName: doc['commenterName'] ?? '',
                  commenterContact: doc['commenterContact'] ?? '',
                  commentText: doc['commentText'],
                ))
            .toList());
  }

  // Method to add a new comment to Firestore
  Future<void> addComment(Comment comment, String portfolioId) async {
    await _firestore.collection('comments').add({
      'portfolioId': portfolioId,
      'commenterName': comment.commenterName,
      'commenterContact': comment.commenterContact,
      'commentText': comment.commentText,
    });
  }
}
