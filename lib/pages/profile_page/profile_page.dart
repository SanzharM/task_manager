import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/supporting/app_router.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_card.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/custom_shimmer.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/page_routes/custom_page_route.dart';
import 'package:task_manager/pages/login_page/intro_page.dart';
import 'package:task_manager/pages/profile_page/bloc/profile_bloc.dart';
import 'package:task_manager/pages/settings_page/about_app_page.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.changeLanguage,
    required this.changeTab,
  }) : super(key: key);

  final void Function(Locale locale) changeLanguage;
  final void Function(int index) changeTab;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _bloc = ProfileBloc();
  final _scrollController = ScrollController();

  User? _user;
  List<User> _collegues = [];

  bool isLoading = false;
  bool colleguesLoading = false;

  void _toEditProfile() => AppRouter.toEditProfile(context: context, user: _user);
  void _toPersonalAccount() => AppRouter.toPersonalAccount(context: context, user: _user!);
  void _toTeamMembers() => _user == null ? null : AppRouter.toTeamMembers(context: context, users: _collegues);
  void _toSettings() => AppRouter.toSettings(context: context, changeLanguage: widget.changeLanguage);
  void _toOrganization() =>
      _user?.organization == null ? null : AppRouter.toOrganizationPage(context: context, organization: _user!.organization!);

  void scrollToTop() => _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );

  Future<void> _onRefresh() async {
    _bloc.getProfile();
    _bloc.getCollegues();
    await Future.delayed(const Duration(milliseconds: 450));
  }

  @override
  void initState() {
    Application.getPhone().then((value) => setState(() => _user = User(phone: value)));
    _bloc.getProfile();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: _bloc,
        listener: (context, state) {
          isLoading = state is ProfileLoading;
          colleguesLoading = state is ColleguesLoading;

          if (state is ErrorState) {
            AlertController.showSnackbar(context: context, message: state.error);
          }

          if (state is ProfileLoaded) {
            _user = state.user;
            if (state.user.needToFillProfile())
              AppRouter.toEditProfile(context: context, user: state.user, onNext: () => _bloc.getProfile());
          }

          if (state is ColleguesLoaded) {
            _collegues = state.collegues;
          }

          setState(() {});
        },
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16.0),
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                controller: _scrollController,
                child: Column(
                  children: [
                    CustomShimmer(
                      enabled: isLoading,
                      child: Center(
                        child: Column(
                          children: [
                            // Avatar
                            ClipOval(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.width * 0.25,
                                  maxWidth: MediaQuery.of(context).size.width * 0.25,
                                ),
                                child: _user!.tryGetImage(),
                              ),
                            ),

                            // Name Surname
                            const EmptyBox(height: 12),
                            if (_user?.name != null)
                              Text(
                                _user!.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            if (_user?.name != null) const EmptyBox(height: 4),

                            // Phone Number
                            Text(
                              Utils.formattedPhone(_user?.phone ?? ''),
                              style: _user?.name == null ? const TextStyle(fontSize: 18) : const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_user?.organization != null) const EmptyBox(height: 8),
                    if (_user?.organization != null)
                      InfoCell(
                        title: 'organization'.tr() + ': ',
                        value: _user?.organization?.name,
                        onTap: _toOrganization,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    const EmptyBox(height: 16),
                    // Profile cells
                    if (_user != null)
                      AppCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OneLineCell.arrowed(
                              leading: const Icon(CupertinoIcons.person_fill),
                              title: 'edit_profile'.tr(),
                              onTap: _toEditProfile,
                            ),
                            OneLineCell.arrowed(
                              leading: const Icon(CupertinoIcons.chart_bar_alt_fill),
                              title: 'personal_account'.tr(),
                              onTap: _toPersonalAccount,
                            ),
                            OneLineCell(
                              fillColor: Colors.transparent,
                              leading: const Icon(CupertinoIcons.person_3_fill),
                              title: 'your_colleagues'.tr(),
                              onTap: _toTeamMembers,
                              padding: const EdgeInsets.all(8.0),
                              icon: colleguesLoading ? const CupertinoActivityIndicator() : const Icon(CupertinoIcons.forward),
                            ),
                            OneLineCell.arrowed(
                              leading: const Icon(CupertinoIcons.calendar),
                              title: 'shift_history'.tr(),
                              onTap: () => AppRouter.toSessionsPage(context: context),
                            ),
                          ],
                        ),
                      ),
                    const EmptyBox(height: 12),
                    AppCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OneLineCell.arrowed(
                            leading: const Icon(CupertinoIcons.settings_solid),
                            title: 'settings'.tr(),
                            onTap: _toSettings,
                          ),
                          OneLineCell.arrowed(
                            leading: const Icon(CupertinoIcons.question_circle_fill),
                            title: 'contact_us'.tr(),
                            onTap: () => print('to contact us'),
                          ),
                          OneLineCell.arrowed(
                            leading: const Icon(CupertinoIcons.info_circle_fill),
                            title: 'about_us'.tr(),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AboutAppPage(),
                            )),
                          ),
                        ],
                      ),
                    ),
                    const EmptyBox(height: 8.0),
                    AppButton(
                      title: 'logout'.tr(),
                      onTap: () async {
                        await Application.setToken(null);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).pushReplacement(CustomPageRoute(direction: AxisDirection.right, child: IntroPage()));
                      },
                    ),
                    const EmptyBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
