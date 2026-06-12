import 'package:flutter/material.dart';

class DoctorPrivacyPolicy extends StatelessWidget {
  const DoctorPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title:
            const Text('Privacy Policy', style: TextStyle(color: Colors.black)),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('Privacy Policy'),
            _BodyText('Effective Date: 01/May/2026'),
            SizedBox(height: 16),

            // 1
            _SectionTitle('1. About PHIR Health'),
            _BodyText(
              'PHIR Health is a digital healthcare management and health-record organization platform that enables users to securely manage, store, organize, access, and share healthcare-related information.\n\n'
              'PHIR Health may operate as part of the broader PHIR ecosystem, including affiliated services such as:',
            ),
            _BulletList([
              'PHIR Wealth',
              'PHIR Shiksha',
              'PHIR Job',
              'PHIR School',
            ]),
            SizedBox(height: 16),

            // 2
            _SectionTitle('2. Information We Collect'),
            _BodyText(
                'We may collect the following categories of information:'),
            SizedBox(height: 8),
            _SubSectionTitle('A. Personal Information'),
            _BulletList([
              'Full name',
              'Email address',
              'Phone number',
              'Date of birth',
              'Gender',
              'Address',
              'Profile information',
              'Government-issued identification (where required)',
            ]),
            SizedBox(height: 8),
            _SubSectionTitle('B. Sensitive Personal & Health Information'),
            _BulletList([
              'Medical history',
              'Health records',
              'Prescriptions',
              'Lab reports',
              'Diagnostic reports',
              'Insurance-related information',
              'Healthcare provider details',
              'Uploaded medical documents',
            ]),
            _BodyText(
                'Sensitive personal data is collected only with your consent and for lawful healthcare-related purposes.'),
            SizedBox(height: 8),
            _SubSectionTitle('C. Device & Technical Information'),
            _BulletList([
              'IP address',
              'Device identifiers',
              'Browser type',
              'Operating system',
              'App usage data',
              'Login activity',
              'Location data (where permitted)',
              'Cookies and analytics data',
            ]),
            SizedBox(height: 8),
            _SubSectionTitle('D. Demographic Information'),
            _BodyText(
                'We may collect general demographic and statistical information to better understand user preferences and improve our services.'),
            SizedBox(height: 16),

            // 3
            _SectionTitle('3. How We Use Your Information'),
            _BodyText(
                'We may use your information for the following purposes:'),
            _BulletList([
              'Providing healthcare-related services',
              'Organizing and managing health records',
              'Verifying user identity',
              'Improving platform functionality and user experience',
              'Enabling ecosystem integration across PHIR services',
              'Providing customer support',
              'Processing subscriptions or payments',
              'Sending updates, notifications, and service communications',
              'Complying with legal obligations',
              'Detecting fraud, misuse, or unauthorized activities',
              'Analytics, research, and operational improvements',
            ]),
            SizedBox(height: 16),

            // 4
            _SectionTitle('4. Consent'),
            _BodyText(
              'By using PHIR Health, you expressly consent to the collection, storage, processing, and sharing of your personal and sensitive health information as described in this Privacy Policy.\n\n'
              'You may withdraw your consent at any time by contacting us, subject to legal or operational requirements.\n\n'
              'Withdrawal of consent may affect the availability or functionality of certain services.',
            ),
            SizedBox(height: 16),

            // 5
            _SectionTitle('5. Sharing of Information'),
            _BodyText(
                'PHIR Health does not sell personal or sensitive health information.\n\nWe may share information only under the following circumstances:'),
            SizedBox(height: 8),
            _SubSectionTitle('A. Authorized Sharing'),
            _BulletList([
              'Healthcare professionals',
              'Insurance providers',
              'Laboratories or diagnostic partners',
              'Ecosystem service providers',
              'Technology and hosting providers',
              'Payment processors',
              'Customer support providers',
            ]),
            _BodyText(
                'Such sharing shall occur only where necessary, authorized, or consented to by the user.'),
            SizedBox(height: 8),
            _SubSectionTitle('B. Legal Compliance'),
            _BodyText('We may disclose information:'),
            _BulletList([
              'Where required by law',
              'In response to court orders or government requests',
              'To protect legal rights and security',
              'To prevent fraud or unlawful activities',
            ]),
            SizedBox(height: 16),

            // 6
            _SectionTitle('6. Data Security'),
            _BodyText(
              'PHIR Health implements commercially reasonable administrative, technical, and organizational safeguards to protect user data.\n\nSecurity measures may include:',
            ),
            _BulletList([
              'AES-256 encryption for data stored at rest',
              'TLS 1.3 encryption during data transmission',
              'Secure authentication systems',
              'Restricted access controls',
              'Monitoring and security audits',
              'Backup and disaster recovery mechanisms',
            ]),
            _BodyText(
                'While we strive to protect your information, no digital system can guarantee absolute security.'),
            SizedBox(height: 16),

            // 7
            _SectionTitle('7. Cookies & Tracking Technologies'),
            _BodyText(
                'PHIR Health may use cookies, analytics tools, and similar technologies to:'),
            _BulletList([
              'Improve platform performance',
              'Remember user preferences',
              'Understand usage behavior',
              'Enhance security',
              'Analyze traffic and engagement',
            ]),
            _BodyText(
                'Users may manage cookie preferences through browser settings where applicable.'),
            SizedBox(height: 16),

