import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';

enum PolicyType { terms, privacy }

class PolicyScreen extends StatelessWidget {
  final PolicyType type;

  const PolicyScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEn = Localizations.localeOf(context).languageCode == 'en';

    final title =
        type == PolicyType.terms ? l10n.termsAndConditions : l10n.privacyPolicy;

    final sections = type == PolicyType.terms
        ? (isEn ? _termsEn : _termsTh)
        : (isEn ? _privacyEn : _privacyTh);

    return AppScaffold(
      title: title,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.heading,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  section.body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Section {
  final String heading;
  final String body;
  const _Section(this.heading, this.body);
}

// ─── Terms and Conditions ─────────────────────────────────────────────────────

const _termsEn = [
  _Section(
    'Last Updated: April 2026',
    'These Terms and Conditions ("Terms") govern your use of BestOneGolf ("the App"). '
        'By downloading or using the App, you agree to these Terms. If you do not agree, please do not use the App.',
  ),
  _Section(
    '1. Description of Service',
    'BestOneGolf is a golf score tracking application that calculates per-hole and total monetary '
        'settlements based on scores and rules configured by you. The App is intended for personal, '
        'non-commercial use among groups of players.',
  ),
  _Section(
    '2. Monetary Calculations',
    'All monetary calculations are provided as a convenience tool only. The App does not process, '
        'hold, transfer, or guarantee any real money. Users are solely responsible for verifying '
        'calculations and settling any financial agreements between themselves. The developer is not '
        'responsible for any financial disputes arising from use of the App.',
  ),
  _Section(
    '3. User Responsibilities',
    'You are responsible for: (a) ensuring all data entered is accurate; (b) using the App in '
        'compliance with all applicable local laws and regulations; (c) any monetary agreements '
        'made between players as a result of using the App.',
  ),
  _Section(
    '4. Advertising',
    'The App displays advertisements provided by Google AdMob. Ad content is controlled by Google '
        'and its advertising partners. You may permanently remove all ads by completing the '
        '"Remove Ads" in-app purchase.',
  ),
  _Section(
    '5. In-App Purchases',
    'The "Remove Ads" purchase is a one-time, non-consumable purchase processed by Apple App Store '
        '(iOS) or Google Play Store (Android). All purchases are final unless required otherwise '
        'by applicable law. Use "Restore Purchases" to recover your purchase after reinstalling '
        'the App on the same account.',
  ),
  _Section(
    '6. Intellectual Property',
    'All content, source code, design, and trademarks in the App are owned by the developer. '
        'You may not reproduce, modify, distribute, or create derivative works based on any '
        'part of the App without prior written permission.',
  ),
  _Section(
    '7. Disclaimer of Warranties',
    'The App is provided "as is" and "as available" without warranties of any kind, express or '
        'implied. The developer does not warrant that the App will be error-free, uninterrupted, '
        'secure, or that any calculations are guaranteed to be accurate.',
  ),
  _Section(
    '8. Limitation of Liability',
    'To the maximum extent permitted by applicable law, the developer shall not be liable for '
        'any indirect, incidental, special, consequential, or punitive damages, including loss of '
        'profits or data, arising from your use of or inability to use the App.',
  ),
  _Section(
    '9. Changes to These Terms',
    'These Terms may be updated from time to time. We will notify users of material changes '
        'through an App update. Continued use of the App after changes are posted constitutes '
        'your acceptance of the revised Terms.',
  ),
  _Section(
    '10. Contact',
    'If you have any questions about these Terms and Conditions, please contact us at:\n'
        'songpol.rungsawang@gmail.com',
  ),
];

const _termsTh = [
  _Section(
    'อัปเดตล่าสุด: เมษายน 2569',
    'ข้อกำหนดและเงื่อนไข ("ข้อกำหนด") เหล่านี้ควบคุมการใช้งาน BestOneGolf ("แอปพลิเคชัน") ของคุณ '
        'การดาวน์โหลดหรือใช้งานแอปพลิเคชัน หมายความว่าคุณตกลงยอมรับข้อกำหนดเหล่านี้ '
        'หากคุณไม่เห็นด้วย โปรดอย่าใช้แอปพลิเคชัน',
  ),
  _Section(
    '1. คำอธิบายบริการ',
    'BestOneGolf เป็นแอปพลิเคชันติดตามคะแนนกอล์ฟที่คำนวณการชำระเงินรายหลุมและยอดรวม '
        'ตามคะแนนและกฎที่คุณกำหนด แอปพลิเคชันนี้มีไว้สำหรับการใช้งานส่วนตัวที่ไม่ใช่เชิงพาณิชย์ '
        'ระหว่างกลุ่มผู้เล่น',
  ),
  _Section(
    '2. การคำนวณทางการเงิน',
    'การคำนวณทางการเงินทั้งหมดจัดให้เป็นเครื่องมืออำนวยความสะดวกเท่านั้น แอปพลิเคชันไม่ได้ '
        'ประมวลผล ถือครอง โอน หรือรับประกันเงินจริงใดๆ ผู้ใช้มีหน้าที่รับผิดชอบในการตรวจสอบ '
        'การคำนวณและชำระข้อตกลงทางการเงินระหว่างตนเองแต่ผู้เดียว '
        'ผู้พัฒนาไม่รับผิดชอบต่อข้อพิพาททางการเงินใดๆ ที่เกิดจากการใช้แอปพลิเคชัน',
  ),
  _Section(
    '3. ความรับผิดชอบของผู้ใช้',
    'คุณมีหน้าที่รับผิดชอบใน: (ก) การตรวจสอบว่าข้อมูลที่ป้อนถูกต้อง; '
        '(ข) การใช้แอปพลิเคชันให้สอดคล้องกับกฎหมายและระเบียบข้อบังคับที่บังคับใช้ทั้งหมด; '
        '(ค) ข้อตกลงทางการเงินใดๆ ที่เกิดขึ้นระหว่างผู้เล่นอันเป็นผลมาจากการใช้แอปพลิเคชัน',
  ),
  _Section(
    '4. การโฆษณา',
    'แอปพลิเคชันแสดงโฆษณาที่ให้บริการโดย Google AdMob เนื้อหาโฆษณาควบคุมโดย Google '
        'และพันธมิตรโฆษณา คุณสามารถลบโฆษณาทั้งหมดอย่างถาวรได้โดยซื้อ "ลบโฆษณา" ในแอปพลิเคชัน',
  ),
  _Section(
    '5. การซื้อในแอปพลิเคชัน',
    '"ลบโฆษณา" เป็นการซื้อครั้งเดียวแบบไม่ใช้แล้วหมดไป ประมวลผลโดย Apple App Store (iOS) '
        'หรือ Google Play Store (Android) การซื้อทั้งหมดถือเป็นที่สิ้นสุด เว้นแต่กฎหมายที่บังคับใช้ '
        'กำหนดเป็นอย่างอื่น ใช้ "คืนค่าการซื้อ" เพื่อกู้คืนการซื้อหลังจากติดตั้งแอปพลิเคชันใหม่ '
        'บนบัญชีเดียวกัน',
  ),
  _Section(
    '6. ทรัพย์สินทางปัญญา',
    'เนื้อหา รหัสต้นฉบับ การออกแบบ และเครื่องหมายการค้าทั้งหมดในแอปพลิเคชันเป็นของผู้พัฒนา '
        'คุณต้องไม่ทำซ้ำ ดัดแปลง แจกจ่าย หรือสร้างงานดัดแปลงจากส่วนใดๆ ของแอปพลิเคชัน '
        'โดยไม่ได้รับอนุญาตเป็นลายลักษณ์อักษรล่วงหน้า',
  ),
  _Section(
    '7. การปฏิเสธการรับประกัน',
    'แอปพลิเคชันให้บริการ "ตามที่เป็น" และ "ตามที่มีให้" โดยไม่มีการรับประกันใดๆ ทั้งสิ้น '
        'ผู้พัฒนาไม่รับประกันว่าแอปพลิเคชันจะปราศจากข้อผิดพลาด ไม่หยุดชะงัก ปลอดภัย '
        'หรือการคำนวณใดๆ จะถูกต้องแม่นยำ',
  ),
  _Section(
    '8. การจำกัดความรับผิด',
    'ตามขอบเขตสูงสุดที่กฎหมายที่บังคับใช้อนุญาต ผู้พัฒนาจะไม่รับผิดชอบต่อความเสียหายทางอ้อม '
        'โดยบังเอิญ พิเศษ เป็นผลสืบเนื่อง หรือการลงโทษใดๆ รวมถึงการสูญเสียกำไรหรือข้อมูล '
        'ที่เกิดจากการใช้หรือไม่สามารถใช้แอปพลิเคชันได้',
  ),
  _Section(
    '9. การเปลี่ยนแปลงข้อกำหนดเหล่านี้',
    'ข้อกำหนดเหล่านี้อาจมีการอัปเดตเป็นครั้งคราว เราจะแจ้งให้ผู้ใช้ทราบถึงการเปลี่ยนแปลง '
        'ที่สำคัญผ่านการอัปเดตแอปพลิเคชัน การใช้แอปพลิเคชันต่อไปหลังจากมีการโพสต์การเปลี่ยนแปลง '
        'ถือเป็นการยอมรับข้อกำหนดที่แก้ไขแล้วของคุณ',
  ),
  _Section(
    '10. ติดต่อเรา',
    'หากคุณมีคำถามเกี่ยวกับข้อกำหนดและเงื่อนไขเหล่านี้ โปรดติดต่อเราที่:\n'
        'songpol.rungsawang@gmail.com',
  ),
];

// ─── Privacy Policy ───────────────────────────────────────────────────────────

const _privacyEn = [
  _Section(
    'Last Updated: April 2026',
    'BestOneGolf ("we", "our", or "the App") is committed to protecting your privacy. '
        'This Privacy Policy explains what information is collected, how it is used, '
        'and your rights with respect to that information.',
  ),
  _Section(
    '1. Data We Collect and Store',
    'Game Data: All game records, scores, player names, team names, and settings are stored '
        'locally on your device using an on-device SQLite database. This data never leaves your '
        'device and is not transmitted to any external server or third party by us.\n\n'
        'App Preferences: Language, currency, display theme, and ad removal status are stored '
        'locally on your device.\n\n'
        'We do not collect, store, or transmit your name, email address, location, or any '
        'other personally identifiable information.',
  ),
  _Section(
    '2. Advertising — Google AdMob',
    'The App uses Google AdMob to display advertisements. AdMob may automatically collect '
        'and use the following information to serve ads:\n\n'
        '• Advertising ID (IDFA on iOS / GAID on Android)\n'
        '• Device model, OS version, and language\n'
        '• IP address and approximate location\n'
        '• Ad interaction and performance data\n\n'
        'This data is subject to Google\'s Privacy Policy:\n'
        'https://policies.google.com/privacy\n\n'
        'To limit ad personalization, adjust your device\'s advertising settings:\n'
        'iOS: Settings → Privacy & Security → Tracking\n'
        'Android: Settings → Google → Ads',
  ),
  _Section(
    '3. In-App Purchases',
    'The "Remove Ads" purchase is processed entirely by Apple App Store (iOS) or '
        'Google Play Store (Android). We do not receive, store, or have access to your '
        'payment details. Please refer to Apple\'s Privacy Policy or Google\'s Privacy Policy '
        'for information on how they handle your payment data.',
  ),
  _Section(
    '4. Data Retention',
    'All app data is stored locally on your device. It remains there until you delete '
        'individual game records within the App, or until you uninstall the App. '
        'We have no access to your data and cannot delete it on your behalf.',
  ),
  _Section(
    '5. Third-Party Services',
    'Other than Google AdMob (for ads) and Apple/Google (for in-app purchases), '
        'the App does not integrate with any third-party services, analytics platforms, '
        'or crash reporting tools.',
  ),
  _Section(
    '6. Children\'s Privacy',
    'The App is not directed at children under the age of 13. We do not knowingly collect '
        'personal information from children. If you believe a child has provided personal '
        'information through the App, please contact us and we will take appropriate action.',
  ),
  _Section(
    '7. Your Rights (PDPA / GDPR)',
    'Depending on your location, you may have rights regarding your personal data, including '
        'the right to access, correct, or delete it. Because all data is stored locally on '
        'your device, you can exercise these rights directly:\n\n'
        '• Access/Correct: View and edit game records within the App\n'
        '• Delete: Delete individual games or uninstall the App to remove all data\n\n'
        'For inquiries related to advertising data collected by Google, contact Google directly '
        'or adjust your device\'s ad settings.',
  ),
  _Section(
    '8. Changes to This Policy',
    'We may update this Privacy Policy from time to time. Significant changes will be '
        'communicated through an App update notice. Your continued use of the App after '
        'a policy update constitutes acceptance of the revised policy.',
  ),
  _Section(
    '9. Contact',
    'If you have questions or concerns about this Privacy Policy, please contact us at:\n'
        'songpol.rungsawang@gmail.com',
  ),
];

const _privacyTh = [
  _Section(
    'อัปเดตล่าสุด: เมษายน 2569',
    'BestOneGolf ("เรา" หรือ "แอปพลิเคชัน") มุ่งมั่นในการปกป้องความเป็นส่วนตัวของคุณ '
        'นโยบายความเป็นส่วนตัวนี้อธิบายว่าข้อมูลใดถูกรวบรวม ใช้อย่างไร '
        'และสิทธิ์ของคุณเกี่ยวกับข้อมูลนั้น',
  ),
  _Section(
    '1. ข้อมูลที่เรารวบรวมและจัดเก็บ',
    'ข้อมูลเกม: บันทึกเกม คะแนน ชื่อผู้เล่น ชื่อทีม และการตั้งค่าทั้งหมดจะถูกจัดเก็บ '
        'ในเครื่องบนอุปกรณ์ของคุณโดยใช้ฐานข้อมูล SQLite ในอุปกรณ์ ข้อมูลนี้จะไม่ออกจาก '
        'อุปกรณ์ของคุณและไม่ถูกส่งไปยังเซิร์ฟเวอร์ภายนอกหรือบุคคลที่สามโดยเรา\n\n'
        'การตั้งค่าแอปพลิเคชัน: ภาษา สกุลเงิน ธีมการแสดงผล และสถานะการลบโฆษณา '
        'จะถูกจัดเก็บในเครื่องบนอุปกรณ์ของคุณ\n\n'
        'เราไม่รวบรวม จัดเก็บ หรือส่งชื่อ อีเมล ที่ตั้ง หรือข้อมูลที่สามารถระบุตัวตนได้อื่นๆ ของคุณ',
  ),
  _Section(
    '2. การโฆษณา — Google AdMob',
    'แอปพลิเคชันใช้ Google AdMob เพื่อแสดงโฆษณา AdMob อาจรวบรวมและใช้ข้อมูลต่อไปนี้ '
        'โดยอัตโนมัติเพื่อแสดงโฆษณา:\n\n'
        '• รหัสโฆษณา (IDFA บน iOS / GAID บน Android)\n'
        '• รุ่นอุปกรณ์ เวอร์ชัน OS และภาษา\n'
        '• ที่อยู่ IP และตำแหน่งโดยประมาณ\n'
        '• ข้อมูลการโต้ตอบและประสิทธิภาพของโฆษณา\n\n'
        'ข้อมูลนี้อยู่ภายใต้นโยบายความเป็นส่วนตัวของ Google:\n'
        'https://policies.google.com/privacy\n\n'
        'หากต้องการจำกัดการปรับแต่งโฆษณา ให้ปรับการตั้งค่าโฆษณาของอุปกรณ์:\n'
        'iOS: การตั้งค่า → ความเป็นส่วนตัวและความปลอดภัย → การติดตาม\n'
        'Android: การตั้งค่า → Google → โฆษณา',
  ),
  _Section(
    '3. การซื้อในแอปพลิเคชัน',
    'การซื้อ "ลบโฆษณา" ดำเนินการทั้งหมดโดย Apple App Store (iOS) หรือ Google Play Store (Android) '
        'เราไม่รับ จัดเก็บ หรือเข้าถึงรายละเอียดการชำระเงินของคุณ โปรดดูนโยบายความเป็นส่วนตัว '
        'ของ Apple หรือ Google สำหรับข้อมูลเกี่ยวกับวิธีที่พวกเขาจัดการข้อมูลการชำระเงินของคุณ',
  ),
  _Section(
    '4. การเก็บรักษาข้อมูล',
    'ข้อมูลแอปพลิเคชันทั้งหมดถูกจัดเก็บในเครื่องบนอุปกรณ์ของคุณ ข้อมูลจะอยู่ที่นั่นจนกว่า '
        'คุณจะลบบันทึกเกมแต่ละรายการในแอปพลิเคชัน หรือจนกว่าคุณจะถอนการติดตั้งแอปพลิเคชัน '
        'เราไม่มีสิทธิ์เข้าถึงข้อมูลของคุณและไม่สามารถลบข้อมูลแทนคุณได้',
  ),
  _Section(
    '5. บริการของบุคคลที่สาม',
    'นอกจาก Google AdMob (สำหรับโฆษณา) และ Apple/Google (สำหรับการซื้อในแอปพลิเคชัน) '
        'แอปพลิเคชันไม่ได้รวมเข้ากับบริการของบุคคลที่สาม แพลตฟอร์มวิเคราะห์ '
        'หรือเครื่องมือรายงานข้อผิดพลาดใดๆ',
  ),
  _Section(
    '6. ความเป็นส่วนตัวของเด็ก',
    'แอปพลิเคชันไม่ได้มุ่งเป้าไปที่เด็กอายุต่ำกว่า 13 ปี เราไม่รวบรวมข้อมูลส่วนบุคคล '
        'จากเด็กโดยรู้ตัว หากคุณเชื่อว่าเด็กได้ให้ข้อมูลส่วนบุคคลผ่านแอปพลิเคชัน '
        'โปรดติดต่อเราและเราจะดำเนินการที่เหมาะสม',
  ),
  _Section(
    '7. สิทธิ์ของคุณ (PDPA)',
    'ภายใต้พระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล (PDPA) คุณอาจมีสิทธิ์เกี่ยวกับข้อมูลส่วนบุคคล '
        'ของคุณ รวมถึงสิทธิ์ในการเข้าถึง แก้ไข หรือลบข้อมูลนั้น เนื่องจากข้อมูลทั้งหมด '
        'ถูกจัดเก็บในเครื่องบนอุปกรณ์ของคุณ คุณสามารถใช้สิทธิ์เหล่านี้ได้โดยตรง:\n\n'
        '• เข้าถึง/แก้ไข: ดูและแก้ไขบันทึกเกมภายในแอปพลิเคชัน\n'
        '• ลบ: ลบเกมแต่ละรายการหรือถอนการติดตั้งแอปพลิเคชันเพื่อลบข้อมูลทั้งหมด\n\n'
        'สำหรับคำถามที่เกี่ยวข้องกับข้อมูลโฆษณาที่ Google รวบรวม โปรดติดต่อ Google โดยตรง '
        'หรือปรับการตั้งค่าโฆษณาของอุปกรณ์',
  ),
  _Section(
    '8. การเปลี่ยนแปลงนโยบายนี้',
    'เราอาจอัปเดตนโยบายความเป็นส่วนตัวนี้เป็นครั้งคราว การเปลี่ยนแปลงที่สำคัญจะถูก '
        'สื่อสารผ่านการแจ้งเตือนการอัปเดตแอปพลิเคชัน การใช้แอปพลิเคชันต่อไปของคุณหลังจาก '
        'การอัปเดตนโยบายถือเป็นการยอมรับนโยบายที่แก้ไขแล้ว',
  ),
  _Section(
    '9. ติดต่อเรา',
    'หากคุณมีคำถามหรือข้อกังวลเกี่ยวกับนโยบายความเป็นส่วนตัวนี้ โปรดติดต่อเราที่:\n'
        'songpol.rungsawang@gmail.com',
  ),
];
