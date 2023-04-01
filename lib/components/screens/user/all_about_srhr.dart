import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/course/downloaded_courses.dart';
import 'package:smartrr/components/screens/user/videos.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/components/widgets/text_to_speech.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/components/screens/course/courses.dart';

class AllAboutSRHR extends StatefulWidget {
  AllAboutSRHR({super.key});

  @override
  State<AllAboutSRHR> createState() => _AllAboutSRHRState();
}

class _AllAboutSRHRState extends State<AllAboutSRHR>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);
    return Consumer<LanguageNotifier>(
        builder: (context, langNotifier, child) => Scaffold(
              appBar: AppBar(
                title: Text(_language.allAboutSRHR),
                actions: [
                  LanguagePicker(),
                  IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DownloadedCourses())),
                      icon: Icon(Icons.download_done))
                ],
                bottom: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: _language.read,
                      icon: Icon(Icons.chrome_reader_mode_outlined),
                    ),
                    Tab(
                      text: _language.watch,
                      icon: Icon(Icons.video_collection_outlined),
                    )
                  ],
                ),
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Courses(),
                  Videos(),
                ],
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
