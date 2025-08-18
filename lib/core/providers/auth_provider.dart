import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  
  // User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  
  AuthProvider() {
    // _auth.authStateChanges().listen(_onAuthStateChanged);
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      
      // Simulate authentication for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      
      if (email == "demo@example.com" && password == "password") {
        _isAuthenticated = true;
        _userModel = UserModel(
          uid: "demo-user",
          email: email,
          firstName: "Demo",
          lastName: "User",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      } else {
        _setError("Invalid email or password");
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> createUserWithEmailAndPassword(String email, String password, {
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      
      // Simulate user creation for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      
      _isAuthenticated = true;
      _userModel = UserModel(
        uid: "new-user-${DateTime.now().millisecondsSinceEpoch}",
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> signOut() async {
    try {
      _isAuthenticated = false;
      _userModel = null;
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed: $e');
    }
  }
  
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);
      
      // Simulate password reset
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      _setError('Password reset failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  void clearError() {
    _setError(null);
  }
}
