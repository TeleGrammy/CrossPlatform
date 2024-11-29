// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:telegrammy/cores/constants/app_colors.dart';
// import 'package:telegrammy/cores/routes/routes_name.dart';
// import 'package:telegrammy/cores/widgets/rounded_button.dart';
// import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
// import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
// import '../../view_models/profile_settings_cubit/profile_state.dart';

// class StoriesPage extends StatefulWidget {
//   const StoriesPage({super.key});

//   @override
//   State<StoriesPage> createState() => _StoriesPageState();
// }

// class _StoriesPageState extends State<StoriesPage> {
//   Future<void> _loadBasicProfileInfo(BuildContext context) async {
//     await context.read<ProfileSettingsCubit>().loadBasicProfileInfo();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadBasicProfileInfo(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ProfileSettingsAppBar(title: 'My Stories'),
//       body: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
//           builder: (context, state) {
//         print(state);
//         if (state is ProfileInitial) {
//           _loadBasicProfileInfo(context);
//         } else if (state is ProfileLoading) {
//           return Center(child: CircularProgressIndicator());
//         } else if (state is ProfileError) {
//           return Center(child: Text(state.errorMessage));
//         } else if (state is ProfileLoaded) {
//           print(state.user.stories);
//           return SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     getStoryCards(context, state.user.stories),
//                     RoundedButton(
//                         onPressed: () => _showPopUp(
//                             context, context.read<ProfileSettingsCubit>()),
//                         buttonTitle: 'Add Story'),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//         return Center(child: Text('-'));
//       }),
//     );
//   }

//   Future<void> _showPopUp(
//       BuildContext context, ProfileSettingsCubit cubit) async {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (BuildContext context) {
//         return Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.photo_camera),
//               title: Text('Choose Image to Create Story'),
//               onTap: () {
//                 Navigator.pop(context);
//                 cubit.addStory();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Column getStoryCards(BuildContext context, List<File> stories) {
//     if (stories.length == 0) return Column();

//     List<Container> cards = [];
//     stories.forEach((storyImageFile) => cards.add(Container(
//           margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//           padding: EdgeInsets.all(8.0),
//           decoration: BoxDecoration(
//             color: primaryColor,
//             borderRadius: BorderRadius.circular(12.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 4.0,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               // Small circular image on the left
//               CircleAvatar(
//                 radius: 40.0,
//                 backgroundImage: FileImage(storyImageFile),
//               ),
//               SizedBox(width: 16.0),

//               // Centered "View" button
//               Expanded(
//                 child: TextButton(
//                   onPressed: () {
//                     context.pushNamed(RouteNames.storyView,
//                         extra: storyImageFile);
//                   },
//                   child: Text("View"),
//                   style: TextButton.styleFrom(
//                     backgroundColor: backGroundColor,
//                     //primary: Colors.white,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8.0),

//               IconButton(
//                 onPressed: () {
//                   context
//                       .read<ProfileSettingsCubit>()
//                       .removeStory(storyImageFile);
//                 },
//                 icon: Icon(Icons.delete, color: Colors.red),
//               ),
//             ],
//           ),
//         )));
//     return Column(
//       children: cards,
//     );
//   }
// }
