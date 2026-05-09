import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_core/src/domain/entities/lead_entity.dart';

void main() {
  group('LeadEntity', () {
    group('Constructor', () {
      test('should create LeadEntity with required fields', () {
        // Arrange & Act
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.active,
          createdAt: DateTime(2025, 1, 1),
        );

        // Assert
        expect(lead.id, 1);
        expect(lead.firstName, 'Jane');
        expect(lead.lastName, 'Customer');
        expect(lead.status, LeadStatus.active);
        expect(lead.createdAt, DateTime(2025, 1, 1));
      });

      test('should create LeadEntity with all fields', () {
        // Arrange & Act
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          salutation: 'Ms.',
          status: LeadStatus.active,
          createdAt: DateTime(2025, 1, 1),
          phoneNumbers: ['1234567890', '0987654321'],
          emails: ['jane@example.com'],
          locality: 'Downtown',
          address: '123 Main St',
        );

        // Assert
        expect(lead.phoneNumbers, ['1234567890', '0987654321']);
        expect(lead.emails, ['jane@example.com']);
        expect(lead.locality, 'Downtown');
        expect(lead.address, '123 Main St');
      });
    });

    group('fullName', () {
      test('should combine salutation, firstName, and lastName', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          salutation: 'Ms.',
          status: LeadStatus.active,
          createdAt: DateTime.now(),
        );

        // Act
        final fullName = lead.fullName;

        // Assert
        expect(fullName, 'Ms. Jane Customer');
      });

      test('should handle missing salutation', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.active,
          createdAt: DateTime.now(),
        );

        // Act
        final fullName = lead.fullName;

        // Assert
        expect(fullName, 'Jane Customer');
      });
    });

    group('isActive', () {
      test('should return true when status is active', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.active,
          createdAt: DateTime.now(),
        );

        // Act & Assert
        expect(lead.isActive, true);
      });

      test('should return false when status is booked', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.booked,
          createdAt: DateTime.now(),
        );

        // Act & Assert
        expect(lead.isActive, false);
      });

      test('should return false when status is delivered', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.delivered,
          createdAt: DateTime.now(),
        );

        // Act & Assert
        expect(lead.isActive, false);
      });

      test('should return false when status is lost', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.lost,
          createdAt: DateTime.now(),
        );

        // Act & Assert
        expect(lead.isActive, false);
      });

      test('should return false when status is inactive', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.inactive,
          createdAt: DateTime.now(),
        );

        // Act & Assert
        expect(lead.isActive, false);
      });
    });

    group('primaryPhone', () {
      test('should return first phone number when available', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.active,
          createdAt: DateTime.now(),
          phoneNumbers: ['1234567890', '0987654321'],
        );

        // Act
        final primaryPhone = lead.primaryPhone;

        // Assert
        expect(primaryPhone, '1234567890');
      });

      test('should return null when no phone numbers', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.active,
          createdAt: DateTime.now(),
        );

        // Act
        final primaryPhone = lead.primaryPhone;

        // Assert
        expect(primaryPhone, isNull);
      });

      test('should return null when phone numbers list is empty', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.active,
          createdAt: DateTime.now(),
          phoneNumbers: [],
        );

        // Act
        final primaryPhone = lead.primaryPhone;

        // Assert
        expect(primaryPhone, isNull);
      });
    });

    group('primaryEmail', () {
      test('should return first email when available', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.active,
          createdAt: DateTime.now(),
          emails: ['jane@example.com', 'jane.customer@example.com'],
        );

        // Act
        final primaryEmail = lead.primaryEmail;

        // Assert
        expect(primaryEmail, 'jane@example.com');
      });

      test('should return null when no emails', () {
        // Arrange
        final lead = LeadEntity(
          id: 1,
          firstName: 'Jane',
          lastName: 'Customer',
          status: LeadStatus.active,
          createdAt: DateTime.now(),
        );

        // Act
        final primaryEmail = lead.primaryEmail;

        // Assert
        expect(primaryEmail, isNull);
      });
    });
  });

  group('LeadStatus', () {
    group('fromString', () {
      test('should return active for "active" string', () {
        // Act
        final status = LeadStatus.fromString('active');

        // Assert
        expect(status, LeadStatus.active);
      });

      test('should return booked for "booked" string', () {
        // Act
        final status = LeadStatus.fromString('booked');

        // Assert
        expect(status, LeadStatus.booked);
      });

      test('should return delivered for "delivered" string', () {
        // Act
        final status = LeadStatus.fromString('delivered');

        // Assert
        expect(status, LeadStatus.delivered);
      });

      test('should return lost for "lost" string', () {
        // Act
        final status = LeadStatus.fromString('lost');

        // Assert
        expect(status, LeadStatus.lost);
      });

      test('should return inactive for "inactive" string', () {
        // Act
        final status = LeadStatus.fromString('inactive');

        // Assert
        expect(status, LeadStatus.inactive);
      });

      test('should return active for unknown string', () {
        // Act
        final status = LeadStatus.fromString('unknown');

        // Assert
        expect(status, LeadStatus.active);
      });

      test('should return active for null string', () {
        // Act
        final status = LeadStatus.fromString(null);

        // Assert
        expect(status, LeadStatus.active);
      });

      test('should be case insensitive', () {
        // Act
        final status1 = LeadStatus.fromString('ACTIVE');
        final status2 = LeadStatus.fromString('Active');
        final status3 = LeadStatus.fromString('aCTiVe');

        // Assert
        expect(status1, LeadStatus.active);
        expect(status2, LeadStatus.active);
        expect(status3, LeadStatus.active);
      });
    });
  });
}
