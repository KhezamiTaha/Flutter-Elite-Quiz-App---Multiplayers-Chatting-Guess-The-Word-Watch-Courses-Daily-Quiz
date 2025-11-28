// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:flutterquiz/app/routes.dart';
// import 'package:flutterquiz/features/quiz/models/comprehension.dart';
// import 'package:flutterquiz/features/quiz/models/quiz_type.dart';
// import 'package:flutterquiz/ui/widgets/FullScreenWebView.dart';
// import 'package:flutterquiz/ui/widgets/custom_appbar.dart';
// import 'package:flutterquiz/ui/widgets/custom_rounded_button.dart';
// import 'package:flutterquiz/utils/constants/fonts.dart';
// import 'package:flutterquiz/utils/constants/string_labels.dart';
// import 'package:flutterquiz/utils/extensions.dart';
// import 'package:flutterquiz/utils/ui_utils.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// /// ✅ Extracts the first YouTube embed URL from the HTML string
// String? extractYouTubeEmbedUrl(String html) {
//   final regex = RegExp('src=["\'](https:\\/\\/www\\.youtube\\.com\\/embed\\/[^"\']+)["\']');
//   final match = regex.firstMatch(html);
//   return match != null ? match.group(1) : null;
// }
//
// class FunAndLearnScreen extends StatefulWidget {
//   const FunAndLearnScreen({
//     required this.quizType,
//     required this.comprehension,
//     super.key,
//   });
//
//   final QuizTypes quizType;
//   final Comprehension comprehension;
//
//   @override
//   State<FunAndLearnScreen> createState() => _FunAndLearnScreen();
//
//   static Route<dynamic> route(RouteSettings routeSettings) {
//     final arguments = routeSettings.arguments as Map?;
//     return CupertinoPageRoute(
//       builder: (_) => FunAndLearnScreen(
//         quizType: arguments!['quizType'] as QuizTypes,
//         comprehension: arguments['comprehension'] as Comprehension,
//       ),
//     );
//   }
// }
//
// class _FunAndLearnScreen extends State<FunAndLearnScreen> with TickerProviderStateMixin {
//   late final _ytController = YoutubePlayerController(
//     initialVideoId: widget.comprehension.contentData,
//     flags: const YoutubePlayerFlags(
//       autoPlay: false,
//     ),
//   );
//
//   bool showFullPdf = false;
//
//   @override
//   void dispose() {
//     _ytController.dispose();
//     super.dispose();
//   }
//
//   void navigateToQuestionScreen() {
//     Navigator.of(context).pushReplacementNamed(
//       Routes.quiz,
//       arguments: {
//         'numberOfPlayer': 1,
//         'quizType': QuizTypes.funAndLearn,
//         'comprehension': widget.comprehension,
//         'quizName': context.tr('funAndLearn'),
//       },
//     );
//   }
//
//   Widget _buildStartButton() {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: 30,
//         left: context.width * UiUtils.hzMarginPct,
//         right: context.width * UiUtils.hzMarginPct,
//       ),
//       child: CustomRoundedButton(
//         widthPercentage: context.width,
//         backgroundColor: Theme.of(context).primaryColor,
//         buttonTitle: context.tr(letsStart),
//         radius: 8,
//         onTap: navigateToQuestionScreen,
//         titleColor: Theme.of(context).colorScheme.surface,
//         showBorder: false,
//         height: 58,
//         elevation: 5,
//         textSize: 18,
//         fontWeight: FontWeights.semiBold,
//       ),
//     );
//   }
//
//   Widget _buildParagraph(Widget player) {
//     final embedUrl = extractYouTubeEmbedUrl(widget.comprehension.detail);
//
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surface,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           height: context.height * .75,
//           margin: EdgeInsets.symmetric(
//             horizontal: context.width * UiUtils.hzMarginPct,
//           ),
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Column(
//               children: [
//                 if (widget.comprehension.contentType == ContentType.yt) player,
//                 if (widget.comprehension.contentType == ContentType.pdf) ...[
//                   SizedBox(
//                     height: context.height * (showFullPdf ? .7 : 0.2),
//                     child: const PDF(
//                       swipeHorizontal: true,
//                       fitPolicy: FitPolicy.BOTH,
//                     ).fromUrl(widget.comprehension.contentData),
//                   ),
//                   TextButton(
//                     onPressed: () => setState(() => showFullPdf = !showFullPdf),
//                     child: Text(
//                       context.tr(showFullPdf ? 'showLess' : 'showFull')!,
//                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                         color: Theme.of(context).colorScheme.onTertiary,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 50),
//                 HtmlWidget(
//                   widget.comprehension.detail,
//                   onTapUrl: (url) async {
//                     if (url.contains("youtube.com/embed")) {
//                       Navigator.of(context).push<void>(
//                         MaterialPageRoute<void>(
//                           builder: (_) => FullScreenWebView(url: url),
//                         ),
//                       );
//                       return true;
//                     }
//                     return false;
//                   },
//                   onErrorBuilder: (_, e, err) => Text('$e error: $err'),
//                   onLoadingBuilder: (_, e, l) => const Center(child: CircularProgressIndicator()),
//                   textStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onTertiary,
//                     fontWeight: FontWeights.regular,
//                     fontSize: 18,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ),
//         if (embedUrl != null)
//           Positioned(
//             top: 17,   // outside container top
//             right: context.width * UiUtils.hzMarginPct + 5,  // adjust based on margin
//             child: IconButton(
//               icon: const Icon(
//                 Icons.fullscreen,
//                 color: Colors.black,
//                 size: 32,
//               ),
//               onPressed: () {
//                 Navigator.of(context).push<void>(
//                   MaterialPageRoute<void>(
//                     builder: (_) => FullScreenWebView(url: embedUrl),
//                   ),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       player: YoutubePlayer(
//         controller: _ytController,
//         progressIndicatorColor: Theme.of(context).primaryColor,
//         progressColors: ProgressBarColors(
//           playedColor: Theme.of(context).primaryColor,
//           bufferedColor: Theme.of(context).colorScheme.onTertiary.withOpacity(.5),
//           backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(.5),
//           handleColor: Theme.of(context).primaryColor,
//         ),
//       ),
//       onExitFullScreen: () {
//         SystemChrome.setEnabledSystemUIMode(
//           SystemUiMode.manual,
//           overlays: SystemUiOverlay.values,
//         );
//       },
//       builder: (context, player) {
//         return Scaffold(
//           appBar: QAppBar(
//             roundedAppBar: false,
//             title: Text(widget.comprehension.title),
//           ),
//           body: Stack(
//             children: [
//               Align(alignment: Alignment.topCenter, child: _buildParagraph(player)),
//               Align(alignment: Alignment.bottomCenter, child: _buildStartButton()),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

/// taha
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:flutterquiz/app/routes.dart';
// import 'package:flutterquiz/features/quiz/models/comprehension.dart';
// import 'package:flutterquiz/features/quiz/models/quiz_type.dart';
// import 'package:flutterquiz/ui/widgets/FullScreenWebView.dart';
// import 'package:flutterquiz/ui/widgets/custom_appbar.dart';
// import 'package:flutterquiz/ui/widgets/custom_rounded_button.dart';
// import 'package:flutterquiz/utils/constants/fonts.dart';
// import 'package:flutterquiz/utils/constants/string_labels.dart';
// import 'package:flutterquiz/utils/extensions.dart';
// import 'package:flutterquiz/utils/ui_utils.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// /// ✅ Extracts the first YouTube embed URL from the HTML string
// String? extractYouTubeEmbedUrl(String html) {
//   final regex = RegExp('src=["\'](https:\\/\\/www\\.youtube\\.com\\/embed\\/[^"\']+)["\']');
//   final match = regex.firstMatch(html);
//   return match?.group(1);
// }
//
// class FunAndLearnScreen extends StatefulWidget {
//   const FunAndLearnScreen({
//     required this.quizType,
//     required this.comprehension,
//     super.key,
//   });
//
//   final QuizTypes quizType;
//   final Comprehension comprehension;
//
//   @override
//   State<FunAndLearnScreen> createState() => _FunAndLearnScreen();
//
//   static Route<dynamic> route(RouteSettings routeSettings) {
//     final arguments = routeSettings.arguments as Map?;
//     return CupertinoPageRoute(
//       builder: (_) => FunAndLearnScreen(
//         quizType: arguments!['quizType'] as QuizTypes,
//         comprehension: arguments['comprehension'] as Comprehension,
//       ),
//     );
//   }
// }
//
// class _FunAndLearnScreen extends State<FunAndLearnScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
//   late final YoutubePlayerController _ytController;
//   bool showFullPdf = false;
//   late String _htmlKey;
//
//   @override
//   void initState() {
//     super.initState();
//     _ytController = YoutubePlayerController(
//       initialVideoId: widget.comprehension.contentData,
//       flags: const YoutubePlayerFlags(autoPlay: false),
//     );
//     _htmlKey = UniqueKey().toString();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _ytController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // 🔁 Force HtmlWidget to reload
//       setState(() {
//         _htmlKey = UniqueKey().toString();
//       });
//     }
//   }
//
//   void navigateToQuestionScreen() {
//     Navigator.of(context).pushReplacementNamed(
//       Routes.quiz,
//       arguments: {
//         'numberOfPlayer': 1,
//         'quizType': QuizTypes.funAndLearn,
//         'comprehension': widget.comprehension,
//         'quizName': context.tr('funAndLearn'),
//       },
//     );
//   }
//
//   Widget _buildStartButton() {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: 30,
//         left: context.width * UiUtils.hzMarginPct,
//         right: context.width * UiUtils.hzMarginPct,
//       ),
//       child: CustomRoundedButton(
//         widthPercentage: context.width,
//         backgroundColor: Theme.of(context).primaryColor,
//         buttonTitle: context.tr(letsStart),
//         radius: 8,
//         onTap: navigateToQuestionScreen,
//         titleColor: Theme.of(context).colorScheme.surface,
//         showBorder: false,
//         height: 58,
//         elevation: 5,
//         textSize: 18,
//         fontWeight: FontWeights.semiBold,
//       ),
//     );
//   }
//
//   Widget _buildParagraph(Widget player) {
//     final embedUrl = extractYouTubeEmbedUrl(widget.comprehension.detail);
//
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surface,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           height: context.height * .75,
//           margin: EdgeInsets.symmetric(
//             horizontal: context.width * UiUtils.hzMarginPct,
//           ),
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Column(
//               children: [
//                 if (widget.comprehension.contentType == ContentType.yt) player,
//                 if (widget.comprehension.contentType == ContentType.pdf) ...[
//                   SizedBox(
//                     height: context.height * (showFullPdf ? .7 : 0.2),
//                     child: const PDF(
//                       swipeHorizontal: true,
//                       fitPolicy: FitPolicy.BOTH,
//                     ).fromUrl(widget.comprehension.contentData),
//                   ),
//                   TextButton(
//                     onPressed: () => setState(() => showFullPdf = !showFullPdf),
//                     child: Text(
//                       context.tr(showFullPdf ? 'showLess' : 'showFull')!,
//                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                         color: Theme.of(context).colorScheme.onTertiary,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 50),
//                 HtmlWidget(
//                   widget.comprehension.detail,
//                   key: Key(_htmlKey), // 👈 force rebuild on resume
//                   onTapUrl: (url) async {
//                     if (url.contains("youtube.com/embed")) {
//                       Navigator.of(context).push<void>(
//                         MaterialPageRoute<void>(
//                           builder: (_) => FullScreenWebView(url: url),
//                         ),
//                       );
//                       return true;
//                     }
//                     return false;
//                   },
//                   onErrorBuilder: (_, e, err) => Text('$e error: $err'),
//                   onLoadingBuilder: (_, e, l) => const Center(child: CircularProgressIndicator()),
//                   textStyle: TextStyle(
//                     color: Theme.of(context).colorScheme.onTertiary,
//                     fontWeight: FontWeights.regular,
//                     fontSize: 18,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ),
//         if (embedUrl != null)
//           Positioned(
//             top: 17,
//             right: context.width * UiUtils.hzMarginPct + 5,
//             child: IconButton(
//               icon: const Icon(Icons.fullscreen, color: Colors.black, size: 32),
//               onPressed: () {
//                 Navigator.of(context).push<void>(
//                   MaterialPageRoute<void>(
//                     builder: (_) => FullScreenWebView(url: embedUrl),
//                   ),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       player: YoutubePlayer(
//         controller: _ytController,
//         progressIndicatorColor: Theme.of(context).primaryColor,
//         progressColors: ProgressBarColors(
//           playedColor: Theme.of(context).primaryColor,
//           bufferedColor: Theme.of(context).colorScheme.onTertiary.withOpacity(.5),
//           backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(.5),
//           handleColor: Theme.of(context).primaryColor,
//         ),
//       ),
//       onExitFullScreen: () {
//         SystemChrome.setEnabledSystemUIMode(
//           SystemUiMode.manual,
//           overlays: SystemUiOverlay.values,
//         );
//       },
//       builder: (context, player) {
//         return Scaffold(
//           appBar: QAppBar(
//             roundedAppBar: false,
//             title: Text(widget.comprehension.title),
//           ),
//           body: Stack(
//             children: [
//               Align(alignment: Alignment.topCenter, child: _buildParagraph(player)),
//               Align(alignment: Alignment.bottomCenter, child: _buildStartButton()),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

/// taha version 1

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:flutterquiz/app/routes.dart';
// import 'package:flutterquiz/features/quiz/models/comprehension.dart';
// import 'package:flutterquiz/features/quiz/models/quiz_type.dart';
// import 'package:flutterquiz/ui/widgets/FullScreenWebView.dart';
// import 'package:flutterquiz/ui/widgets/custom_appbar.dart';
// import 'package:flutterquiz/ui/widgets/custom_rounded_button.dart';
// import 'package:flutterquiz/utils/constants/fonts.dart';
// import 'package:flutterquiz/utils/constants/string_labels.dart';
// import 'package:flutterquiz/utils/extensions.dart';
// import 'package:flutterquiz/utils/ui_utils.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// /// ✅ Extract YouTube iframe src
// String? extractYouTubeEmbedUrl(String html) {
//   final regex = RegExp('src=["\'](https:\\/\\/www\\.youtube\\.com\\/embed\\/[^"\']+)["\']');
//   final match = regex.firstMatch(html);
//   return match?.group(1);
// }
//
// /// ✅ Widget that wraps HtmlWidget with a loading spinner
// class HtmlWithLoader extends StatefulWidget {
//   final String htmlContent;
//
//   const HtmlWithLoader({super.key, required this.htmlContent});
//
//   @override
//   State<HtmlWithLoader> createState() => _HtmlWithLoaderState();
// }
//
// class _HtmlWithLoaderState extends State<HtmlWithLoader> {
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     // Simulate short loading time
//     Future.delayed(const Duration(milliseconds: 500)).then((_) {
//       if (mounted) setState(() => _isLoading = false);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         HtmlWidget(
//           widget.htmlContent,
//           onLoadingBuilder: (_, __, ___) => const SizedBox.shrink(),
//           onErrorBuilder: (_, e, err) => Text('$e error: $err'),
//           onTapUrl: (url) async {
//             if (url.contains("youtube.com/embed")) {
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => FullScreenWebView(url: url)),
//               );
//               return true;
//             }
//             return false;
//           },
//           textStyle: TextStyle(
//             color: Theme.of(context).colorScheme.onTertiary,
//             fontWeight: FontWeights.regular,
//             fontSize: 18,
//           ),
//         ),
//         if (_isLoading)
//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withOpacity(0.05),
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//           ),
//       ],
//     );
//   }
// }
//
//
// class FunAndLearnScreen extends StatefulWidget {
//   const FunAndLearnScreen({
//     required this.quizType,
//     required this.comprehension,
//     super.key,
//   });
//
//   final QuizTypes quizType;
//   final Comprehension comprehension;
//
//   @override
//   State<FunAndLearnScreen> createState() => _FunAndLearnScreen();
//
//   static Route<dynamic> route(RouteSettings routeSettings) {
//     final arguments = routeSettings.arguments as Map?;
//     return CupertinoPageRoute(
//       builder: (_) => FunAndLearnScreen(
//         quizType: arguments!['quizType'] as QuizTypes,
//         comprehension: arguments['comprehension'] as Comprehension,
//       ),
//     );
//   }
// }
//
// class _FunAndLearnScreen extends State<FunAndLearnScreen>
//     with WidgetsBindingObserver, TickerProviderStateMixin {
//   late final YoutubePlayerController _ytController;
//   bool showFullPdf = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _ytController = YoutubePlayerController(
//       initialVideoId: widget.comprehension.contentData,
//       flags: const YoutubePlayerFlags(autoPlay: false),
//     );
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _ytController.dispose();
//     super.dispose();
//   }
//
//   void navigateToQuestionScreen() {
//     Navigator.of(context).pushReplacementNamed(
//       Routes.quiz,
//       arguments: {
//         'numberOfPlayer': 1,
//         'quizType': QuizTypes.funAndLearn,
//         'comprehension': widget.comprehension,
//         'quizName': context.tr('funAndLearn'),
//       },
//     );
//   }
//
//   Widget _buildStartButton() {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: 30,
//         left: context.width * UiUtils.hzMarginPct,
//         right: context.width * UiUtils.hzMarginPct,
//       ),
//       child: CustomRoundedButton(
//         widthPercentage: context.width,
//         backgroundColor: Theme.of(context).primaryColor,
//         buttonTitle: context.tr(letsStart),
//         radius: 8,
//         onTap: navigateToQuestionScreen,
//         titleColor: Theme.of(context).colorScheme.surface,
//         showBorder: false,
//         height: 58,
//         elevation: 5,
//         textSize: 18,
//         fontWeight: FontWeights.semiBold,
//       ),
//     );
//   }
//
//   Widget _buildParagraph(Widget player) {
//     final embedUrl = extractYouTubeEmbedUrl(widget.comprehension.detail);
//
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surface,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           height: context.height * .75,
//           margin: EdgeInsets.symmetric(
//             horizontal: context.width * UiUtils.hzMarginPct,
//           ),
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Column(
//               children: [
//                 if (widget.comprehension.contentType == ContentType.yt) player,
//                 if (widget.comprehension.contentType == ContentType.pdf) ...[
//                   SizedBox(
//                     height: context.height * (showFullPdf ? .7 : 0.2),
//                     child: const PDF(
//                       swipeHorizontal: true,
//                       fitPolicy: FitPolicy.BOTH,
//                     ).fromUrl(widget.comprehension.contentData),
//                   ),
//                   TextButton(
//                     onPressed: () => setState(() => showFullPdf = !showFullPdf),
//                     child: Text(
//                       context.tr(showFullPdf ? 'showLess' : 'showFull')!,
//                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                         color: Theme.of(context).colorScheme.onTertiary,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 50),
//                 HtmlWithLoader(htmlContent: widget.comprehension.detail),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ),
//         if (embedUrl != null)
//           Positioned(
//             top: 17,
//             right: context.width * UiUtils.hzMarginPct + 5,
//             child: IconButton(
//               icon: const Icon(Icons.fullscreen, color: Colors.black, size: 32),
//               onPressed: () {
//                 Navigator.of(context).push<void>(
//                   MaterialPageRoute<void>(
//                     builder: (_) => FullScreenWebView(url: embedUrl),
//                   ),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       player: YoutubePlayer(
//         controller: _ytController,
//         progressIndicatorColor: Theme.of(context).primaryColor,
//         progressColors: ProgressBarColors(
//           playedColor: Theme.of(context).primaryColor,
//           bufferedColor: Theme.of(context).colorScheme.onTertiary.withOpacity(.5),
//           backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(.5),
//           handleColor: Theme.of(context).primaryColor,
//         ),
//       ),
//       onExitFullScreen: () {
//         SystemChrome.setEnabledSystemUIMode(
//           SystemUiMode.manual,
//           overlays: SystemUiOverlay.values,
//         );
//       },
//       builder: (context, player) {
//         return Scaffold(
//           appBar: QAppBar(
//             roundedAppBar: false,
//             title: Text(widget.comprehension.title),
//           ),
//           body: Stack(
//             children: [
//               Align(alignment: Alignment.topCenter, child: _buildParagraph(player)),
//               Align(alignment: Alignment.bottomCenter, child: _buildStartButton()),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }


/// taha version 2


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutterquiz/app/routes.dart';
import 'package:flutterquiz/features/quiz/models/comprehension.dart';
import 'package:flutterquiz/features/quiz/models/quiz_type.dart';
import 'package:flutterquiz/ui/widgets/FullScreenWebView.dart';
import 'package:flutterquiz/ui/widgets/custom_appbar.dart';
import 'package:flutterquiz/ui/widgets/custom_rounded_button.dart';
import 'package:flutterquiz/utils/constants/fonts.dart';
import 'package:flutterquiz/utils/constants/string_labels.dart';
import 'package:flutterquiz/utils/extensions.dart';
import 'package:flutterquiz/utils/ui_utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

String? extractYouTubeEmbedUrl(String html) {
  // final regex = RegExp('src=["\'](https:\\/\\/www\\.youtube\\.com\\/embed\\/[^"\']+)["\']');
  final regex = RegExp(
      "src=[\"'](https:\\/\\/www\\.youtube\\.com\\/embed\\/[^\"'\\s]+(?:\\?[^\"']*)?)[\"']"
  );
  final match = regex.firstMatch(html);
  return match?.group(1);
}

class HtmlWithLoader extends StatefulWidget {
  final String htmlContent;

  const HtmlWithLoader({super.key, required this.htmlContent});

  @override
  State<HtmlWithLoader> createState() => _HtmlWithLoaderState();
}

class _HtmlWithLoaderState extends State<HtmlWithLoader> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HtmlWidget(
          widget.htmlContent,
          onLoadingBuilder: (_, __, ___) => const SizedBox.shrink(),
          onErrorBuilder: (_, e, err) => Text('$e error: $err'),
          onTapUrl: (url) async {
            if (url.contains("youtube.com/embed")) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => FullScreenWebView(url: url)),
              );
              return true;
            }
            return false;
          },
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.onTertiary,
            fontWeight: FontWeights.regular,
            fontSize: 18,
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.05),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

