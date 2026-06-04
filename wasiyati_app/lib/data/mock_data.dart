import '../models/user_model.dart';
import '../models/message_model.dart';
import '../models/recipient_model.dart';
import '../models/trusted_contact_model.dart';
import '../models/trigger_model.dart';
import '../models/vault_item_model.dart';

/// Mock data for development — simulates Firestore data
class MockData {
  MockData._();

  // ── Current User ──
  static final UserModel currentUser = UserModel(
    id: 'user_001',
    name: 'Ahmed',
    email: 'ahmed@example.com',
    phone: '+966501234567',
    photoUrl: null,
    language: 'en',
    country: 'SA',
    timezone: 'Asia/Riyadh',
    plan: UserPlan.free,
    trustedContactIds: ['tc_001'],
    lastCheckIn: DateTime.now().subtract(const Duration(days: 7)),
    securityPhraseHash: 'hashed_phrase_example',
    createdAt: DateTime(2025, 1, 15),
  );

  // ── Recipients ──
  static final List<RecipientModel> recipients = [
    RecipientModel(
      id: 'rec_001',
      userId: 'user_001',
      name: 'Sara',
      relationship: 'Daughter',
      language: 'ar',
      email: 'sara@example.com',
      phone: '+966509876543',
      whatsapp: '+966509876543',
      createdAt: DateTime(2025, 2, 1),
    ),
    RecipientModel(
      id: 'rec_002',
      userId: 'user_001',
      name: 'Khalid',
      relationship: 'Son',
      language: 'en',
      email: 'khalid@example.com',
      phone: '+966507654321',
      whatsapp: '+966507654321',
      createdAt: DateTime(2025, 2, 5),
    ),
    RecipientModel(
      id: 'rec_003',
      userId: 'user_001',
      name: 'Fatima',
      relationship: 'Wife',
      language: 'ar',
      email: 'fatima@example.com',
      phone: '+966508765432',
      whatsapp: '+966508765432',
      createdAt: DateTime(2025, 2, 10),
    ),
    RecipientModel(
      id: 'rec_004',
      userId: 'user_001',
      name: 'Omar',
      relationship: 'Friend',
      language: 'en',
      email: 'omar@example.com',
      createdAt: DateTime(2025, 3, 1),
    ),
    RecipientModel(
      id: 'rec_005',
      userId: 'user_001',
      name: 'Aisha',
      relationship: 'Mother',
      language: 'ar',
      email: 'aisha@example.com',
      phone: '+966502345678',
      createdAt: DateTime(2025, 3, 15),
    ),
  ];