            // 8
            _SectionTitle('8. Third-Party Services'),
            _BodyText('PHIR Health may use trusted third-party services for:'),
            _BulletList([
              'Cloud hosting',
              'Analytics',
              'Payment processing',
              'Communication services',
              'Healthcare integrations',
              'Customer support',
            ]),
            _BodyText(
              'Third-party providers may have separate privacy policies and terms governing their services.\n\n'
              'PHIR Health is not responsible for the privacy practices of external third-party platforms.',
            ),
            SizedBox(height: 16),

            // 9
            _SectionTitle('9. Data Retention'),
            _BodyText(
                'PHIR Health retains personal and health-related information only for as long as necessary to:'),
            _BulletList([
              'Provide services',
              'Comply with legal obligations',
              'Resolve disputes',
              'Enforce agreements',
              'Maintain security and operational records',
            ]),
            _BodyText(
                'Retention periods may vary depending on applicable legal, healthcare, regulatory, or operational requirements.'),
            SizedBox(height: 16),

            // 10
            _SectionTitle('10. User Rights'),
            _BodyText(
                'Subject to applicable law, users may have the right to:'),
            _BulletList([
              'Access their personal information',
              'Request correction of inaccurate information',
              'Request deletion of data',
              'Withdraw consent',
              'Request restriction of processing',
              'Raise privacy-related complaints',
            ]),
            _BodyText(
                'Requests may be submitted using the contact information provided below.'),
            SizedBox(height: 16),

            // 11
            _SectionTitle('11. Children\'s Privacy'),
            _BodyText(
              'PHIR Health services are intended for users above 18 years of age.\n\n'
              'Users below 18 years may access the Platform only under the supervision and consent of a parent or legal guardian.\n\n'
              'Parents or guardians are responsible for information submitted on behalf of minors.',
            ),
            SizedBox(height: 16),

            // 12
            _SectionTitle('12. Cross-Border Data Transfer'),
            _BodyText(
              'Your information may be processed or stored on servers located outside your state or country, subject to applicable legal safeguards and security measures.\n\n'
              'By using the Platform, you consent to such transfers where necessary for service operations.',
            ),
            SizedBox(height: 16),

            // 13
            _SectionTitle('13. Data Breach & Incident Response'),
            _BodyText(
                'In the event of a data breach affecting personal information, PHIR Health shall take reasonable steps to:'),
            _BulletList([
              'Investigate the incident',
              'Mitigate risks',
              'Notify affected users where required',
              'Comply with applicable legal obligations',
            ]),
            SizedBox(height: 16),

            // 14
            _SectionTitle('14. Medical Disclaimer'),
            _BodyText(
              'PHIR Health does not provide medical diagnoses, treatment, prescriptions, or emergency medical services.\n\n'
              'Any health-related information available on the Platform is intended solely for informational and organizational purposes and should not be considered medical advice.\n\n'
              'Users should consult qualified healthcare professionals before making medical decisions.',
            ),
            SizedBox(height: 16),

            // 15
            _SectionTitle('15. Changes to This Privacy Policy'),
            _BodyText(
              'PHIR Health reserves the right to update or modify this Privacy Policy at any time.\n\n'
              'Updated versions shall become effective upon publication on the Platform.\n\n'
              'Continued use of the Platform after updates constitutes acceptance of the revised Privacy Policy.',
            ),
            SizedBox(height: 16),

            // 16
            _SectionTitle('16. Grievance Officer & Contact Information'),
            _BodyText(
                'For privacy concerns, complaints, legal notices, or data-related requests, please contact:'),
            SizedBox(height: 8),
            _SubSectionTitle('PHIR Health'),
            _BodyText(
              'Email: indu@phirhealth.com\n'
              'Phone: +91 9893557585\n\n'
              'Address:\nFirst Floor, 67, Subhash Nagar, Pardeshi Pura\nIndore – 452011, Madhya Pradesh, India',
            ),
            SizedBox(height: 16),

            // 17
            _SectionTitle('17. Governing Law'),
            _BodyText(
              'This Privacy Policy shall be governed by and construed in accordance with the laws of India.\n\n'
              'Any disputes arising from this Privacy Policy shall be subject to the exclusive jurisdiction of the courts located in Indore, Madhya Pradesh.',
            ),
            SizedBox(height: 16),

            // 18
            _SectionTitle('18. Compliance'),
            _BodyText(
                'PHIR Health aims to comply with applicable laws and regulations, including:'),
            _BulletList([
              'Information Technology Act, 2000',
              'Digital Personal Data Protection Act (DPDP Act), 2023',
              'Information Technology Rules relating to sensitive personal data',
              'Consumer Protection (E-Commerce) Rules, 2020',
              'Applicable healthcare and digital platform regulations',
            ]),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _SubSectionTitle extends StatelessWidget {
  final String text;
  const _SubSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          height: 1.5,
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList(this.items);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(fontSize: 14, color: Colors.black54)),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
