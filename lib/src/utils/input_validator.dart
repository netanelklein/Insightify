/// Input validation utilities for user-facing data entry points
/// 
/// This utility class provides comprehensive input sanitization and validation
/// methods to protect against security vulnerabilities and ensure data integrity.
library;

import 'dart:convert';

class InputValidator {
  /// Maximum length for search queries to prevent excessive memory usage
  static const int maxSearchLength = 500;
  
  /// Maximum length for general text input fields
  static const int maxTextLength = 1000;
  
  /// Regex pattern for basic text sanitization (allows alphanumeric, spaces, and common punctuation)
  static final RegExp _safeTextPattern = RegExp(r'''^[a-zA-Z0-9\s\-_.,!?'"()&@#%]+$''');
  
  /// Regex pattern for artist/track names (allows Unicode characters for international names)
  static final RegExp _musicNamePattern = RegExp(r'''^[a-zA-Z0-9\u00C0-\u017F\u0100-\u024F\s\-_.,!?'"()&@#%/]+$''');
  
  /// Sanitizes search query input from the search bar
  /// 
  /// Removes potentially dangerous characters and limits length
  /// Returns null if input is invalid or empty after sanitization
  static String? sanitizeSearchQuery(String? input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }
    
    // Trim whitespace and limit length
    final sanitized = input.trim();
    if (sanitized.length > maxSearchLength) {
      return sanitized.substring(0, maxSearchLength);
    }
    
    // Basic sanitization - remove control characters
    final cleaned = sanitized.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    
    return cleaned.isEmpty ? null : cleaned;
  }
  
  /// Validates and sanitizes artist/track names for API calls
  /// 
  /// Ensures the input is safe for use in Spotify API queries
  /// Returns null if input is invalid
  static String? sanitizeMusicName(String? input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }
    
    final sanitized = input.trim();
    if (sanitized.length > maxTextLength) {
      return null; // Reject overly long inputs
    }
    
    // Allow Unicode characters for international artist/track names
    if (!_musicNamePattern.hasMatch(sanitized)) {
      // If it doesn't match the pattern, do basic sanitization
      final cleaned = sanitized.replaceAll(RegExp(r'''[^a-zA-Z0-9\u00C0-\u017F\u0100-\u024F\s\-_.,!?'"()&@#%/]'''), '');
      return cleaned.isEmpty ? null : cleaned;
    }
    
    return sanitized;
  }
  
  /// Validates JSON content before parsing
  /// 
  /// Performs basic structure validation to prevent JSON bombing attacks
  /// Returns true if the JSON appears safe to parse
  static bool validateJsonStructure(String jsonString) {
    if (jsonString.isEmpty) {
      return false;
    }
    
    // Check for reasonable size (prevent memory exhaustion)
    const maxJsonSize = 100 * 1024 * 1024; // 100MB limit
    if (jsonString.length > maxJsonSize) {
      return false;
    }
    
    // Check for excessive nesting depth (prevent stack overflow)
    int depth = 0;
    int maxDepth = 0;
    
    for (int i = 0; i < jsonString.length; i++) {
      final char = jsonString[i];
      if (char == '{' || char == '[') {
        depth++;
        if (depth > maxDepth) {
          maxDepth = depth;
        }
        // Prevent excessive nesting
        if (depth > 100) {
          return false;
        }
      } else if (char == '}' || char == ']') {
        depth--;
      }
    }
    
    return true;
  }
  
  /// Safely parses JSON with validation
  /// 
  /// Returns null if JSON is invalid or potentially dangerous
  static dynamic safeJsonParse(String jsonString) {
    if (!validateJsonStructure(jsonString)) {
      return null;
    }
    
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      // JSON parsing failed
      return null;
    }
  }
  
  /// Validates URL format for external links
  /// 
  /// Ensures URLs are properly formatted and use safe protocols
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    
    try {
      final uri = Uri.parse(url);
      // Only allow HTTP and HTTPS protocols and ensure host is not empty
      return uri.hasScheme && 
             (uri.scheme == 'http' || uri.scheme == 'https') &&
             uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  /// Sanitizes file paths for security
  /// 
  /// Prevents directory traversal attacks and validates file extensions
  static String? sanitizeFilePath(String? filePath, List<String> allowedExtensions) {
    if (filePath == null || filePath.isEmpty) {
      return null;
    }
    
    // Remove path traversal attempts
    final sanitized = filePath.replaceAll(RegExp(r'\.\.[\\/]'), '');
    
    // Check file extension
    final extension = sanitized.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      return null;
    }
    
    return sanitized;
  }
  
  /// Validates numeric input ranges
  /// 
  /// Ensures numeric values are within acceptable bounds
  static bool isValidNumericRange(num? value, num min, num max) {
    return value != null && value >= min && value <= max;
  }
  
  /// Sanitizes text for display purposes
  /// 
  /// Removes potentially harmful characters but preserves readability
  static String sanitizeForDisplay(String? input) {
    if (input == null) return '';
    
    // Remove control characters and null bytes
    return input.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');
  }
}