  // ── Messages ──
  static final List<MessageModel> messages = [
    MessageModel(
      id: 'msg_001',
      userId: 'user_001',
      title: 'To my beloved children',
      type: MessageType.immediate,
      contentType: ContentType.text,
      contentPlain:
          'My dearest children,\n\nBy the time you read this, I will have returned to my Lord. '
          'Know that every moment I spent with you was the greatest blessing of my life.\n\n'
          'Sara, you are the light of my eyes. Your kindness and wisdom remind me of your grandmother. '
          'Never lose that gentle heart.\n\n'
          'Khalid, my son, you carry the family\'s strength. Be patient with the world, '
          'and the world will be patient with you.\n\n'
          'Take care of your mother. She is the best thing that ever happened to me.\n\n'
          'With all my love,\nYour father',
      recipients: [
        const MessageRecipient(recipientId: 'rec_001', channel: 'email'),
        const MessageRecipient(recipientId: 'rec_002', channel: 'whatsapp'),
      ],
      createdAt: DateTime(2025, 3, 1),
      updatedAt: DateTime(2025, 5, 20),
    ),
    MessageModel(
      id: 'msg_002',
      userId: 'user_001',
      title: 'Friday blessing — every week',
      type: MessageType.recurring,
      contentType: ContentType.text,
      contentPlain:
          'Assalamu Alaikum, my family 🌿\n\n'
          'May this Friday bring you peace, mercy, and blessings. '
          'Remember me in your prayers.\n\n'
          'جمعة مباركة\n\nWith love always.',
      recipients: [
        const MessageRecipient(recipientId: 'rec_001', channel: 'whatsapp'),
        const MessageRecipient(recipientId: 'rec_002', channel: 'whatsapp'),
        const MessageRecipient(recipientId: 'rec_003', channel: 'whatsapp'),
      ],
      schedule: const MessageSchedule(
        recurringType: RecurringType.weekly,
        recurringFor: RecurringDuration.forever,
      ),
      createdAt: DateTime(2025, 3, 10),
      updatedAt: DateTime(2025, 5, 18),
    ),
    MessageModel(
      id: 'msg_003',
      userId: 'user_001',
      title: 'Happy birthday, Sara',
      type: MessageType.occasion,
      contentType: ContentType.text,
      contentPlain:
          'Happy Birthday, my beautiful Sara! 🎂\n\n'
          'Another year has passed, and even though I am no longer with you in person, '
          'know that I am always with you in spirit.\n\n'
          'Every birthday, I want you to remember: you are loved beyond measure. '
          'Celebrate life. Be happy. Make the world a little brighter.\n\n'
          'Happy birthday, habibti ❤️\nBaba',
      recipients: [
        const MessageRecipient(recipientId: 'rec_001', channel: 'email'),
        const MessageRecipient(recipientId: 'rec_001', channel: 'whatsapp'),
      ],
      schedule: MessageSchedule(
        occasionDate: DateTime(2025, 6, 14),
      ),
      createdAt: DateTime(2025, 4, 1),
      updatedAt: DateTime(2025, 5, 15),
    ),
    MessageModel(
      id: 'msg_004',
      userId: 'user_001',
      title: 'For Fatima — my everything',
      type: MessageType.immediate,
      contentType: ContentType.text,
      contentPlain:
          'My dearest Fatima,\n\n'
          'You were my partner, my best friend, my comfort in this world. '
          'Thank you for every smile, every prayer, every meal shared.\n\n'
          'Be strong. The children need you. And remember — '
          'I will be waiting for you in Jannah, inshaAllah.\n\n'
          'Your Ahmed, always.',
      recipients: [
        const MessageRecipient(recipientId: 'rec_003', channel: 'email'),
      ],
      isPinLocked: true,
      createdAt: DateTime(2025, 4, 10),
      updatedAt: DateTime(2025, 5, 22),
    ),
    MessageModel(
      id: 'msg_005',
      userId: 'user_001',
      title: 'When Khalid graduates',
      type: MessageType.milestone,
      contentType: ContentType.text,
      contentPlain:
          'Khalid, my son,\n\n'
          'If you are reading this, you did it. You graduated! 🎓\n\n'
          'I always knew you had it in you. Your determination, your hard work — '
          'they have all paid off. I am so proud of you.\n\n'
          'Now go and change the world. But never forget where you came from.\n\n'
          'With immense pride,\nYour father',
      recipients: [
        const MessageRecipient(recipientId: 'rec_002', channel: 'email'),
      ],
      schedule: const MessageSchedule(
        milestoneLabel: 'When my son graduates from university',
      ),
      createdAt: DateTime(2025, 4, 20),
      updatedAt: DateTime(2025, 5, 10),
    ),
    MessageModel(
      id: 'msg_006',
      userId: 'user_001',
      title: 'Ramadan message — yearly',
      type: MessageType.recurring,
      contentType: ContentType.text,
      contentPlain:
          'Ramadan Mubarak, my beloved family! 🌙\n\n'
          'As you begin this blessed month, remember to be patient, '
          'generous, and kind. Fast with your body, but also with your tongue '
          'and your heart.\n\n'
          'I miss breaking fast with you. But inshaAllah, '
          'we will share iftar together in Jannah.\n\n'
          'May Allah accept your fasting and prayers.\n\n'
          'رمضان كريم 🤲',
      recipients: [
        const MessageRecipient(recipientId: 'rec_001', channel: 'whatsapp'),
        const MessageRecipient(recipientId: 'rec_002', channel: 'whatsapp'),
        const MessageRecipient(recipientId: 'rec_003', channel: 'whatsapp'),
        const MessageRecipient(recipientId: 'rec_005', channel: 'whatsapp'),
      ],
      schedule: const MessageSchedule(
        recurringType: RecurringType.yearly,
        recurringFor: RecurringDuration.forever,
      ),
      createdAt: DateTime(2025, 5, 1),
      updatedAt: DateTime(2025, 5, 25),
    ),
    MessageModel(
      id: 'msg_007',
      userId: 'user_001',
      title: 'To my dear friend Omar',
      type: MessageType.immediate,
      contentType: ContentType.text,
      contentPlain:
          'Omar, my brother in spirit,\n\n'
          'You were more than a friend — you were family. '
          'Thank you for all the laughter, the advice, and the memories.\n\n'
          'Take care of yourself. And please, check on my family from time to time.\n\n'
          'Until we meet again,\nAhmed',
      recipients: [
        const MessageRecipient(recipientId: 'rec_004', channel: 'email'),
      ],
      createdAt: DateTime(2025, 5, 5),
      updatedAt: DateTime(2025, 5, 28),
    ),
  ];

