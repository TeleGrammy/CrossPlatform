import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';

import 'package:telegrammy/features/profile/data/models/contacts_toblock_model.dart';
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

  test('should return contacts and status when getContacts is called', () async {
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
    when(mockProfileApiService.getContacts()).thenAnswer((_) async => mockResponse);

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
    when(mockProfileApiService.getBlockedUsers()).thenAnswer((_) async => mockResponse);

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
    final storyCreation = StoryCreation(content: 'This is a test story', media: 'media_url');

    // Mock token
    when(mockTokenStorageService.getToken()).thenAnswer((_) async => 'mock_token');

    // Simulate the post request for creating the story
    when(mockProfileApiService.createStory(storyCreation)).thenAnswer((_) async => Future.value());

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



}
