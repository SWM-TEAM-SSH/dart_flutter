import 'dart:convert';
import 'package:chatview/chatview.dart';
import 'package:dart_flutter/res/config/size_config.dart';
import 'package:dart_flutter/src/common/chat/chat_connection.dart';
import 'package:dart_flutter/src/common/chat/message_pub.dart';
import 'package:dart_flutter/src/common/chat/message_sub.dart';
import 'package:dart_flutter/src/common/chat/type/chat_message_type.dart';
import 'package:dart_flutter/src/common/util/analytics_util.dart';
import 'package:dart_flutter/src/domain/entity/chat_room_detail.dart';
import 'package:dart_flutter/src/domain/entity/type/blind_date_user_detail.dart';
import 'package:dart_flutter/src/domain/entity/type/student.dart';
import 'package:dart_flutter/src/domain/entity/user.dart';
import 'package:dart_flutter/src/domain/mapper/student_mapper.dart';
import 'package:dart_flutter/src/presentation/chat/view/chatroom/chat_profile.dart';
import 'package:dart_flutter/src/presentation/chat/viewmodel/state/chatting_cubit.dart';
import 'package:dart_flutter/src/presentation/component/cached_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChattingRoom extends StatefulWidget {
  final ChatRoomDetail chatRoomDetail;
  final User user;

  const ChattingRoom({super.key, required this.chatRoomDetail, required this.user});

  @override
  State<ChattingRoom> createState() => _ChattingRoomState();
}

class _ChattingRoomState extends State<ChattingRoom> with WidgetsBindingObserver {
  String message = '';
  int page = 0;
  ChatController chatController = ChatController(
      initialMessageList: [],
      scrollController: ScrollController(),
      chatUsers: []
  );
  ChatUser currentUser = ChatUser(id: '0', name: '');
  ChatConnection chatConn = ChatConnection('', 0);

  void initConnectionAndSendFirstMessage() async {
    await _connectChatServer();
    await loadMoreMessages();
  }

  Future<void> _connectChatServer() async {
    await chatConn.activate();
    AnalyticsUtil.logEvent('채팅_채팅방_연결');

    chatConn.subscribe((frame) {
      MessageSub msg = MessageSub.fromJson(jsonDecode(frame.body ?? jsonEncode(MessageSub(chatRoomId: 0, chatMessageId: 0, senderId: 0, chatMessageType: ChatMessageType.TALK, content: '', createdTime: DateTime.now()).toJson())));
      chatController.addMessage(
        Message(
          message: msg.content,
          // createdAt: msg.createdTime,
          createdAt: msg.createdTime.add(const Duration(hours: 9)),
          sendBy: msg.senderId.toString(),
        ),
      );
      print("${msg.senderId} : ${msg.content}");
    });
  }

