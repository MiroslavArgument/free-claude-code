import 'package:flutter/material.dart';

class MockAccount {
  const MockAccount({
    required this.title,
    required this.subtitle,
    required this.flagEmoji,
    required this.flagColor,
    required this.amount,
  });

  final String title;
  final String subtitle;
  final String flagEmoji;
  final Color flagColor;
  final String amount;
}

const List<MockAccount> mockAccounts = [
  MockAccount(
    title: 'Personal • EUR',
    subtitle: 'Main euro',
    flagEmoji: '🇪🇺',
    flagColor: Color(0xFF003399),
    amount: '15 999,74 €',
  ),
  MockAccount(
    title: 'US account • USD',
    subtitle: 'Travel USD',
    flagEmoji: '🇺🇸',
    flagColor: Color(0xFFB22234),
    amount: '100 \$',
  ),
  MockAccount(
    title: 'Travel • SEK',
    subtitle: 'Sweden',
    flagEmoji: '🇸🇪',
    flagColor: Color(0xFF006AA7),
    amount: '0 kr',
  ),
];

class MockTransaction {
  const MockTransaction({
    required this.title,
    required this.time,
    required this.amount,
    required this.icon,
    required this.isCredit,
  });

  final String title;
  final String time;
  final String amount;
  final IconData icon;
  final bool isCredit;
}

class MockTransactionGroup {
  const MockTransactionGroup({
    required this.label,
    required this.dailyTotal,
    required this.items,
  });

  final String label;
  final String dailyTotal;
  final List<MockTransaction> items;
}

const _baseGroup = [
  MockTransaction(
    title: 'Amazon',
    time: '12:14 pm',
    amount: '-116,81 €',
    icon: Icons.shopping_bag_outlined,
    isCredit: false,
  ),
  MockTransaction(
    title: 'Top-up · Apple pay',
    time: '12:14 pm',
    amount: '+2 100 €',
    icon: Icons.download_rounded,
    isCredit: true,
  ),
  MockTransaction(
    title: 'Sent to Alex B.',
    time: '12:14 pm',
    amount: '-150 €',
    icon: Icons.north_east_rounded,
    isCredit: false,
  ),
];

const List<MockTransactionGroup> mockTransactionGroups = [
  MockTransactionGroup(
    label: 'Today',
    dailyTotal: '+2 197,19 €',
    items: _baseGroup,
  ),
  MockTransactionGroup(
    label: 'Yesterday',
    dailyTotal: '+2 197,19 €',
    items: _baseGroup,
  ),
  MockTransactionGroup(
    label: '9 February',
    dailyTotal: '+2 197,19 €',
    items: _baseGroup,
  ),
];

class MockContact {
  const MockContact({
    required this.name,
    required this.subtitle,
    required this.date,
    required this.initials,
    required this.isTrumia,
    required this.color,
  });

  final String name;
  final String subtitle;
  final String date;
  final String initials;
  final bool isTrumia;
  final Color color;
}

const List<MockContact> mockContacts = [
  MockContact(
    name: 'Hans Schmidt',
    subtitle: '+356 2123 4567',
    date: '5 Mar',
    initials: 'HS',
    isTrumia: true,
    color: Color(0xFFEDEEF1),
  ),
  MockContact(
    name: 'Sophie Dubois',
    subtitle: '1234 5678 9010 1234',
    date: '20 Mar',
    initials: 'SD',
    isTrumia: false,
    color: Color(0xFFE8C9A8),
  ),
  MockContact(
    name: 'Lars V.',
    subtitle: 'FR14 2004 1010 0505 0001 3M02 6',
    date: '19 Feb',
    initials: 'LV',
    isTrumia: false,
    color: Color(0xFFEDEEF1),
  ),
  MockContact(
    name: 'Inga Müller',
    subtitle: 'IT60 X054 2811 1010 0000 0123 456',
    date: '8 Feb',
    initials: 'IM',
    isTrumia: false,
    color: Color(0xFFEDEEF1),
  ),
  MockContact(
    name: 'Luca Rossi',
    subtitle: '3457 1235 1563 2356',
    date: '1 Jan',
    initials: 'LR',
    isTrumia: false,
    color: Color(0xFFA5A5A8),
  ),
  MockContact(
    name: 'Bjorn S.',
    subtitle: 'SE45 5000 0000 0583 9825 7466',
    date: '26 Dec',
    initials: 'BS',
    isTrumia: false,
    color: Color(0xFFEDEEF1),
  ),
];
