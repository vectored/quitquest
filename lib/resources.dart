import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Resources extends StatelessWidget {
   Resources({super.key});

  // Helper method to launch URLs
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  // List of mental health and addiction resources
  final List<Map<String, String>> _resources = [
    {
      'title': 'SAMHSA National Helpline',
      'description':
          'Free, confidential 24/7 treatment referral and information service for individuals and families facing mental and/or substance use disorders.',
      'url': 'https://www.samhsa.gov/find-help/national-helpline'
    },
    {
      'title': 'FindTreatment.gov',
      'description':
          'A confidential and anonymous resource for persons seeking treatment for mental and substance use disorders in the United States and its territories.',
      'url': 'https://findtreatment.gov/'
    },
    {
      'title': 'Mental Health America',
      'description':
          'Provides resources and support for mental health conditions, including screening tools and information on various mental health topics.',
      'url': 'https://mhanational.org/'
    },
    {
      'title': 'National Institute of Mental Health (NIMH)',
      'description':
          'Offers information on mental health disorders, treatment options, and ongoing research.',
      'url': 'https://www.nimh.nih.gov/health/find-help'
    },
    {
      'title': 'Crisis Text Line',
      'description':
          'Free, 24/7 support for those in crisis. Text HOME to 741741 to connect with a trained crisis counselor.',
      'url': 'https://www.crisistextline.org/'
    },
    {
      'title': 'SMART Recovery',
      'description':
          'Provides free mutual support meetings and resources for individuals seeking to overcome addictive behaviors.',
      'url': 'https://smartrecovery.org/'
    },
    {
      'title': 'Mental Health Coalition Resource Library',
      'description':
          'A comprehensive collection of mental health resources, including support for anxiety, depression, and more.',
      'url': 'https://www.thementalhealthcoalition.org/resources/'
    },
    {
      'title': 'American Addiction Centers',
      'description':
          'Offers information and resources for individuals struggling with substance abuse, including treatment options.',
      'url': 'https://americanaddictioncenters.org/online-resources'
    },
    {
      'title': 'Mental Health First Aid',
      'description':
          'Provides resources and training to help individuals assist someone experiencing a mental health or substance use crisis.',
      'url': 'https://www.mentalhealthfirstaid.org/mental-health-resources/'
    },
    {
      'title': 'Cope Notes',
      'description':
          'Sends daily text messages with positive thoughts and exercises to help combat depression and anxiety.',
      'url': 'https://www.copenotes.com'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: ListView.builder(
        itemCount: _resources.length,
        itemBuilder: (context, index) {
          final resource = _resources[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(resource['title'] ?? ''),
              subtitle: Text(resource['description'] ?? ''),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launchURL(resource['url'] ?? ''),
            ),
          );
        },
      ),
    );
  }
}
