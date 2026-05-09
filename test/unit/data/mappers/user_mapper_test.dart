import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/data/mappers/user_mapper.dart';
import 'package:salesdocket_core/src/domain/entities/user_entity.dart';

void main() {
  group('UserMapper', () {
    group('toEntity', () {
      test('should convert User to UserEntity with all fields', () {
        // Arrange
        final user = User(
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
          isOwner: 1,
          hideMobile: 0,
          hideAddress: 0,
          lpaApprover: 1,
        );

        // Act
        final entity = user.toEntity();

        // Assert
        expect(entity, isA<UserEntity>());
        expect(entity.id, user.id);
        expect(entity.firstName, user.firstName);
        expect(entity.lastName, user.lastName);
        expect(entity.salutation, user.salutation);
        expect(entity.phone, user.phone);
        expect(entity.employeeId, user.employeeId);
        expect(entity.gender, user.gender);
        expect(entity.status, user.status);
      });

      test('should handle null optional fields', () {
        // Arrange
        final user = User(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          salutation: null,
          phone: null,
          employeeId: null,
          gender: null,
          status: null,
          hideMobile: null,
          hideAddress: null,
        );

        // Act
        final entity = user.toEntity();

        // Assert
        expect(entity.id, 1);
        expect(entity.firstName, 'John');
        expect(entity.lastName, 'Doe');
        expect(entity.salutation, isNull);
        expect(entity.phone, isNull);
        expect(entity.employeeId, isNull);
        expect(entity.gender, isNull);
        expect(entity.status, isNull);
      });

      test('should map different user statuses correctly', () {
        // Arrange
        final activeUser = User(
          id: 1,
          firstName: 'Active',
          lastName: 'User',
          status: 'active',
        );
        final inactiveUser = User(
          id: 2,
          firstName: 'Inactive',
          lastName: 'User',
          status: 'inactive',
        );
        final pendingUser = User(
          id: 3,
          firstName: 'Pending',
          lastName: 'User',
          status: 'pending',
        );

        // Act & Assert
        expect(activeUser.toEntity().status, 'active');
        expect(inactiveUser.toEntity().status, 'inactive');
        expect(pendingUser.toEntity().status, 'pending');
      });

      test('should preserve special characters in names', () {
        // Arrange
        final user = User(
          id: 1,
          firstName: "O'Connor",
          lastName: 'Müller',
          salutation: 'Dr.',
        );

        // Act
        final entity = user.toEntity();

        // Assert
        expect(entity.firstName, "O'Connor");
        expect(entity.lastName, 'Müller');
      });

      test('should preserve employeeId format', () {
        // Arrange
        final user = User(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          employeeId: 'EMP-2024-001',
        );

        // Act
        final entity = user.toEntity();

        // Assert
        expect(entity.employeeId, 'EMP-2024-001');
      });

      test('should preserve phone number format', () {
        // Arrange
        final user = User(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          phone: '+1-234-567-8900',
        );

        // Act
        final entity = user.toEntity();

        // Assert
        expect(entity.phone, '+1-234-567-8900');
      });

      test('should handle empty strings', () {
        // Arrange
        final user = User(
          id: 1,
          firstName: '',
          lastName: '',
          salutation: '',
          employeeId: '',
          phone: '',
        );

        // Act
        final entity = user.toEntity();

        // Assert
        expect(entity.firstName, '');
        expect(entity.lastName, '');
        expect(entity.salutation, '');
      });

      test('should handle maximum integer ID', () {
        // Arrange
        final user = User(
          id: 2147483647, // Max int32
          firstName: 'John',
          lastName: 'Doe',
        );

        // Act
        final entity = user.toEntity();

        // Assert
        expect(entity.id, 2147483647);
      });
    });

    group('Multiple conversions', () {
      test('should produce consistent results for same input', () {
        // Arrange
        final user = User(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          employeeId: 'EMP001',
        );

        // Act
        final entity1 = user.toEntity();
        final entity2 = user.toEntity();

        // Assert
        expect(entity1, equals(entity2));
      });

      test('should handle batch conversion', () {
        // Arrange
        final users = List.generate(
          100,
          (i) => User(id: i, firstName: 'User$i', lastName: 'Test'),
        );

        // Act
        final entities = users.map((u) => u.toEntity()).toList();

        // Assert
        expect(entities.length, 100);
        expect(entities[0].id, 0);
        expect(entities[99].id, 99);
        expect(entities[50].firstName, 'User50');
      });
    });
  });
}
