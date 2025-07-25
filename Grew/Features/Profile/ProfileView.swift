//
//  ProfileView.swift
//  Grew
//
//  Created by cha_nyeong on 2023/10/21
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var grewViewModel: GrewViewModel
    @EnvironmentObject private var chatStore: ChatStore
    @EnvironmentObject private var messageStore: MessageStore
    @EnvironmentObject var router: ProfileRouter
    @EnvironmentObject var profileStore: ProfileStore
    @Binding var selection: SelectViews
    
    @State private var isMessageAlert: Bool = false
    @State private var selectedGroup: String = "내 모임"
    @State private var selectedFilter: ProfileThreadFilter = .myGroup
    @State private var isLoading: Bool = false
    
    let user: User?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                headerView()
                
                LazyVStack(pinnedViews: [.sectionHeaders])  {
                    Section {
                        if user == UserStore.shared.currentUser {
                            
                            switch selectedFilter {
                            case .myGroup:
                                MyGroupView(user: user, grews: profileStore.myGrew)
                                    .background(Color.white)
                            case .myGroupSchedule:
                                MyGroupScheduleView(schedules: profileStore.mySchedule)
                                    .background(Color.white)
                            case .savedGrew:
                              
                                SavedGrewView(grewList: grewViewModel.favoritGrew())

                                    .background(Color.white)
                            }
                        } else {
                            MyGroupView(user: user, grews: profileStore.myGrew)
                                .background(Color.white)
                        }
                    } header: {
                        if user == UserStore.shared.currentUser {
                            UserContentListView( selectedFilter: $selectedFilter)
                                .padding(.horizontal, 10)
                        } else {
                            VStack{
                                HStack {
                                    Text("가입한 그루")
                                        .font(.b2_B)
                                    Spacer()
                                }
                                .padding()
                            }
                            .background(Color.white)
                        }
                    }
                }
            }
            .background(Color.white)
            .toolbar {
                if user == UserStore.shared.currentUser {
                    ToolbarItem {
                        Button {
                            router.profileNavigate(to: .setting)
                        } label: {
                            Image(systemName: "gearshape.fill")
                        }
                        .foregroundColor(.black)
                    }
                } else {
                    ToolbarItem {
                        Button {
                            isMessageAlert = true
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundStyle(Color.white)
                        }
                        .foregroundColor(.black)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .coordinateSpace(name: "SCROLL")
            .alert("채팅방 이동", isPresented: $isMessageAlert) {
                Button("취소", role: .cancel) {}
                Button("확인", role: .destructive) {
                    Task {
                        await startMessage()
                        isMessageAlert = false
                        selection = .chat
                    }
                }
            } message: {
                Text("1:1 채팅방으로 이동합니다.")
            }
        }
        .background(alignment: .bottom) {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 475)
                .foregroundStyle(Color.white)
                .ignoresSafeArea()
                .offset(y: 100)
        }
        .background(Color.Main)
        .overlay(
            Group {
                if isLoading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(2)
                        .frame(
                            width: UIScreen.screenWidth,
                            height: UIScreen.screenHeight
                        )
                }
            }
        )
        .navigationBarBackground(.Main)
        .task {
            isLoading = true
            
            if let currentUser = UserStore.shared.currentUser, user == currentUser {
                UserStore.shared.fetchCurrentUser(user!)
                await profileStore.fetchProfileData(user: user)
            } else {
                await profileStore.fetchProfileData(user: user)
            }
            isLoading = false
        }
    }
    @ViewBuilder
    private func headerView() -> some View {
        var backgroundHeight: CGFloat {
            return UIScreen.main.bounds.height / 5
        }
        GeometryReader { proxy in
            
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            ZStack(alignment: .bottom) {
                RoundSpecificCorners()
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    CircleImage()
                    
                    HStack(alignment: .bottom){
                        
                        VStack(alignment: .leading){
                            Text(user?.nickName ?? "테스트")
                                .font(.b1_R)
                            Text(user?.introduce ?? "안녕하세요 \(user?.nickName ?? "테스트")입니다.")
                                .font(.b3_L)
                                .padding(.vertical, 5)
                        }
                        Spacer()
                        
                        NavigationLink {
                            EditProfileView(
                                user: user ?? User.dummyUser
                            )
                        } label: {
                            if user == UserStore.shared.currentUser {
                                Text("프로필 수정")
                                    .font(.c1_B)
                                    .background(RoundedRectangle(cornerRadius: 7)
                                        .foregroundColor(.LightGray2)
                                        .frame(width: 90, height: 28)
                                    )
                            }
                        }
                        .padding(10)
                        .foregroundColor(.white)
                    }.padding(10)
                        .padding(.horizontal, 10)
                    
                    Divider()
                }
                .offset(y: -minY)
            }
            .background(Color.grewMainColor)
        }
        .frame(height: UIScreen.main.bounds.height / 3)
    }
}

#Preview {
    NavigationStack{
        ProfileView(selection: .constant(.profile), user: User.dummyUser)
    }
}


extension ProfileView {
    
    private func startMessage() async {

        let chatRoom = await makeChatRoomForNewRoom()
        await chatStore.addChatRoom(chatRoom)

        let newMessage = ChatMessage(text: "\(user!.nickName) 님과 \(UserStore.shared.currentUser!.nickName)의 대화가 시작되었습니다.", uid: "system", userName: "시스템 메시지", isSystem: true)
        
        messageStore.addMessage(newMessage, chatRoomID: chatRoom.id)
        
    }
    
    private func makeChatRoomForNewRoom() async -> ChatRoom {
        var newChatRoom: ChatRoom = ChatRoom(
            id: UUID().uuidString,
            members: [user!.id!, UserStore.shared.currentUser!.id!],
            createdDate: Date(),
            lastMessage: "\(user!.nickName) 님과 \(UserStore.shared.currentUser!.nickName)의 대화가 시작되었습니다.",
            lastMessageDate: Date(),
            unreadMessageCount: [:])
        return newChatRoom
    }
}
