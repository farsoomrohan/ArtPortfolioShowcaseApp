import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/portfolio_creation_screen.dart';
import 'package:test/portfolio_details_screen.dart';

class PortfolioListScreen extends StatelessWidget {
  const PortfolioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artfolio'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('portfolios').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final portfolios = snapshot.data!.docs;
          return ListView.builder(
            itemCount: portfolios.length,
            itemBuilder: (context, index) {
              final portfolio = portfolios[index];
              return ListTile(
                title: Text(portfolio['title']),
                leading: Image.network(portfolio['imageUrls'][0]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PortfolioDetailsScreen(portfolioId: portfolio.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PortfolioCreationScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
