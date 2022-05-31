import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/models/session.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/widgets/custom_shimmer.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/session_card.dart';
import 'package:task_manager/pages/qr_scanner_page/bloc/qr_bloc.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({Key? key}) : super(key: key);

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final _bloc = QrBloc();

  List<Session> _sessions = [];

  bool isLoading = false;

  Future<void> _onRefresh() async {
    _bloc.getSessions();
    return Future.delayed(const Duration(milliseconds: 50));
  }

  Future<geocoding.Placemark?> getPlacemark(double? lat, double? lng) async {
    if (lat == null || lng == null) return null;
    final _geocoding = geocoding.GeocodingPlatform.instance;
    final placemarks = await _geocoding.placemarkFromCoordinates(lat, lng);
    return placemarks.first;
  }

  @override
  void initState() {
    super.initState();
    _bloc.getSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        centerTitle: true,
        title: Text(
          'sessions'.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocListener(
        bloc: _bloc,
        listener: (context, state) async {
          isLoading = state is QrLoading;

          if (state is ErrorState) {
            AlertController.showResultDialog(context: context, message: state.error, isSuccess: null);
          }

          if (state is QrSessionsLoaded) {
            _sessions = state.sessions.reversed.toList();
          }

          if (isLoading) {
            Future.delayed(const Duration(milliseconds: 100), () => setState(() {}));
          } else {
            setState(() {});
          }
        },
        child: CustomShimmer(
          enabled: isLoading,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: _sessions.isEmpty
                ? SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'list_is_empty'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                : CupertinoScrollbar(
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _sessions.length,
                      separatorBuilder: (context, index) => const EmptyBox(height: 12.0),
                      itemBuilder: (context, index) => SessionCard(
                        session: _sessions[index],
                        getPlacemark: getPlacemark(_sessions[index].lat, _sessions[index].lng),
                        onSessionCreated: () {
                          _bloc.getSessions();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
