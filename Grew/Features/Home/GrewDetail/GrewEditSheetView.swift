//
//  GrewEditSheetView.swift
//  Grew
//
//  Created by KangHo Kim on 2023/10/22.
//

import SwiftUI

struct GrewEditSheetView: View {
    @EnvironmentObject private var grewViewModel: GrewViewModel
    @EnvironmentObject private var userViewModel: UserStore
    @EnvironmentObject private var chatStore: ChatStore
    @EnvironmentObject private var messageStore: MessageStore
    @EnvironmentObject private var scheduleStore: ScheduleStore
    
    @State private var isGrewRemoveAlert: Bool = false
    @Binding var isShowingWithdrawConfirmAlert: Bool
    @Binding var isGrewRemoved: Bool
    
    let grew: Grew
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    VStack {
                        if grew.hostID == UserStore.shared.currentUser?.id ?? "" {
                            NavigationLink(destination: {
                                GrewEditView()
                            }, label: {
                                HStack {
                                    Text("그루 수정")
                                    Spacer()
                                    Image(systemName: "pencil")
                                }
                            })
                            .padding(.vertical, 8)
                            .foregroundStyle(Color.Black)
                            Divider()
                            Button {
                                
                            } label: {
                                Text("그루트 관리")
                                Spacer()
                                Image(systemName: "pencil")
                            }
                            .padding(.vertical, 8)
                            .foregroundStyle(Color.Black)
                            Divider()
                            Button {
                                isGrewRemoveAlert = true
                            } label: {
                                Text("그루 해체하기")
                                Spacer()
                                Image(systemName: "trash")
                            }
                            .padding(.vertical, 8)
                            .foregroundStyle(Color.Error)
                            Divider()
                            Button {
                                grewViewModel.showingSheet = false
                            } label: {
                                Text("닫기")
                                Spacer()
                                Image(systemName: "xmark")
                            }
                            .padding(.vertical, 8)
                            .foregroundStyle(Color.Error)
                        } else {
                            if let userId = UserStore.shared.currentUser?.id, grew.currentMembers.contains(userId) {
                                Button {
                                    Task {
                                        await exitChatRoom()
                                    }
                                    grewViewModel.showingSheet = false
                                    isShowingWithdrawConfirmAlert = true
                                } label: {
                                    Text("탈퇴하기")
                                    Spacer()
                                    Image(systemName: "trash")
                                }
                                .padding(.vertical, 8)
                                .foregroundStyle(Color.Error)
                                Divider()
                            }
                            Button {
                                grewViewModel.showingSheet = false
                            } label: {
                                Text("닫기")
                                Spacer()
                                Image(systemName: "xmark")
                            }
                            .padding(.vertical, 8)
                            .foregroundStyle(Color.Error)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 30)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .font(.b2_R)
            }.ignoresSafeArea(.all)
        }
        .grewAlert(
            isPresented: $isGrewRemoveAlert,
            title: "정말 해체하시겠습니까?\n해체하면 복구할 수 없습니다.",
            secondButtonTitle: "취소",
            secondButtonColor: .DarkGray1,
            secondButtonAction: { },
            buttonTitle: "해체하기",
            buttonColor: .Error,
            action: {
                Task {
                    await removeChatRoom()
                    await removeGrew()
                }
                grewViewModel.showingSheet = false
            }
        )
    }
}

#Preview {
    GrewEditSheetView(isShowingWithdrawConfirmAlert: .constant(false), isGrewRemoved: .constant(false), grew: Grew(
        id: "id",
        categoryIndex: "게임/오락",
        categorysubIndex: "보드게임",
        title: "멋쟁이 보드게임",
        description: "안녕하세요!\n보드게임을 잘 해야 한다 ❌\n보드게임을 좋아한다 🅾️ \n\n즐겁게 보드게임을 함께 할 친구들이 필요하다면,\n<멋쟁이 보드게임> 그루에 참여하세요!\n\n매주 수요일마다 모이는 정기 모임과\n자유롭게 모이는 번개 모임을 통해\n많은 즐거운 추억을 쌓을 수 있어요 ☺️\n\n",
        imageURL: "https://images.unsplash.com/photo-1696757020926-d627b01c41cc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHx8&auto=format&fit=crop&w=900&q=60",
        isOnline: false,
        location: "서울",
        gender: .any,
        minimumAge: 20,
        maximumAge: 40,
        maximumMembers: 8,
        currentMembers: ["id1", "id2"],
        isNeedFee: false,
        fee: 0
    )
    )
    .environmentObject(UserViewModel())
}

extension GrewEditSheetView {
    private func exitChatRoom() async {
        guard let user = UserStore.shared.currentUser else {
            return
        }
        
        if let chatRoom = await ChatStore.getChatRoomFromGID(gid: grew.id) {
            var newChatRoom = chatRoom
            let newMember = chatRoom.members.filter { $0 != user.id! }
            var newUnreadMessageCountDict: [String: Int] = await chatStore.getUnreadMessageDictionary(chatRoomID: chatRoom.id) ?? [:]
            
            for userID in chatRoom.otherUserIDs {
                newUnreadMessageCountDict[userID, default: 0] += 1
            }
            
            newUnreadMessageCountDict[user.id!] = 0
            
            let newMessage = ChatMessage(text: "\(user.nickName)님이 퇴장하셨습니다.", uid: "system", userName: "시스템 메시지", isSystem: true)
            
            messageStore.addMessage(newMessage, chatRoomID: chatRoom.id)
            
            newChatRoom.members = newMember
            newChatRoom.lastMessage =  "\(user.nickName)님이 퇴장하셨습니다."
            newChatRoom.lastMessageDate = .now
            newChatRoom.unreadMessageCount = newUnreadMessageCountDict
            
            await chatStore.updateChatRoomForExit(newChatRoom)
        }
    }
    
    private func removeChatRoom() async {
        guard UserStore.shared.currentUser != nil else {
            return
        }
        
        if let chatRoom = await ChatStore.getChatRoomFromGID(gid: grew.id) {
            await chatStore.removeChatRoom(chatRoom)
        }
    }
    
    private func removeGrew() async {
        do {
            await scheduleStore.removeSchedule(gid: grew.id)
            await grewViewModel.removeGrew(gid: grew.id)
            isGrewRemoved = true
        }
    }
}