class FunAndLearnScreen extends StatefulWidget {
  const FunAndLearnScreen({
    required this.quizType,
    required this.comprehension,
    super.key,
  });

  final QuizTypes quizType;
  final Comprehension comprehension;

  @override
  State<FunAndLearnScreen> createState() => _FunAndLearnScreen();

  static Route<dynamic> route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map?;
    return CupertinoPageRoute(
      builder: (_) => FunAndLearnScreen(
        quizType: arguments!['quizType'] as QuizTypes,
        comprehension: arguments['comprehension'] as Comprehension,
      ),
    );
  }
}

class _FunAndLearnScreen extends State<FunAndLearnScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final YoutubePlayerController _ytController;
  bool showFullPdf = false;
  Key _htmlWidgetKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _ytController = YoutubePlayerController(
      initialVideoId: widget.comprehension.contentData,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ytController.dispose();
    super.dispose();
  }

  void navigateToQuestionScreen() {
    Navigator.of(context).pushReplacementNamed(
      Routes.quiz,
      arguments: {
        'numberOfPlayer': 1,
        'quizType': QuizTypes.funAndLearn,
        'comprehension': widget.comprehension,
        'quizName': context.tr('funAndLearn'),
      },
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 30,
        left: context.width * UiUtils.hzMarginPct,
        right: context.width * UiUtils.hzMarginPct,
      ),
      child: CustomRoundedButton(
        widthPercentage: context.width,
        backgroundColor: Theme.of(context).primaryColor,
        buttonTitle: context.tr(letsStart),
        radius: 8,
        onTap: navigateToQuestionScreen,
        titleColor: Theme.of(context).colorScheme.surface,
        showBorder: false,
        height: 58,
        elevation: 5,
        textSize: 18,
        fontWeight: FontWeights.semiBold,
      ),
    );
  }

  Widget _buildParagraph(Widget player) {
    final embedUrl = extractYouTubeEmbedUrl(widget.comprehension.detail);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          height: context.height * .75,
          margin: EdgeInsets.symmetric(
            horizontal: context.width * UiUtils.hzMarginPct,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                if (widget.comprehension.contentType == ContentType.yt) player,
                if (widget.comprehension.contentType == ContentType.pdf) ...[
                  SizedBox(
                    height: context.height * (showFullPdf ? .7 : 0.2),
                    child: const PDF(
                      swipeHorizontal: true,
                      fitPolicy: FitPolicy.BOTH,
                    ).fromUrl(widget.comprehension.contentData),
                  ),
                  TextButton(
                    onPressed: () => setState(() => showFullPdf = !showFullPdf),
                    child: Text(
                      context.tr(showFullPdf ? 'showLess' : 'showFull')!,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onTertiary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 50),
                HtmlWithLoader(
                  key: _htmlWidgetKey,
                  htmlContent: widget.comprehension.detail,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),

        // 🔁 Refresh button on far left
        if (embedUrl != null)
          Positioned(
            top: 17,
            left: context.width * UiUtils.hzMarginPct + 5,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black, size: 26),
              onPressed: () {
                setState(() {
                  _htmlWidgetKey = UniqueKey(); // Reload HtmlWithLoader
                });
              },
            ),
          ),

        // 🔳 Fullscreen button on far right
        if (embedUrl != null)
          Positioned(
            top: 17,
            right: context.width * UiUtils.hzMarginPct + 5,
            child: IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.black, size: 32),
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => FullScreenWebView(url: embedUrl),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _ytController,
        progressIndicatorColor: Theme.of(context).primaryColor,
        progressColors: ProgressBarColors(
          playedColor: Theme.of(context).primaryColor,
          bufferedColor: Theme.of(context).colorScheme.onTertiary.withOpacity(.5),
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(.5),
          handleColor: Theme.of(context).primaryColor,
        ),
      ),
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      },
      builder: (context, player) {
        return Scaffold(
          appBar: QAppBar(
            roundedAppBar: false,
            title: Text(
              widget.comprehension.title,
              softWrap: true,  // Allow text wrapping
              maxLines: 2,  // Unlimited number of lines (i.e., no truncation)
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17 /// taha
              ),
            ),
          ),
          body: Stack(
            children: [
              Align(alignment: Alignment.topCenter, child: _buildParagraph(player)),
              Align(alignment: Alignment.bottomCenter, child: _buildStartButton()),
            ],
          ),
        );
      },
    );
  }
}