  // ── Trusted Contacts ──
  static final List<TrustedContactModel> trustedContacts = [
    TrustedContactModel(
      id: 'tc_001',
      userId: 'user_001',
      name: 'Mohamed',
      relationship: 'Brother',
      externalEmail: 'mohamed@example.com',
      status: TrustedContactStatus.accepted,
      invitedAt: DateTime(2025, 2, 1),
      acceptedAt: DateTime(2025, 2, 3),
    ),
  ];

  // ── Trigger (Dead Man's Switch) ──
  static final TriggerModel currentTrigger = TriggerModel(
    id: 'trigger_001',
    userId: 'user_001',
    status: TriggerStatus.watching,
    lastCheckInSent: DateTime.now().subtract(const Duration(days: 7)),
    checkInDeadline: DateTime.now().add(const Duration(days: 23)),
  );

  // ── Vault Items ──
  static final List<VaultItemModel> vaultItems = [
    VaultItemModel(
      id: 'vault_001',
      userId: 'user_001',
      type: VaultItemType.digitalWill,
      title: 'My Last Will & Testament',
      contentPlain:
          'This is a summary of my wishes regarding the distribution of my assets...',
      createdAt: DateTime(2025, 4, 1),
      updatedAt: DateTime(2025, 5, 20),
    ),
    VaultItemModel(
      id: 'vault_002',
      userId: 'user_001',
      type: VaultItemType.credentials,
      title: 'Important Accounts',
      metadata: {
        'Bank Account': 'See attached document',
        'Email Password': 'Delivered posthumously',
        'Social Media': 'Please close all accounts',
      },
      createdAt: DateTime(2025, 4, 5),
      updatedAt: DateTime(2025, 5, 15),
    ),
    VaultItemModel(
      id: 'vault_003',
      userId: 'user_001',
      type: VaultItemType.letterToWorld,
      title: 'A Letter to the World',
      contentPlain:
          'To whoever reads this,\n\n'
          'Life is short. Tell the people you love that you love them. '
          'Don\'t wait. Don\'t assume they know.\n\n'
          'Be kind. Be generous. Be patient.\n\n'
          'And remember — the words you leave behind are the most precious gift you can give.\n\n'
          'With hope,\nAhmed',
      isPublic: true,
      createdAt: DateTime(2025, 5, 1),
      updatedAt: DateTime(2025, 5, 25),
    ),
  ];
}
