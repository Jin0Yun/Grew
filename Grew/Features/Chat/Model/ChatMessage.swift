//
//  ChatMessage.swift
//  ChattingModule
//
//  Created by cha_nyeong on 2023/09/26.
//


import FirebaseFirestoreSwift
import Foundation

struct ChatMessage: Identifiable, Codable {
    /// 채팅 생성 ID
    var id: String = UUID().uuidString
    /// 채팅 내용
    var text: String
    /// 작성자
    let uid: String
    /// 작성일, 시간
    var createdDate: Date = Date()
    /// 채팅방 ID
    var groupId: String?
    /// 사용자 이름
    var userName: String
    /// 사용자 프로필 사진
    var profileImageURL: String = ""
    /// 사진 첨부(사진 보내기)
    var attachImageURL: String = ""
    /// 시스템 메시지 여부
    var isSystem: Bool = false
}

/// 연산 프로퍼티
extension ChatMessage {
    var displayProfilePhotoURL: URL? {
        profileImageURL.isEmpty ? nil: URL(string: profileImageURL)
    }
    var displayAttachmentPhotoURL: URL? {
        attachImageURL.isEmpty ? nil: URL(string: attachImageURL)
    }
    
    var createdDateString: String {
        DateService.shared.lastMessageFormat(createdDate)
    }
}

/// dummy
extension ChatMessage {
    static let dummyChat = ChatMessage(text: "2023년 4월 4일", uid: "uid123", userName: "이름", profileImageURL: "https://firebasestorage.googleapis.com:443/v0/b/chattest-938f0.appspot.com/o/photos%2FPwqtVpH3GgdyvOCRJ0WIyOzk06O2.png?alt=media&token=799b7831-09fb-4952-b7a2-37736161025a")
    static let dummyChat1 = ChatMessage(text: "안녕하세요", uid: "uid123", userName: "이름", profileImageURL: "https://firebasestorage.googleapis.com:443/v0/b/chattest-938f0.appspot.com/o/photos%2FPwqtVpH3GgdyvOCRJ0WIyOzk06O2.png?alt=media&token=799b7831-09fb-4952-b7a2-37736161025a")
    static let dummyChat2 = ChatMessage(text: "넹", uid: "uid123", userName: "이름", profileImageURL: "https://firebasestorage.googleapis.com:443/v0/b/chattest-938f0.appspot.com/o/photos%2FPwqtVpH3GgdyvOCRJ0WIyOzk06O2.png?alt=media&token=799b7831-09fb-4952-b7a2-37736161025a")
    static let dummyChat3 = ChatMessage(text: "감자님이 들어오셨습니다.", uid: "uid123", userName: "이름", profileImageURL: "https://firebasestorage.googleapis.com:443/v0/b/chattest-938f0.appspot.com/o/photos%2FPwqtVpH3GgdyvOCRJ0WIyOzk06O2.png?alt=media&token=799b7831-09fb-4952-b7a2-37736161025a")
    static let dummyChat4 = ChatMessage(text: "안녕하세요", uid: "uid123", userName: "이름", profileImageURL: "https://firebasestorage.googleapis.com:443/v0/b/chattest-938f0.appspot.com/o/photos%2FPwqtVpH3GgdyvOCRJ0WIyOzk06O2.png?alt=media&token=799b7831-09fb-4952-b7a2-37736161025a")
}
