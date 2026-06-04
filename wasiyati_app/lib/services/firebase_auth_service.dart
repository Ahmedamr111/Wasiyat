import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

/// Firebase implementation of [AuthService]
class FirebaseAuthService implements AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ── Stream ──────────────────────────────────────────────────────────────────

  @override
  Stream<UserModel?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        return await _fetchOrCreateUserModel(firebaseUser);
      } catch (e) {
        // If we can't load user doc, return a minimal model from Firebase Auth
        return _userModelFromFirebaseUser(firebaseUser);
      }
    });
  }

  // ── Current User ─────────────────────────────────────────────────────────

  @override
  UserModel? get currentUser => null; // Use stream in app, not this getter

  // ── Sign In ───────────────────────────────────────────────────────────────

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _fetchOrCreateUserModel(cred.user!);
  }

  // ── Sign Up ───────────────────────────────────────────────────────────────

  @override
  Future<UserModel> signUpWithEmail(
      String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fbUser = cred.user!;

    // Create user document in Firestore
    final user = UserModel(
      id: fbUser.uid,
      name: name,
      email: email,
      language: 'en',
      createdAt: DateTime.now(),
    );
    await _db.collection('users').doc(fbUser.uid).set(user.toJson());
    return user;
  }

  // ── Google Sign In ────────────────────────────────────────────────────────

  @override
  Future<UserModel> signInWithGoogle() async {
    final googleAccount = await _googleSignIn.signIn();
    if (googleAccount == null) {
      throw Exception('Google Sign-In cancelled');
    }

    final googleAuth = await googleAccount.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    return _fetchOrCreateUserModel(cred.user!);
  }

  // ── Apple Sign In (stub — iOS only) ───────────────────────────────────────

  @override
  Future<UserModel> signInWithApple() async {
    throw UnimplementedError(
        'Apple Sign-In is iOS only and not configured yet.');
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut().catchError((_) => null);
    await _auth.signOut();
  }

  // ── Password Reset ────────────────────────────────────────────────────────

  @override
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ── Update Profile ────────────────────────────────────────────────────────

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
    String? language,
    String? country,
    String? securityPhraseHash,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not signed in');

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (phone != null) updates['phone'] = phone;
    if (photoUrl != null) updates['photoUrl'] = photoUrl;
    if (language != null) updates['language'] = language;
    if (country != null) updates['country'] = country;
    if (securityPhraseHash != null) updates['securityPhraseHash'] = securityPhraseHash;
    updates['updatedAt'] = FieldValue.serverTimestamp();

    await _db.collection('users').doc(uid).update(updates);
    return (await _fetchUserModelById(uid))!;
  }

  // ── Check In ──────────────────────────────────────────────────────────────

  @override
  Future<void> checkIn() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not signed in');

    await _db.collection('users').doc(uid).update({
      'lastCheckIn': FieldValue.serverTimestamp(),
    });
  }

  // ── Private Helpers ──────────────────────────────────────────────────────

  /// Fetches user doc from Firestore, creates it if it doesn't exist yet
  Future<UserModel> _fetchOrCreateUserModel(fb.User fbUser) async {
    final docRef = _db.collection('users').doc(fbUser.uid);
    final doc = await docRef.get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson({...doc.data()!, 'id': fbUser.uid});
    }

    // Auto-create doc from Firebase Auth profile (first sign-in)
    final user = _userModelFromFirebaseUser(fbUser);
    await docRef.set(user.toJson());
    return user;
  }

  /// Builds a UserModel directly from Firebase Auth data (no Firestore needed)
  UserModel _userModelFromFirebaseUser(fb.User fbUser) {
    return UserModel(
      id: fbUser.uid,
      name: fbUser.displayName ?? fbUser.email?.split('@').first ?? 'User',
      email: fbUser.email ?? '',
      photoUrl: fbUser.photoURL,
      phone: fbUser.phoneNumber,
      language: 'en',
      createdAt: DateTime.now(),
    );
  }

  /// Fetches user doc by UID only
  Future<UserModel?> _fetchUserModelById(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromJson({...doc.data()!, 'id': uid});
  }
}

