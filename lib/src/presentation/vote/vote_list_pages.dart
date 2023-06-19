import 'package:dart_flutter/src/presentation/vote/viewmodel/state/vote_list_state.dart';
import 'package:dart_flutter/src/presentation/vote/viewmodel/vote_list_cubit.dart';
import 'package:dart_flutter/src/presentation/vote/vote_detail_view.dart';
import 'package:dart_flutter/src/presentation/vote/vote_list_inform_view.dart';
import 'package:dart_flutter/src/presentation/vote/vote_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoteListPages extends StatelessWidget {
  const VoteListPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // SafeArea(child: Center(child: Text("hello"))),
        BlocBuilder<VoteListCubit, VoteListState>(
          builder: (context, state) {
            if (state.isFirstTime) {
              return const VoteListInformView();
            }
            if (!state.isFirstTime) {
              if (state.isDetailPage) {
                return const VoteDetailView();
              } else {
                return const VoteListView();
              }
            }
            return SafeArea(child: Center(child: Text(state.toString())));
          },
        ),

        // BlocBuilder<VoteListCubit, VoteListState>(
        //   builder: (context, state) {
        //     return SafeArea(child: Container(alignment: Alignment.bottomCenter,child: Text(state.toString(), style: TextStyle(color: Colors.red))));
        //   },
        // ),
      ],
    );
  }
}
