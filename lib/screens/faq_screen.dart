import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'category': 'General',
      'questions': [
        {
          'question': 'What is Vision for a Better Life SLA?',
          'answer':
              'Vision for a Better Life SLA is a leading financial services provider in Ethiopia, '
              'offering quick and affordable loan solutions to individuals and businesses. '
              'We are committed to helping our customers achieve their dreams through accessible financing.',
          'expanded': false,
        },
        {
          'question': 'What types of loans do you offer?',
          'answer':
              'We offer various loan products including:\n'
              '• Personal Loans - For personal expenses\n'
              '• Business Loans - To grow your business\n'
              '• Emergency Loans - For urgent needs\n'
              '• Education Loans - For educational expenses\n\n'
              'Each loan type has different terms and interest rates.',
          'expanded': false,
        },
        {
          'question': 'How quickly can I get my loan approved?',
          'answer':
              'Our loan approval process is very quick. Once you submit all required documents, '
              'you can expect approval within 24 hours. Emergency loans may be approved even faster.',
          'expanded': false,
        },
      ],
    },
    {
      'category': 'Eligibility',
      'questions': [
        {
          'question': 'Who can apply for a loan?',
          'answer': 'To apply for a loan, you must:\n'
              '• Be an Ethiopian citizen\n'
              '• Be between 18-65 years old\n'
              '• Have a valid national ID\n'
              '• Have a regular source of income\n'
              '• Have a good credit history',
          'expanded': false,
        },
        {
          'question': 'What documents do I need to apply?',
          'answer': 'Required documents include:\n'
              '• National ID card\n'
              '• Proof of residence (utility bill, rent agreement)\n'
              '• Bank statements (last 3 months)\n'
              '• Salary slip or proof of income\n'
              '• Guarantor information and documents\n'
              '• Passport photos (2 copies)',
          'expanded': false,
        },
        {
          'question': 'Do I need a guarantor?',
          'answer':
              'Yes, most loans require a guarantor. The guarantor should be:\n'
              '• An Ethiopian citizen with valid ID\n'
              '• Employed or have a stable income source\n'
              '• Willing to take responsibility if you default\n\n'
              'Some small emergency loans may not require a guarantor.',
          'expanded': false,
        },
      ],
    },
    {
      'category': 'Interest & Repayment',
      'questions': [
        {
          'question': 'What are your interest rates?',
          'answer': 'Our interest rates vary by loan type:\n'
              '• Personal Loans: 15% per annum\n'
              '• Business Loans: 12% per annum\n'
              '• Emergency Loans: 18% per annum\n'
              '• Education Loans: 10% per annum\n\n'
              'Rates may vary based on loan amount and credit history.',
          'expanded': false,
        },
        {
          'question': 'How do I repay my loan?',
          'answer': 'You can repay your loan through:\n'
              '• Direct bank transfer\n'
              '• Cash payment at our office\n'
              '• Mobile banking\n'
              '• Standing order from your bank\n\n'
              'Monthly payments are due on the same date each month.',
          'expanded': false,
        },
        {
          'question': 'Can I repay my loan early?',
          'answer':
              'Yes, you can repay your loan early without any penalty. '
              'Early repayment will save you money on interest. '
              'Simply contact us to get the final settlement amount.',
          'expanded': false,
        },
        {
          'question': 'What happens if I miss a payment?',
          'answer':
              'If you miss a payment:\n'
              '• Late payment fee will be charged\n'
              '• Your credit score may be affected\n'
              '• We will contact you for payment\n'
              '• Your guarantor may be contacted\n\n'
              'Please contact us immediately if you\'re having trouble making payments.',
          'expanded': false,
        },
      ],
    },
    {
      'category': 'Application Process',
      'questions': [
        {
          'question': 'How do I apply for a loan?',
          'answer': 'You can apply for a loan by:\n'
              '1. Using our mobile app (recommended)\n'
              '2. Visiting our office in person\n'
              '3. Calling us to schedule an appointment\n\n'
              'The process is simple and takes about 15-20 minutes.',
          'expanded': false,
        },
        {
          'question': 'How long does the application process take?',
          'answer':
              'The application process timeline:\n'
              '• Application submission: 15-20 minutes\n'
              '• Document verification: 2-4 hours\n'
              '• Approval decision: Within 24 hours\n'
              '• Fund disbursement: 1-2 business days after approval',
          'expanded': false,
        },
        {
          'question': 'Can I track my application status?',
          'answer':
              'Yes, you can track your application status by:\n'
              '• Checking the app if you applied online\n'
              '• Calling our customer service\n'
              '• Visiting our office\n\n'
              'We will also send you SMS updates at each stage.',
          'expanded': false,
        },
      ],
    },
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<String> get _categories {
    return ['All', ..._faqs.map((faq) => faq['category'] as String)];
  }

  List<Map<String, dynamic>> get _filteredFAQs {
    List<Map<String, dynamic>> filtered = [];

    for (var category in _faqs) {
      if (_selectedCategory != 'All' &&
          category['category'] != _selectedCategory) {
        continue;
      }

      var questions = (category['questions'] as List).where((q) {
        String question = q['question'].toString().toLowerCase();
        String answer = q['answer'].toString().toLowerCase();
        return question.contains(_searchQuery.toLowerCase()) ||
            answer.contains(_searchQuery.toLowerCase());
      }).toList();

      if (questions.isNotEmpty) {
        filtered.add({
          'category': category['category'],
          'questions': questions,
        });
      }
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('FAQs'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with Search
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'How Can We Help You?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for answers...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                String category = _categories[index];
                bool isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.secondary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // FAQ List
          Expanded(
            child: _filteredFAQs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No results found',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Try searching with different keywords',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredFAQs.length,
                    itemBuilder: (context, categoryIndex) {
                      var category = _filteredFAQs[categoryIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              category['category'],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ),
                          ...List.generate(
                            category['questions'].length,
                            (questionIndex) {
                              var question =
                                  category['questions'][questionIndex];
                              return _buildFAQItem(
                                question,
                                () {
                                  setState(() {
                                    question['expanded'] =
                                        !question['expanded'];
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
          ),

          // Contact Support
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.help_outline,
                  color: AppColors.secondary,
                  size: 30,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Still have questions?',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Contact our support team',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textLight,
                            ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/contact');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                  ),
                  child: const Text('Contact'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> item, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: item['expanded'] ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item['question'],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: item['expanded'] ? 0.5 : 0,
                    child: Icon(
                      Icons.expand_more,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (item['expanded']) ...[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item['answer'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: AppColors.textLight,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}