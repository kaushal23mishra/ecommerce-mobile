import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_core/src/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    group('Constructor', () {
      test('should create UserEntity with required fields', () {
        // Arrange & Act
        const user = UserEntity(id: 1, firstName: 'John', lastName: 'Doe');

        // Assert
        expect(user.id, 1);
        expect(user.firstName, 'John');
        expect(user.lastName, 'Doe');
      });

      test('should create UserEntity with all fields', () {
        // Arrange & Act
        const user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          salutation: 'Mr.',
          phone: '1234567890',
          employeeId: 'EMP001',
          gender: 'Male',
          dob: '1990-01-01',
          status: 'active',
          organizationId: 100,
          organizationName: 'Test Org',
          organizationDomain: 'test.com',
          logo: 'logo.png',
          isOwner: true,
          hideMobile: false,
          hideAddress: false,
          lpaApprover: true,
        );

        // Assert
        expect(user.id, 1);
        expect(user.firstName, 'John');
        expect(user.lastName, 'Doe');
        expect(user.salutation, 'Mr.');
        expect(user.phone, '1234567890');
        expect(user.employeeId, 'EMP001');
        expect(user.gender, 'Male');
        expect(user.dob, '1990-01-01');
        expect(user.status, 'active');
        expect(user.organizationId, 100);
        expect(user.organizationName, 'Test Org');
        expect(user.isOwner, true);
        expect(user.hideMobile, false);
      });

      test('should handle null optional fields', () {
        // Arrange & Act
        const user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          salutation: null,
          phone: null,
          employeeId: null,
          gender: null,
          status: null,
        );

        // Assert
        expect(user.salutation, isNull);
        expect(user.phone, isNull);
        expect(user.employeeId, isNull);
        expect(user.gender, isNull);
        expect(user.status, isNull);
      });
    });

    group('fullName', () {
      test('should combine salutation, firstName, and lastName', () {
        // Arrange
        const user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          salutation: 'Mr.',
        );

        // Act
        final fullName = user.fullName;

        // Assert
        expect(fullName, 'Mr. John Doe');
      });

      test('should handle missing salutation', () {
        // Arrange
        const user = UserEntity(id: 1, firstName: 'John', lastName: 'Doe');

        // Act
        final fullName = user.fullName;

        // Assert
        expect(fullName, 'John Doe');
      });

      test('should trim extra spaces', () {
        // Arrange
        const user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          salutation: null,
        );

        // Act
        final fullName = user.fullName;

        // Assert
        expect(fullName, 'John Doe');
        expect(fullName.startsWith(' '), false);
        expect(fullName.endsWith(' '), false);
      });
    });

    group('isActive', () {
      test('should return true when status is "active"', () {
        // Arrange
        const user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          status: 'active',
        );

        // Act & Assert
        expect(user.isActive, true);
      });

      test('should return true when status is "ACTIVE" (case insensitive)', () {
        // Arrange
        const user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          status: 'ACTIVE',
        );

        // Act & Assert
        expect(user.isActive, true);
      });

      test('should return false when status is "inactive"', () {
        // Arrange
        const user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          status: 'inactive',
        );

        // Act & Assert
        expect(user.isActive, false);
      });

      test('should return false when status is null', () {
        // Arrange
        const user = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          status: null,
        );

        // Act & Assert
        expect(user.isActive, false);
      });
    });

    group('displayName', () {
      test('should return firstName when it exists', () {
        // Arrange
        const user = UserEntity(id: 1, firstName: 'John', lastName: 'Doe');

        // Act
        final displayName = user.displayName;

        // Assert - displayName getter returns firstName when not empty
        expect(displayName, 'John');
      });

      test('should return firstName when lastName is empty', () {
        // Arrange
        const user = UserEntity(id: 1, firstName: 'John', lastName: '');

        // Act
        final displayName = user.displayName;

        // Assert
        expect(displayName, 'John');
      });

      test('should return fullName when firstName is empty', () {
        // Arrange
        const user = UserEntity(id: 1, firstName: '', lastName: 'Doe');

        // Act
        final displayName = user.displayName;

        // Assert
        expect(displayName, 'Doe');
      });
    });

    group('Equality', () {
      test('should be equal when all fields match', () {
        // Arrange
        const user1 = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          phone: '1234567890',
        );

        const user2 = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          phone: '1234567890',
        );

        // Act & Assert
        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('should not be equal when IDs differ', () {
        // Arrange
        const user1 = UserEntity(id: 1, firstName: 'John', lastName: 'Doe');

        const user2 = UserEntity(id: 2, firstName: 'John', lastName: 'Doe');

        // Act & Assert
        expect(user1, isNot(equals(user2)));
      });
    });

    group('copyWith', () {
      test('should create new instance with updated fields', () {
        // Arrange
        const original = UserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          phone: '1234567890',
        );

        // Act
        final updated = original.copyWith(
          firstName: 'Jane',
          phone: '0987654321',
        );

        // Assert
        expect(updated.id, 1); // Unchanged
        expect(updated.firstName, 'Jane'); // Changed
        expect(updated.lastName, 'Doe'); // Unchanged
        expect(updated.phone, '0987654321'); // Changed
      });

      test('should not mutate original instance', () {
        // Arrange
        const original = UserEntity(id: 1, firstName: 'John', lastName: 'Doe');

        // Act
        original.copyWith(firstName: 'Jane');

        // Assert
        expect(original.firstName, 'John'); // Unchanged
      });
    });
  });
}
