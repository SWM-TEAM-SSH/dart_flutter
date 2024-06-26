import 'package:dart_flutter/src/common/util/analytics_util.dart';
import 'package:dart_flutter/src/presentation/meet/deprecated/meet_standby.dart';
import 'package:dart_flutter/src/presentation/meet/viewmodel/meet_cubit.dart';
import 'package:dart_flutter/src/presentation/meet/viewmodel/state/meet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@Deprecated("더 이상 사용되지 않음")
class MeetPage2 extends StatefulWidget {
  const MeetPage2({Key? key}) : super(key: key);

  @override
  State<MeetPage2> createState() => _MeetPage2State();
}

class _MeetPage2State extends State<MeetPage2> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        BlocBuilder<MeetCubit, MeetState>(
          builder: (context, state) {
            AnalyticsUtil.logEvent('과팅_대기_접속');
            return const MeetStandby();
          }
        ),
        BlocBuilder<MeetCubit, MeetState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox.shrink();
            }
        ),
      ],
    );
  }
}