  @override
  void initState() {
    AnalyticsUtil.logEvent('채팅_채팅방_접속');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    chatConn = widget.chatRoomDetail.connection;

    initConnectionAndSendFirstMessage();

    currentUser = ChatUser(
      id: widget.user.personalInfo?.id.toString() ?? '0',
      name: (widget.user.personalInfo?.nickname ?? 'DEFAULT') == 'DEFAULT' ? widget.user.personalInfo?.name ?? '알수없음' : widget.user.personalInfo?.nickname ?? '알수없음',
      profilePhoto: widget.user.personalInfo?.profileImageUrl ?? ''
    );
    chatController.chatUsers.add(currentUser);

    for (Student student in widget.chatRoomDetail.myTeam.teamUsers) {
      BlindDateUserDetail user = StudentMapper.toBlindDateUserDetail(student);
      if (user.id != widget.user.personalInfo!.id) {
        chatController.chatUsers.add(
            ChatUser(
                id: user.id.toString(),
                name: user.name,
                profilePhoto: user.profileImageUrl
            )
        );
      }
    }
    for (Student student in widget.chatRoomDetail.otherTeam.teamUsers) {
      BlindDateUserDetail user = StudentMapper.toBlindDateUserDetail(student);
      chatController.chatUsers.add(
        ChatUser(
            id: user.id.toString(),
            name: user.name,
            profilePhoto: user.profileImageUrl
        )
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _disconnectChatRoom();
    }
    if (state == AppLifecycleState.resumed) {
      await _connectChatServer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _disconnectChatRoom();
  }

  void _disconnectChatRoom() {
    chatConn.deactivate();
    AnalyticsUtil.logEvent('채팅_채팅방_연결제거');

  }

  void onSendTap(String message, ReplyMessage replyMessage, MessageType messageType) {
    MessagePub msg = MessagePub(
        chatRoomId: widget.chatRoomDetail.id,
        senderId: widget.user.personalInfo?.id ?? 0,
        chatMessageType: ChatMessageType.TALK,
        content: message
    );
    chatConn.send(jsonEncode(msg));
    AnalyticsUtil.logEvent('채팅_채팅방_메시지전송', properties: {
      '보낸 사람 성별': widget.user.personalInfo?.gender,
      '보낸 사람 학교 이름': widget.user.university?.name,
      '보낸 사람 학과 이름': widget.user.university?.department
    });
  }

  Future<void> loadMoreMessages() async {
    List<Message> newMessages = await BlocProvider.of<ChattingCubit>(context).fetchMoreMessages(widget.chatRoomDetail.id, page);
    page += 1;
    chatController.loadMoreData(newMessages);
    if (page != 0) {
      AnalyticsUtil.logEvent('채팅_채팅방_이전메시지불러오기(페이지네이션)', properties: {
      '불러온 페이지 인덱스' : page
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(widget.chatRoomDetail.otherTeam.name, style: TextStyle(fontSize: SizeConfig.defaultSize * 1.8),),
      ),

      endDrawerEnableOpenDragGesture: false,
      endDrawer: SafeArea(
        child: Drawer(
          surfaceTintColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("지금 채팅 중인 팀은"),
                        SizedBox(height: SizeConfig.defaultSize * 0.3,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${widget.chatRoomDetail.otherTeam.universityName} ', style: TextStyle(
                              fontSize: SizeConfig.defaultSize * 1.8, fontWeight: FontWeight.w600
                          ),),
                          if (widget.chatRoomDetail.otherTeam.isCertifiedTeam)
                            Image.asset("assets/images/check.png", width: SizeConfig.defaultSize * 1.55),
                        ],
                      ),
                        SizedBox(height: SizeConfig.defaultSize * 1.6,),
                      Text("${(widget.chatRoomDetail.otherTeam.averageAge > 1000 ? 2023-widget.chatRoomDetail.otherTeam.averageAge+1 : widget.chatRoomDetail.otherTeam.averageAge).toStringAsFixed(1)}세"),
                        SizedBox(height: SizeConfig.defaultSize * 0.3,),
                      Text("여기서 만나요! 🤚🏻 ${widget.chatRoomDetail.otherTeam.regions.map((location) => location.name).join(' ')}", style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 1.2
                      ),)
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.8, top: SizeConfig.defaultSize * 2, bottom: SizeConfig.defaultSize * 2),
                child: Text(widget.chatRoomDetail.otherTeam.name, style: TextStyle(
                    fontSize: SizeConfig.defaultSize * 1.5,
                    fontWeight: FontWeight.w600
                ),),
              ),
              for (int i=0; i<widget.chatRoomDetail.otherTeam.teamUsers.length; i++)
                ListTile(
                  onTap: () {
                    var chatOtherTeam = widget.chatRoomDetail.otherTeam;
                    AnalyticsUtil.logEvent('채팅_채팅방_상대팀프로필터치', properties: {
                      '터치한 상대 ID': chatOtherTeam.teamUsers[i].getId(),
                      '터치한 상대 학교': chatOtherTeam.universityName,
                      '터치한 상대 학과': chatOtherTeam.teamUsers[i].getDepartment(),
                      '터치한 상대 프로필 URL': chatOtherTeam.teamUsers[i].getProfileImageUrl(),
                      '터치한 상대 생년': chatOtherTeam.teamUsers[i].getBirthYear()
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatProfile(university: chatOtherTeam.universityName, profile: StudentMapper.toBlindDateUserDetail(chatOtherTeam.teamUsers[i]))));
                  },
                  title: Row(
                    children: [
                      Row(
                        children: [
                          CachedProfileImage(
                            profileUrl: widget.chatRoomDetail.otherTeam.teamUsers[i].getProfileImageUrl(),
                            width: SizeConfig.defaultSize * 3.7,
                            height: SizeConfig.defaultSize * 3.7,
                          ),
                            SizedBox(width: SizeConfig.defaultSize * 1.3),
                          Text(widget.chatRoomDetail.otherTeam.teamUsers[i].getName() == 'DEFAULT' ? '닉네임없음' : widget.chatRoomDetail.otherTeam.teamUsers[i].getName(),
                            style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.5
                          ),),
                        ],
                      ),
                        SizedBox(width: SizeConfig.defaultSize * 3),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(widget.chatRoomDetail.otherTeam.teamUsers[i].getDepartment(), style: TextStyle(
                          fontSize: SizeConfig.defaultSize * 1.2,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.grey
                          ),),
                        ))
                    ],
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.8, top: SizeConfig.defaultSize * 2, bottom: SizeConfig.defaultSize * 2),
                child: Text(widget.chatRoomDetail.myTeam.name, style: TextStyle(
                    fontSize: SizeConfig.defaultSize * 1.5,
                    fontWeight: FontWeight.w600
                ),),
              ),
              for (int i=0; i<widget.chatRoomDetail.myTeam.teamUsers.length; i++)
                ListTile(
                  onTap: () {
                    var chatMyTeam = widget.chatRoomDetail.myTeam;
                    AnalyticsUtil.logEvent('채팅_채팅방_우리팀프로필터치', properties: {
                      '터치한 팀원 ID': chatMyTeam.teamUsers[i].getId(),
                      '터치한 팀원 학교': chatMyTeam.universityName,
                      '터치한 팀원 학과': chatMyTeam.teamUsers[i].getDepartment(),
                      '터치한 팀원 프로필 URL': chatMyTeam.teamUsers[i].getProfileImageUrl(),
                      '터치한 팀원 생년': chatMyTeam.teamUsers[i].getBirthYear()
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatProfile(university: chatMyTeam.universityName, profile: StudentMapper.toBlindDateUserDetail(chatMyTeam.teamUsers[i]))));
                  },
                  title: Row(
                    children: [
                      Row(
                        children: [

                          CachedProfileImage(
                            profileUrl: widget.chatRoomDetail.myTeam.teamUsers[i].getProfileImageUrl(),
                            width: SizeConfig.defaultSize * 3.7,
                            height: SizeConfig.defaultSize * 3.7,
                          ),

                            SizedBox(width: SizeConfig.defaultSize * 1.3),
                          (widget.chatRoomDetail.myTeam.teamUsers[i].getId() == (widget.user.personalInfo?.id ?? 'DEFAULT'))
                          ? Text(widget.chatRoomDetail.myTeam.teamUsers[i].getName() == 'DEFAULT' ? '닉네임없음' : "${widget.chatRoomDetail.myTeam.teamUsers[i].getName()} (나)", style: TextStyle(
                              fontSize: SizeConfig.defaultSize * 1.5
                            ))
                          : Text(widget.chatRoomDetail.myTeam.teamUsers[i].getName() == 'DEFAULT' ? '닉네임없음' : widget.chatRoomDetail.myTeam.teamUsers[i].getName(), style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.5
                          ),),
                        ],
                      ),
                        SizedBox(width: SizeConfig.defaultSize * 3),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(widget.chatRoomDetail.myTeam.teamUsers[i].getDepartment(), style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.2,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.grey
                          ),),
                        ),
                      )
                    ],
                  ),
                ),
              const ListTile(),
              const ListTile(),
              ListTile(
                title: const Text('나가기', style: TextStyle(color: Colors.grey)),
                onTap: () {
                  AnalyticsUtil.logEvent('채팅_채팅방_나가기터치');
                  showDialog(
                    context: context,
                    builder: (BuildContext sheetContext) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        title: Center(child: Text("정말 채팅방을 나가시겠어요?", style: TextStyle(fontSize: SizeConfig.defaultSize * 2, fontWeight: FontWeight.w400),)),
                        content: Text("\n${widget.chatRoomDetail.otherTeam.name} 팀은\n나와 이야기를 더 하고 싶어해요!\n나를 제외한 우리 팀은 계속 채팅을 이어나가고,\n한 번 나가면 다시 채팅방에 들어올 수 없어요.", textAlign: TextAlign.left),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                              AnalyticsUtil.logEvent('채팅_채팅방_나가기_취소');
                            },
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                              Navigator.of(context).pop(); // EndDrawer 닫기
                              Navigator.of(context).pop(); // 채팅방 나가기

                              MessagePub msg = MessagePub(
                                  chatRoomId: widget.chatRoomDetail.id,
                                  senderId: widget.user.personalInfo?.id ?? 0,
                                  chatMessageType: ChatMessageType.QUIT,
                                  content: message
                              );
                              chatConn.send(jsonEncode(msg));

                              setState(() {
                                chatConn.deactivate();
                              });
                              AnalyticsUtil.logEvent('채팅_채팅방_나가기_나가기', properties: {
                                '상대 팀 ID': widget.chatRoomDetail.otherTeam.id,
                                '우리 팀 ID': widget.chatRoomDetail.myTeam.id
                              });
                            },
                            child: const Text('나가기'),
                          )
                        ],
                      );
                  });
                },
              ),
            ],
          ),
        ),
      ),

      body: ChatView(
        currentUser: currentUser,
        chatController: chatController,
        chatViewState: ChatViewState.hasMessages,
        onSendTap: onSendTap,
        loadMoreData: loadMoreMessages,
        loadingWidget: const CircularProgressIndicator(color: Colors.black,),

        featureActiveConfig: const FeatureActiveConfig( // 기본적으로 true로 되어있는 설정 끄기 (답장, 이모지 등)
          enableSwipeToReply: false,
          enableReactionPopup: false,
          enableDoubleTapToLike: false,
          enableReplySnackBar: false,
          enableCurrentUserProfileAvatar: false,
          enableSwipeToSeeTime: true,
          enablePagination: true,
        ),

        sendMessageConfig: SendMessageConfiguration( // 메시지 입력창 설정
          textFieldBackgroundColor: Colors.grey.shade50,
          enableCameraImagePicker: false, // 카메라 제거
          enableGalleryImagePicker: false, // 갤러리 제거,
          allowRecordingVoice: false, // 녹음(음성메시지) 제거
          sendButtonIcon: const Icon(Icons.send_rounded, color: Color(0xffFF5C58),),
          textFieldConfig: TextFieldConfiguration(
            maxLines: 35,
            hintText: "메시지를 입력해주세요",
            textStyle: const TextStyle(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble( // 내가 보낸 채팅
            textStyle: TextStyle(fontSize: SizeConfig.defaultSize * 1.5, color: Colors.white),
            linkPreviewConfig: const LinkPreviewConfiguration(
              backgroundColor: Color(0xff272336),
              bodyStyle: TextStyle(color: Colors.white),
              titleStyle: TextStyle(color: Colors.white),
            ),
            color: const Color(0xffFF5C58),
          ),
          inComingChatBubbleConfig: ChatBubble( // 상대방 채팅
            linkPreviewConfig: const LinkPreviewConfiguration(
              backgroundColor: Color(0xff9f85ff),
              bodyStyle: TextStyle(color: Colors.black),
              titleStyle: TextStyle(color: Colors.black),
            ),
            textStyle: TextStyle(fontSize: SizeConfig.defaultSize * 1.5, color: Colors.black),
            senderNameTextStyle: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultSize * 1.3),
            color: Colors.grey.shade100,
          ),
        ),

        chatBackgroundConfig: const ChatBackgroundConfiguration( // 채팅방 배경
          backgroundImage: "image URL",
          messageTimeIconColor: Colors.grey,
          messageTimeTextStyle: TextStyle(color: Colors.grey),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
          ),
          backgroundColor: Colors.white,
        ),

        // 이모지 선택
        // reactionPopupConfig: ReactionPopupConfiguration(
        //   emojiConfig: const EmojiConfiguration(
        //     emojiList: [
        //       "❤️", "🥰", "👍🏻", "🥺", "💌", "🌟",
        //     ],
        //     size: 24,
        //   ),
        //   glassMorphismConfig: GlassMorphismConfiguration(
        //     backgroundColor: Colors.white,
        //     borderRadius: 14,
        //     borderColor: Colors.white,
        //     strokeWidth: 4,
        //   ),
        //   shadow: BoxShadow(
        //     color: Colors.grey.shade400,
        //     blurRadius: 20,
        //   ),
        //   backgroundColor: Colors.grey.shade200,
        //   // onEmojiTap: (emoji, messageId) =>
        //   //     chatController. setReaction(
        //   //       emoji: emoji,
        //   //       messageId: messageld,
        //   //       userId: currentUser.id,
        //   //     ),
        // ),

        // messageConfig: MessageConfiguration( // 채팅 한 개에 이모지 달아주는 뷰
        //   messageReactionConfig: MessageReactionConfiguration(
        //     backgroundColor: Color(0xff383152),
        //     borderColor: Color(0xff383152),
        //     reactedUserCountTextStyle:
        //     TextStyle(color: Colors.white),
        //     reactionCountTextStyle:
        //     TextStyle(color: Colors.white),
        //     reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
        //       backgroundColor: Color(0xff272336),
        //       reactedUserTextStyle: TextStyle(
        //         color: Colors.white,
        //       ),
        //       reactionWidgetDecoration: BoxDecoration(
        //         color: Color(0xff383152),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.black12,
        //             offset: const Offset(0, 20),
        //             blurRadius: 40,
        //           )
        //         ],
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //   ),
        //   // imageMessageConfig: ImageMessageConfiguration(
        //   //   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        //   //   shareIconConfig: ShareIconConfiguration(
        //   //     defaultIconBackgroundColor: Color(0xff383152),
        //   //     defaultIconColor: Colors.white,
        //   //   ),
        //   // ),
        // ),
      ),
    );
  }

