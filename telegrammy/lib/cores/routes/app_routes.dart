import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/helpers/routes_helper.dart';
import 'package:telegrammy/features/Home/presentation/views/home_view.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/registered_users_model.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/views/registered_user_view.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/views/registered_users_view.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:telegrammy/features/auth/presentation/views/login_view.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/auth/presentation/view_models/signup_cubit/signup_cubit.dart';
import 'package:telegrammy/features/auth/presentation/views/account_verification_view/account_verification_view.dart';
import 'package:telegrammy/features/auth/presentation/views/resetpassword_view/reset_password.dart';
import 'package:telegrammy/features/auth/presentation/views/resetpassword_view/verify_otp.dart';
import 'package:telegrammy/features/auth/presentation/views/signup_view/signup_view.dart';
import 'package:telegrammy/features/channels/presentation/view_models/channel_cubit/channel_cubit.dart';
import 'package:telegrammy/features/channels/presentation/views/create_channel_view/create_channel_view.dart';
import 'package:telegrammy/features/groups/presentation/view_models/group_cubit.dart';
import 'package:telegrammy/features/groups/presentation/views/add_admin_view.dart';
import 'package:telegrammy/features/groups/presentation/views/add_members_view.dart';
import 'package:telegrammy/features/groups/presentation/views/create_group_view.dart';
import 'package:telegrammy/features/groups/presentation/views/edit_group_settings.dart';
import 'package:telegrammy/features/groups/presentation/views/group_members_view.dart';
import 'package:telegrammy/features/groups/presentation/views/group_settings.dart';
import 'package:telegrammy/features/groups/presentation/views/remove_members_view.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/presentation/view_models/messages_cubit/messages_cubit.dart';
import 'package:telegrammy/features/messages/presentation/view_models/contacts_cubit/contacts_cubit.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/presentation/views/add_contact.dart';
import 'package:telegrammy/features/messages/presentation/views/chat_wrapper.dart';
import 'package:telegrammy/features/messages/presentation/views/chats_view.dart';
import 'package:telegrammy/features/messages/presentation/views/forward_to_page.dart';
import 'package:telegrammy/features/messages/presentation/views/in_coming_call.dart';
import 'package:telegrammy/features/messages/presentation/views/on_going_call.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';
import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/views/blocked_users_view.dart';
import 'package:telegrammy/features/profile/presentation/views/contacts_to_block.dart';
import 'package:telegrammy/features/profile/presentation/views/creating_user_story_view.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import 'package:telegrammy/features/profile/presentation/views/other_users_story_view.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_privacy_view.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_settings/change_email.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_settings/change_phone_number.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_settings/change_username.dart';
import 'package:telegrammy/features/profile/presentation/views/stories_view.dart';
import 'package:telegrammy/features/profile/presentation/views/privacy_allowable.dart';
import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_cubit.dart';
import 'package:telegrammy/features/profile/presentation/views/user_story_view.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_settings/profile_info_view.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_settings/edit_profile_info_view.dart';

