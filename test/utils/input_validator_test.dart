import 'package:flutter_test/flutter_test.dart';
import 'package:insightify/src/utils/input_validator.dart';

void main() {
  group('InputValidator', () {
    group('sanitizeSearchQuery', () {
      test('should return null for empty input', () {
        expect(InputValidator.sanitizeSearchQuery(''), isNull);
        expect(InputValidator.sanitizeSearchQuery('   '), isNull);
        expect(InputValidator.sanitizeSearchQuery(null), isNull);
      });

      test('should trim whitespace', () {
        expect(InputValidator.sanitizeSearchQuery('  hello  '), equals('hello'));
      });

      test('should limit length to maxSearchLength', () {
        final longString = 'a' * 600;
        final result = InputValidator.sanitizeSearchQuery(longString);
        expect(result?.length, equals(InputValidator.maxSearchLength));
      });

      test('should remove control characters', () {
        const input = 'hello\x00\x1F\x7Fworld';
        final result = InputValidator.sanitizeSearchQuery(input);
        expect(result, equals('helloworld'));
      });

      test('should handle normal search queries', () {
        expect(InputValidator.sanitizeSearchQuery('The Beatles'), equals('The Beatles'));
        expect(InputValidator.sanitizeSearchQuery("Rock 'n' Roll"), equals("Rock 'n' Roll"));
        expect(InputValidator.sanitizeSearchQuery('Song Title (feat. Artist)'), 
               equals('Song Title (feat. Artist)'));
      });
    });

    group('sanitizeMusicName', () {
      test('should return null for empty input', () {
        expect(InputValidator.sanitizeMusicName(''), isNull);
        expect(InputValidator.sanitizeMusicName('   '), isNull);
        expect(InputValidator.sanitizeMusicName(null), isNull);
      });

      test('should reject overly long inputs', () {
        final longString = 'a' * 1100;
        expect(InputValidator.sanitizeMusicName(longString), isNull);
      });

      test('should handle valid music names', () {
        expect(InputValidator.sanitizeMusicName('The Beatles'), equals('The Beatles'));
        expect(InputValidator.sanitizeMusicName('Björk'), equals('Björk'));
        expect(InputValidator.sanitizeMusicName('AC/DC'), equals('AC/DC'));
      });

      test('should sanitize invalid characters', () {
        const input = 'Song<script>alert("xss")</script>';
        final result = InputValidator.sanitizeMusicName(input);
        expect(result, equals('Songscriptalert("xss")/script')); // Remove < and > but keep valid chars like /
      });
    });

    group('validateJsonStructure', () {
      test('should return false for empty string', () {
        expect(InputValidator.validateJsonStructure(''), isFalse);
      });

      test('should return false for excessively large JSON', () {
        final largeJson = '{"data": "${'a' * (100 * 1024 * 1024 + 1)}"}';
        expect(InputValidator.validateJsonStructure(largeJson), isFalse);
      });

      test('should return false for excessive nesting', () {
        String deeplyNested = '';
        for (int i = 0; i < 110; i++) {
          deeplyNested += '{';
        }
        for (int i = 0; i < 110; i++) {
          deeplyNested += '}';
        }
        expect(InputValidator.validateJsonStructure(deeplyNested), isFalse);
      });

      test('should return true for valid JSON structure', () {
        const validJson = '{"name": "test", "data": [1, 2, 3]}';
        expect(InputValidator.validateJsonStructure(validJson), isTrue);
      });

      test('should handle reasonable nesting', () {
        const nestedJson = '{"a": {"b": {"c": {"d": "value"}}}}';
        expect(InputValidator.validateJsonStructure(nestedJson), isTrue);
      });
    });

    group('safeJsonParse', () {
      test('should return null for invalid JSON structure', () {
        expect(InputValidator.safeJsonParse(''), isNull);
      });

      test('should return null for malformed JSON', () {
        expect(InputValidator.safeJsonParse('{"invalid": json}'), isNull);
      });

      test('should parse valid JSON', () {
        const validJson = '{"name": "test", "count": 42}';
        final result = InputValidator.safeJsonParse(validJson);
        expect(result, isA<Map<String, dynamic>>());
        expect(result['name'], equals('test'));
        expect(result['count'], equals(42));
      });

      test('should parse JSON arrays', () {
        const jsonArray = '[{"id": 1}, {"id": 2}]';
        final result = InputValidator.safeJsonParse(jsonArray);
        expect(result, isA<List<dynamic>>());
        expect(result.length, equals(2));
      });
    });

    group('isValidUrl', () {
      test('should return false for null or empty URLs', () {
        expect(InputValidator.isValidUrl(null), isFalse);
        expect(InputValidator.isValidUrl(''), isFalse);
      });

      test('should return true for valid HTTP URLs', () {
        expect(InputValidator.isValidUrl('http://example.com'), isTrue);
        expect(InputValidator.isValidUrl('https://example.com'), isTrue);
        expect(InputValidator.isValidUrl('https://api.spotify.com/v1/tracks'), isTrue);
      });

      test('should return false for non-HTTP protocols', () {
        expect(InputValidator.isValidUrl('ftp://example.com'), isFalse);
        expect(InputValidator.isValidUrl('javascript:alert("xss")'), isFalse);
        expect(InputValidator.isValidUrl('file:///etc/passwd'), isFalse);
      });

      test('should return false for malformed URLs', () {
        expect(InputValidator.isValidUrl('not-a-url'), isFalse);
        expect(InputValidator.isValidUrl('http://'), isFalse);
      });
    });

    group('sanitizeFilePath', () {
      test('should return null for empty paths', () {
        expect(InputValidator.sanitizeFilePath('', ['json']), isNull);
        expect(InputValidator.sanitizeFilePath(null, ['json']), isNull);
      });

      test('should remove path traversal attempts', () {
        const maliciousPath = '../../../etc/passwd.json';
        final result = InputValidator.sanitizeFilePath(maliciousPath, ['json']);
        expect(result, equals('etc/passwd.json'));
      });

      test('should check file extensions', () {
        expect(InputValidator.sanitizeFilePath('file.json', ['json']), equals('file.json'));
        expect(InputValidator.sanitizeFilePath('file.txt', ['json']), isNull);
        expect(InputValidator.sanitizeFilePath('file.JSON', ['json']), equals('file.JSON'));
      });
    });

    group('isValidNumericRange', () {
      test('should return false for null values', () {
        expect(InputValidator.isValidNumericRange(null, 0, 100), isFalse);
      });

      test('should validate ranges correctly', () {
        expect(InputValidator.isValidNumericRange(50, 0, 100), isTrue);
        expect(InputValidator.isValidNumericRange(0, 0, 100), isTrue);
        expect(InputValidator.isValidNumericRange(100, 0, 100), isTrue);
        expect(InputValidator.isValidNumericRange(-1, 0, 100), isFalse);
        expect(InputValidator.isValidNumericRange(101, 0, 100), isFalse);
      });

      test('should handle decimal values', () {
        expect(InputValidator.isValidNumericRange(50.5, 0, 100), isTrue);
        expect(InputValidator.isValidNumericRange(50.5, 51, 100), isFalse);
      });
    });

    group('sanitizeForDisplay', () {
      test('should return empty string for null input', () {
        expect(InputValidator.sanitizeForDisplay(null), equals(''));
      });

      test('should remove control characters', () {
        const input = 'Hello\x00\x08\x0B\x0C\x0E\x1F\x7FWorld';
        expect(InputValidator.sanitizeForDisplay(input), equals('HelloWorld'));
      });

      test('should preserve normal text', () {
        const input = 'Hello, World! 123 @#\$%';
        expect(InputValidator.sanitizeForDisplay(input), equals(input));
      });
    });
  });
}
