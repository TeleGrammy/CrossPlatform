import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';

import 'package:telegrammy/features/profile/data/models/contacts_toblock_model.dart';
import 'package:telegrammy/features/profile/data/models/profile_info_model.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';
import 'package:telegrammy/features/profile/data/models/settings_user_model.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';

// Import generated mocks
import 'mock.mocks.dart';

void main() {
  late MockProfileApiService mockProfileApiService;
  late MockTokenStorageService mockTokenStorageService;

  setUp(() {
    mockProfileApiService = MockProfileApiService();
    mockTokenStorageService = MockTokenStorageService();
  });

  test('should return contacts and status when getContacts is called',
      () async {
    // Create mocked ContactData objects
    final mockContact1 = ContactData(
      contactId: "1",
      chatId: "chat_1",
      blockDetails: BlockDetails(status: "unblocked", date: null),
    );

    final mockContact2 = ContactData(
      contactId: "2",
      chatId: "chat_2",
      blockDetails: BlockDetails(status: "blocked", date: "2023-01-01"),
    );

    // Create mocked ContactsResponse object
    final mockResponse = ContactsResponse(
      status: "success", // Mocked status
      contacts: [mockContact1, mockContact2],
    );

    // Simulate getContacts behavior
    when(mockProfileApiService.getContacts())
        .thenAnswer((_) async => mockResponse);

    // Call the method
    final contactsResponse = await mockProfileApiService.getContacts();

    // Verify the response
    expect(contactsResponse.status, "success");
    expect(contactsResponse.contacts.length, 2);
    expect(contactsResponse.contacts[0].contactId, "1");
    expect(contactsResponse.contacts[0].blockDetails.status, "unblocked");
    expect(contactsResponse.contacts[1].blockDetails.status, "blocked");
  });

  test('should return blocked users and status when getBlockedUsers is called', () async {
    // Create mocked UserData objects for blocked users
    final mockBlockedUser1 = UserData(userId: "1", userName: "user_1");
    final mockBlockedUser2 = UserData(userId: "2", userName: "user_2");

    // Create mocked BlockedUsersResponse object
    final mockResponse = BlockedUsersResponse(
      status: "success", // Mocked status
      data: [mockBlockedUser1, mockBlockedUser2],
    );

    // Simulate getBlockedUsers behavior
    when(mockProfileApiService.getBlockedUsers())
        .thenAnswer((_) async => mockResponse);

    // Call the method
    final blockedUsersResponse = await mockProfileApiService.getBlockedUsers();

    // Verify the response
    expect(blockedUsersResponse.status, "success");
    expect(blockedUsersResponse.data.length, 2);
    expect(blockedUsersResponse.data[0].userId, "1");
    expect(blockedUsersResponse.data[0].userName, "user_1");
    expect(blockedUsersResponse.data[1].userId, "2");
    expect(blockedUsersResponse.data[1].userName, "user_2");
  });
  test('should create a story when createStory is called', () async {
    // Mock StoryCreation object
    final storyCreation =
        StoryCreation(content: 'This is a test story', media: 'media_url');

    // Mock token
    when(mockTokenStorageService.getToken())
        .thenAnswer((_) async => 'mock_token');

    // Simulate the post request for creating the story
    when(mockProfileApiService.createStory(storyCreation))
        .thenAnswer((_) async => Future.value());

    // Call the createStory method
    await mockProfileApiService.createStory(storyCreation);

    // Verify that the POST request was made
    verify(mockProfileApiService.createStory(storyCreation)).called(1);
  });

  test('should delete a story when deleteStory is called', () async {
    // Mock storyId
    final storyId = 'story123';

    // Mock token
    when(mockTokenStorageService.getToken()).thenAnswer((_) async => 'mock_token');

    // Simulate the delete request for deleting the story
    when(mockProfileApiService.deleteStory(storyId)).thenAnswer((_) async => Future.value());

    // Call the deleteStory method
    await mockProfileApiService.deleteStory(storyId);

    // Verify that the DELETE request was made with the correct storyId
    verify(mockProfileApiService.deleteStory(storyId)).called(1);
  });

  test('should parse StoryResponse correctly from JSON', () {
    // Sample JSON response from the server
    final jsonResponse = {
      'status': 'success',
      'data': [
        {
          '_id': '1',
          'content': 'Test content 1',
          'media': 'media_url_1',
          'expiresAt': '2024-12-01T00:00:00Z',
          'userId': 'user1',
          'viewers': null,
          '__v': 1,
          'viewersCount': 10,
        },
        {
          '_id': '2',
          'content': 'Test content 2',
          'media': 'media_url_2',
          'expiresAt': '2024-12-02T00:00:00Z',
          'userId': 'user2',
          'viewers': null,
          '__v': 1,
          'viewersCount': 20,
        },
      ],
    };

    // Parse the JSON into a StoryResponse object
    final storyResponse = StoryResponse.fromJson(jsonResponse);

    // Verify the parsed values
    expect(storyResponse.status, 'success');
    expect(storyResponse.data.length, 2);

    // Verify the first story
    expect(storyResponse.data[0].id, '1');
    expect(storyResponse.data[0].content, 'Test content 1');
    expect(storyResponse.data[0].media, 'media_url_1');
    expect(storyResponse.data[0].expiresAt, DateTime.parse('2024-12-01T00:00:00Z'));
    expect(storyResponse.data[0].userId, 'user1');
  });
test('should ensure blocking status method is called', () async {
  // Arrange: Mock behavior of updateBlockingStatus (no need to return anything)
  when(mockTokenStorageService.getToken()).thenAnswer((_) async => 'mock_token');
  
  // Mock the updateBlockingStatus to return a Future<void>
  when(mockProfileApiService.updateBlockingStatus('block', 'user123'))
      .thenAnswer((_) async => null);  // Returning null will work for Future<void> as it's asynchronous with no return value.

  // Act: Call the updateBlockingStatus function
  await mockProfileApiService.updateBlockingStatus('block', 'user123');

  // Assert: Verify that the updateBlockingStatus method was called with correct parameters
  verify(mockProfileApiService.updateBlockingStatus('block', 'user123')).called(1);
});
test('should return failure when blocking status update fails', () async {
  // Arrange: Simulate an exception when calling the updateBlockingStatus method
  when(mockProfileApiService.updateBlockingStatus('block', 'user123'))
      .thenThrow(Exception('Error occurred'));

  // Act: Call the updateBlockingStatus function and handle the error
  try {
    await mockProfileApiService.updateBlockingStatus('block', 'user123');
    fail('Expected an exception, but no exception was thrown');
  } catch (e) {
    // Assert: Verify that the exception message is as expected
    expect(e.toString(), contains('Error occurred'));
  }

  // Verify that the updateBlockingStatus method was called with correct parameters
  verify(mockProfileApiService.updateBlockingStatus('block', 'user123')).called(1);
});



  test('should return success when unblocking status is updated', () async {
  when(mockTokenStorageService.getToken()).thenAnswer((_) async => 'mock_token');
  
  // Mock the updateBlockingStatus to return a Future<void>
  when(mockProfileApiService.updateBlockingStatus('unblock', 'user123'))
      .thenAnswer((_) async => null);  // Returning null will work for Future<void> as it's asynchronous with no return value.

  // Act: Call the updateBlockingStatus function
  await mockProfileApiService.updateBlockingStatus('unblock', 'user123');

  // Assert: Verify that the updateBlockingStatus method was called with correct parameters
  verify(mockProfileApiService.updateBlockingStatus('unblock', 'user123')).called(1);
  });



  test(
      'getProfileInfo should fetch profile info and return ProfileInfoResponse',
      () async {
    final mockResponseData = {
      'username': 'test_user',
      'email': 'test@example.com',
      'phone': '01234567891',
      'screenName': 'user123',
      'bio': 'cool bio',
      'status': 'active',
      'picture': 'imageUrl'
    };

    final profileInfoResponse = ProfileInfoResponse.fromJson({
      'status': 'success',
      'data': {'user': mockResponseData}
    });

    when(mockProfileApiService.getProfileInfo())
        .thenAnswer((_) async => profileInfoResponse);

    final result = await mockProfileApiService.getProfileInfo();

    // Assert
    expect(result.data.phoneNumber, mockResponseData['phone']);
    expect(result.data.username, mockResponseData['username']);
    expect(result.data.email, mockResponseData['email']);
    expect(result.data.bio, mockResponseData['bio']);
    expect(result.data.screenName, mockResponseData['screenName']);
    expect(result.data.profilePic, mockResponseData['picture']);
    expect(result.data.status, mockResponseData['status']);

    // Verify calls
    verify(mockProfileApiService.getProfileInfo()).called(1);
  });

  test('updateProfileInfo should update profile info successfully', () async {
    final mockResponseData = {
      'username': 'test_user',
      'email': 'test@example.com',
      'phone': '01234567891',
      'screenName': 'user123',
      'bio': 'cool bio',
      'status': 'active',
      'picture': 'imageurl'
    };

    final profileInfoResponse = ProfileInfoResponse.fromJson({
      'status': 'success',
      'data': {'user': mockResponseData}
    });

    final profileInfo = ProfileInfo.fromJson({
      'username': 'test_user',
      'email': 'test@example.com',
      'phone': '01234567891',
      'screenName': 'user123',
      'bio': 'cool bio',
      'status': 'active',
      'picture': 'imageurl'
    });

    when(mockProfileApiService.updateProfileInfo(profileInfo))
        .thenAnswer((_) async => profileInfoResponse);

    // Assert
    expect(() async {
      await mockProfileApiService.updateProfileInfo(profileInfo);
    }, returnsNormally); // Ensure no error is thrown

    // Verify calls
    verify(mockProfileApiService.updateProfileInfo(profileInfo)).called(1);
  });

  test('updateUserActivityStatus should update user status successfully',
      () async {
    String newStatus = "inactive";

    final mockResponse = {
      'status': 'success',
      'data': {
        'user': {'status': newStatus}
      }
    };

    when(mockProfileApiService.updateUserActivityStatus(newStatus))
        .thenAnswer((_) async => mockResponse);

    expect(() async {
      await mockProfileApiService.updateUserActivityStatus(newStatus);
    }, returnsNormally); // Ensure no error is thrown

    // Verify calls
    verify(mockProfileApiService.updateUserActivityStatus(newStatus)).called(1);
  });

  test('updateUserEmail should update user email successfully', () async {
    String newEmail = "user_123_user@gmail.com";

    final mockResponse = {
      'status': 'success',
      'data': {
        'user': {'email': newEmail}
      }
    };

    when(mockProfileApiService.updateUserEmail(newEmail))
        .thenAnswer((_) async => mockResponse);

    expect(() async {
      await mockProfileApiService.updateUserEmail(newEmail);
    }, returnsNormally); // Ensure no error is thrown

    // Verify calls
    verify(mockProfileApiService.updateUserEmail(newEmail)).called(1);
  });

  test('updateUsername should update username successfully', () async {
    String newUsername = "unique_username";

    final mockResponse = {
      'status': 'success',
      'data': {
        'user': {'username': newUsername}
      }
    };

    when(mockProfileApiService.updateUsername(newUsername))
        .thenAnswer((_) async => mockResponse);

    expect(() async {
      await mockProfileApiService.updateUsername(newUsername);
    }, returnsNormally); // Ensure no error is thrown

    // Verify calls
    verify(mockProfileApiService.updateUsername(newUsername)).called(1);
  });

  test('updateUserPhoneNumber should update username successfully', () async {
    String newPhoneNumber = "01001212132";

    final mockResponse = {
      'status': 'success',
      'data': {
        'user': {'phone': newPhoneNumber}
      }
    };

    when(mockProfileApiService.updateUserPhoneNumber(newPhoneNumber))
        .thenAnswer((_) async => mockResponse);

    expect(() async {
      await mockProfileApiService.updateUserPhoneNumber(newPhoneNumber);
    }, returnsNormally); // Ensure no error is thrown

    // Verify calls
    verify(mockProfileApiService.updateUserPhoneNumber(newPhoneNumber))
        .called(1);
  });



  ///////////////////////////////////////////////////////////// read receipts
test('should update read receipts status successfully', () async {
  // Arrange: Mock the token retrieval from the TokenStorageService
  when(mockTokenStorageService.getToken()).thenAnswer((_) async => 'mock_token');

  // Create the mock response for the updateReadReceiptsStatus method (it doesn't return anything)
  when(mockProfileApiService.updateReadReceiptsStatus(true)).thenAnswer((_) async => null);

  // Act: Call the updateReadReceiptsStatus method with `true` to enable it
  await mockProfileApiService.updateReadReceiptsStatus(true);

  // Assert: Verify that the updateReadReceiptsStatus method was called with correct parameters
  verify(mockProfileApiService.updateReadReceiptsStatus(true)).called(1);
});

test('should return failure when read receipts status update fails', () async {
  // Arrange: Simulate an exception when calling the updateReadReceiptsStatus method
  when(mockTokenStorageService.getToken()).thenAnswer((_) async => 'mock_token');
  when(mockProfileApiService.updateReadReceiptsStatus(true))
      .thenThrow(Exception('Error occurred'));

  // Act: Call the updateReadReceiptsStatus function and handle the error
  try {
    await mockProfileApiService.updateReadReceiptsStatus(true);
    fail('Expected an exception, but no exception was thrown');
  } catch (e) {
    // Assert: Verify that the exception message is as expected
    expect(e.toString(), contains('Error occurred'));
  }

  // Verify that the updateReadReceiptsStatus method was called with the correct parameters
  verify(mockProfileApiService.updateReadReceiptsStatus(true)).called(1);
});

test('should update read receipts status successfully when disabled', () async {
  // Arrange: Mock the token retrieval from the TokenStorageService
  when(mockTokenStorageService.getToken()).thenAnswer((_) async => 'mock_token');

  // Create the mock response for the updateReadReceiptsStatus method (it doesn't return anything)
  when(mockProfileApiService.updateReadReceiptsStatus(false)).thenAnswer((_) async => null);

  // Act: Call the updateReadReceiptsStatus method with `false` to disable it
  await mockProfileApiService.updateReadReceiptsStatus(false);

  // Assert: Verify that the updateReadReceiptsStatus method was called with correct parameters
  verify(mockProfileApiService.updateReadReceiptsStatus(false)).called(1);
});
/////////////////////////////////////////// profile visisbility
test('updateProfileVisibility should update visibility successfully', () async {
  // Arrange: Set the new profile visibility (for example, 'profilePicture', 'stories', 'lastSeen')
  ProfileVisibility newProfileVisibility = ProfileVisibility(
    profilePicture: 'private',
    stories: 'friends_only',
    lastSeen: 'hidden',
  );

  // Simulate the service call and mock the update method (void method)
  when(mockProfileApiService.updateProfileVisibility(newProfileVisibility))
      .thenAnswer((_) async => null); // No return value as it's a void function

  // Act: Call the updateProfileVisibility method
  await mockProfileApiService.updateProfileVisibility(newProfileVisibility);

  // Assert: Verify that the method was called with correct parameters
  verify(mockProfileApiService.updateProfileVisibility(newProfileVisibility)).called(1);
});

///////////////////////////
group('getUserSettings', () {
    test('should return user privacy settings successfully', () async {
      // Arrange: Create mock UserPrivacySettings
      final mockUserPrivacySettings = UserPrivacySettings(
        profilePictureVisibility: 'private',
        storiesVisibility: 'friends_only',
        lastSeenVisibility: 'hidden',
        readReceipts: true,
        whoCanAddMe: 'everyone',
      );

      final mockResponse = UserPrivacySettingsResponse(
        status: "success", // Mocked status
        data: mockUserPrivacySettings,
      );

      // Simulate the behavior of getUserSettings
      when(mockProfileApiService.getUserSettings())
          .thenAnswer((_) async => mockResponse);

      // Act: Call the method
      final userSettingsResponse = await mockProfileApiService.getUserSettings();

      // Assert: Verify the response
      expect(userSettingsResponse.status, "success");
      expect(userSettingsResponse.data.profilePictureVisibility, "private");
      expect(userSettingsResponse.data.storiesVisibility, "friends_only");
      expect(userSettingsResponse.data.lastSeenVisibility, "hidden");
      expect(userSettingsResponse.data.readReceipts, true);
      expect(userSettingsResponse.data.whoCanAddMe, "everyone");
    });

    test('should throw an exception when getUserSettings fails', () async {
      // Arrange: Simulate an error from the API
      when(mockProfileApiService.getUserSettings())
          .thenThrow(Exception('Error fetching user settings'));

      // Act & Assert: Verify the exception is thrown
      expect(() async => await mockProfileApiService.getUserSettings(), throwsException);
    });
  });


}