class AppRoutes {
  static GoRouter goRouter = GoRouter(
    redirect: (context, state) {
      // RoutesHelper helper = RoutesHelper();
      // final bool isLoggedin = await helper.isLoggedIn();
      // final bool issignedUp = await helper.isSignedUp();

      // // If the user has logged in and tries to access sign-up or login, send them to the home page
      // if (isLoggedin && state.uri.toString() == '/') {
      //   return '/contacts'; //redirect to the app main screen
      // }

      // // If the user has signedup but not verified send them to the verification page
      // if (!isLoggedin && issignedUp) {
      //   return '/email-verification';
      // }

      // // If the user is not authenticated and tries to access home, send them to the login/signup page
      // if (!isLoggedin) {
      //   return '/'; // Redirect to sign-up or login
      // }

      // // Return null to indicate no redirection needed
      // return null;
    },
    routes: [
      GoRoute(
        name: RouteNames.signUp,
        path: '/signup',
        builder: (context, state) => BlocProvider(
          create: (context) => SignUpCubit(),
          child: const SignUpView(),
        ),
      ),
      //       GoRoute(
      //   name: RouteNames.adminDashboardPage,
      //   path: '/',
      //   builder: (context, state) => BlocProvider(
      //     create: (context) => ReadReceiptCubit(),
      //     child:  RegisteredUsersView(),
      //   ),
      // ),
      GoRoute(
        name: RouteNames.singleRegeisterUserPage,
        path: '/singleRegeisterUserPage',
        builder: (context, state) {
          // Retrieve the user from the 'extra' parameter
          final RegisteredUsersData user = state.extra as RegisteredUsersData;

          return UserDetailView(user: user); // Pass the user to the view
        },
      ),
      // GoRoute(
      //   name: RouteNames.chats,
      //   path: '/chats',
      //   builder: (context, state) => BlocProvider(
      //     create: (context) => ContactsCubit(),
      //     child: ChatsScreen(),
      //   ),
      // ),
      GoRoute(
        name: RouteNames.chats,
        path: '/chats',
        builder: (context, state) {
          final List<dynamic>? extras =
              state.extra as List<dynamic>?; // Safely cast extra
          final Message? forwardedMessage =
              (extras != null && extras.isNotEmpty)
                  ? extras[0] as Message
                  : null;

          return BlocProvider(
            create: (context) => ContactsCubit(),
            child: ChatsScreen(forwardMessage: forwardedMessage),
          );
        },
      ),
      GoRoute(
        name: RouteNames.chatWrapper,
        path: '/chatWrapper',
        builder: (context, state) {
          final List<dynamic> extras = state.extra as List<dynamic>;
          // String name = extras[0];
          // String id = extras[1];
          // String photo = extras[2];
          // bool isChannel = extras[4];
          Chat chat = extras[0];
          String lastSeen = extras[1];
          Message? forwardMessage;
          if (extras.length == 3) forwardMessage = extras[5];

          return BlocProvider(
            create: (context) => MessagesCubit(),
            child: ChatWrapper(
              chat: chat,
              lastSeen: lastSeen,
              forwardedMessage: forwardMessage,
            ),
          );
        },
      ),
      GoRoute(
        name: RouteNames.emailVerification,
        path: '/email-verification',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => SignUpCubit(),
            child: AccountVerificationView(),
          );
        },
      ),
      GoRoute(
        name: RouteNames.login,
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(),
          child: LoginView(),
        ),
      ),
      GoRoute(
        name: RouteNames.resetPassword,
        path: '/reset-password',
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(),
          child: ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        name: RouteNames.sentResetPasswordSuccessfully,
        path: '/sentResetPasswordSuccessfully',
        builder: (context, state) => CheckEmailScreen(),
      ),
      GoRoute(
        name: 'socialAuthLoading',
        path: '/social-auth-loading',
        builder: (context, state) {
          // Extract the accessToken from the query parameters
          // final accessToken = state.uri.queryParameters['accessToken'];
          // print(accessToken);
          return HomeView();
        },
      ),
      GoRoute(
        name: RouteNames.profilePrivacyPage,
        path: '/profile_privacy',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PrivacySettingsCubit(),
            ),
            BlocProvider(
              create: (context) =>
                  BlockedUsersCubit(), // Initialize and load blocked users
            ),
            BlocProvider(
              create: (context) => ReadReceiptCubit(),
            ),
          ],
          child: PrivacyView(),
        ),
      ),
      GoRoute(
        name: RouteNames.blockingView,
        path: '/blocking_view',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  BlockedUsersCubit(), // Initialize and load blocked users
            ),
          ],
          child: BlockingPage(),
        ),
      ),
      GoRoute(
        name: RouteNames.ContactsToBlockFromView,
        path: '/contacts_view',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ContactstoCubit(), // Initialize and load blocked users
            ),
          ],
          child: ContactsPage(),
        ),
      ),
      GoRoute(
        name: RouteNames.privacyAllowablePage,
        path: '/privacy-allowable',
        builder: (context, state) {
          final params = state.extra
              as Map<String, dynamic>?; // Safe extraction of parameters
          final title = params?['title'] as String? ??
              'Default Title'; // Default title if null
          final optionKey = params?['optionKey'] as String? ??
              'defaultOptionKey'; // Default option key if null

          return MultiBlocProvider(
            providers: [
              BlocProvider<PrivacySettingsCubit>(
                create: (context) => PrivacySettingsCubit(),
              ),
              // Add more BlocProviders here if needed
            ],
            child: PrivacyAllowablePage(
              title: title,
              optionKey: optionKey,
            ),
          );
        },
      ),
      GoRoute(
        name: RouteNames.userStoryPage,
        path: '/user-stories-page',
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                StoriesCubit(), // Ensure you provide the appropriate Bloc/Cubit
            child: UserStoryView(), // Your StoriesView widget
          );
        },
      ),
      GoRoute(
        name: RouteNames.otherUserStoryPage,
        path: '/other-user-stories-page',
        builder: (context, state) {
          // Extract data from the state.extra
          final extraData = state.extra as Map<String, dynamic>;
          final userStories = extraData['userStories'] as List<Story>;
          final userName = extraData['userName'] as String;
          final userAvatar = extraData['userAvatar'] as String;

          return BlocProvider(
            create: (context) => OthersStoriesCubit(),
            child: OthersStoryView(
              userStories: userStories,
              userName: userName,
              userAvatar: userAvatar,
            ),
          );
        },
      ),

      GoRoute(
        name: RouteNames.storiesPage,
        path: '/stories-page',
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => StoriesCubit(),
              ),
              BlocProvider(
                create: (context) => OthersStoriesCubit(),
              ),
            ],
            child: StoriesView(),
          );
        },
      ),
      GoRoute(
        name: RouteNames.createStoryPage,
        path: '/create-stories-page',
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                StoriesCubit(), // Ensure you provide the appropriate Bloc/Cubit
            child: CreateStoryPage(), // Your StoriesView widget
          );
        },
      ),
      GoRoute(
        name: RouteNames.profileInfo,
        path: '/profile-info',
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileSettingsCubit(),
          child: ProfileInfoView(),
        ),
      ),
      GoRoute(
        name: RouteNames.editProfileInfo,
        path: '/edit-profile-info',
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileSettingsCubit(),
          child: EditProfileInfoView(),
        ),
      ),
      GoRoute(
        name: RouteNames.changeUsername,
        path: '/change-username',
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileSettingsCubit(),
          child: ChangeUsernameView(),
        ),
      ),
      GoRoute(
        name: RouteNames.changeEmail,
        path: '/change-email',
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileSettingsCubit(),
          child: ChangeEmailView(),
        ),
      ),
      GoRoute(
        name: RouteNames.changePhoneNumber,
        path: '/change-phone-number',
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileSettingsCubit(),
          child: ChangePhoneNumberView(),
        ),
      ),
      GoRoute(
        name: RouteNames.createChannel,
        path: '/create-channel',
        builder: (context, state) => BlocProvider(
          create: (context) => ChannelCubit(),
          child: CreateChannelView(),
        ),
      ),
      GoRoute(
        name: RouteNames.createGroup,
        path: '/create-group',
        builder: (context, state) => BlocProvider(
          create: (context) => GroupCubit(),
          child: CreateGroupView(),
        ),
      ),
      GoRoute(
          name: RouteNames.onGoingCall,
          path: '/onGoingCall',
          builder: (context, state) {
            Map<String, dynamic>? params = state.extra as Map<String, dynamic>?;
            return OutgoingCallScreen(
                name: params!['name'],
                photoUrl: params['photo'],
                chatId: params['id']);
          }),
      GoRoute(
          name: RouteNames.incomingCall,
          path: '/incomingCall',
          builder: (context, state) {
            print(state.extra);
            Map<String, dynamic>? params = state.extra as Map<String, dynamic>?;

            return IncomingCallScreen(
              name: params!['name'],
              photoUrl: params['photo'],
              callId: params['callId'],
              remoteOffer: RTCSessionDescription(
                params['remoteOffer']['sdp'], // SDP string from the JSON
                params['remoteOffer']
                    ['type'], // Type string from the JSON (e.g., "offer")
              ),
            );
          }),
      GoRoute(
        name: RouteNames.groupSettings,
        path: '/group-settings',
        builder: (context, state) {
          final List<dynamic> extras = state.extra as List<dynamic>;
          Chat chat = extras[0];
          String lastSeen = extras[1];
          return BlocProvider(
            create: (context) => GroupCubit(),
            child: GroupSettingsView(
              chat: chat,
              lastSeen: lastSeen,
            ),
          );
        },
      ),
      GoRoute(
          name: RouteNames.editGroupSettings,
          path: '/edit-group-settings',
          builder: (context, state) {
            return BlocProvider(
                create: (context) => GroupCubit(),
                child: EditGroupSettingsView(groupId: state.extra as String));
          }),
      GoRoute(
        name: RouteNames.addGroupMembers,
        path: '/add-group-members',
        builder: (context, state) {
          final List<dynamic> extras = state.extra as List<dynamic>;
          return AddGroupMembersView(
            groupId: extras[0],
            contactsToAddFrom: extras[1],
          );
        },
      ),
      GoRoute(
        name: RouteNames.viewGroupMembers,
        path: '/view-group-members',
        builder: (context, state) {
          final List<dynamic> extras = state.extra as List<dynamic>;
          return GroupMembersView(
            groupId: extras[0],
            members: extras[1],
          );
        },
      ),
      GoRoute(
        name: RouteNames.removeGroupMembers,
        path: '/remove-group-members',
        builder: (context, state) {
          final List<dynamic> extras = state.extra as List<dynamic>;
          return RemoveGroupMembersView(
            groupId: extras[0],
            membersToRemoveFrom: extras[1],
          );
        },
      ),
      GoRoute(
        name: RouteNames.addGroupAdmin,
        path: '/add-group-admins',
        builder: (context, state) {
          final List<dynamic> extras = state.extra as List<dynamic>;
          return BlocProvider(
              create: (context) => GroupCubit(),
              child: AddGroupAdminView(
                groupId: extras[0],
                usersToMakeAdmins: extras[1],
              ));
        },
      ),
      GoRoute(
        name: RouteNames.addContact,
        path: '/add-contact',
        builder: (context, state) => AddContactView(),
      ),
    ],
  );
}