// final currentUser = ChatUser(
//   id: '1',
//   name: '장세연',
//   profilePhoto: 'Profile photo URL',
// );
// final _userTwo = ChatUser(
//   id: '2',
//   name: '성서진',
//   profilePhoto: 'Profile photo URL',
// );
// final _userThree = ChatUser(
//   id: '3',
//   name: '초롱',
//   profilePhoto: 'Profile photo URL',
// );

// MOCKUP DATA
// final chatController = ChatController(
//   initialMessageList: [
//     Message(
//       message: "안녕",
//       createdAt: DateTime.now(),
//       sendBy: '1', // userId of who sends the message
//     ),
//     Message(
//       message: "하세요!",
//       createdAt: DateTime.now(),
//       sendBy: '2',
//     ),
//     Message(
//       message: "채팅채팅",
//       createdAt: DateTime.now(),
//       sendBy: '3',
//     ),
//   ],
//   scrollController: ScrollController(),
//   chatUsers: [
//     ChatUser(
//       id: '2',
//       name: '성서진',
//       profilePhoto: 'https://www.wyzowl.com/wp-content/uploads/2022/04/img_624d8245533d8.jpg',
//     ),
//     ChatUser(
//       id: '3',
//       name: '초롱',
//       profilePhoto: 'https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FEPjzf%2FbtstxQOVRym%2FwTZOsCvGjwnWtU1qaT575k%2Fimg.png',
//     )
//   ],
// );
}
