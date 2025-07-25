//
//  Grew.swift
//  CircleRecruitment
//
//  Created by KangHo Kim on 2023/09/21.
//

import Foundation
import GeoFire

struct Grew: Identifiable, Codable, Hashable {
    
    var id: String = UUID().uuidString
    var hostID: String = "\(UserStore.shared.currentUser?.id ?? "hostID Input Error")"
    /// 1차 카테고리
    let categoryIndex: String
    /// 2차 카테고리
    let categorysubIndex: String
    /// 모임 이름
    var title: String
    /// 모임 설명
    var description: String = ""
    /// 모임 썸네일 이미지
    var imageURL: String = "https://firebasestorage.googleapis.com:443/v0/b/forrest-grew.appspot.com/o/AA5308C2-48F0-4FD0-8ABF-D06D646C9C18.jpg?alt=media&token=dca6e51f-a5e4-4acb-bdb8-fe4a9960c44d"
    /// 온라인, 오프라인 여부
    var isOnline: Bool
    /// 오프라인 주소
    var location: String = ""
    /// 위도
    var latitude: String = ""
    /// 경도
    var longitude: String = ""
    /// geohash
    var geoHash: String = ""
    /// 활동 지역 (ex: 구로구, 수원시)
    var district: String {
        let locationArray = location.split(separator: " ")
        if locationArray.count > 1 {
            return String(locationArray[1])
        } else if isOnline == true {
            return "온라인"
        } else {
            return "장소 미정"
        }
    }
    /// 멤버 성별
    var gender: Gender
    /// 멤버 최소 나이
    var minimumAge: Int
    /// 멤버 최대 나이
    var maximumAge: Int
    /// 최대 인원 수
    var maximumMembers: Int
    /// 멤버
    var currentMembers: [String] = ["\(UserStore.shared.currentUser?.id ?? "hostID Input Error")"]
    /// 활동비 여부
    var isNeedFee: Bool
    /// 활동비
    var fee: Int = 0
    /// 모임 생성 시간
    var createdAt: Date = Date()
    /// 모임 생성 시간 String 값 변환
    var createdAtString: String {
        DateService.shared.grewFormat(createdAt)
    }
    /// 사용자id : bool 처리
    var heartUserDictionary: [String: Bool]?
    /// 좋아요 눌린 횟수
    var heartTapped: Int {
        var count = 0
        if let heartUserDictionary {
            for dict in heartUserDictionary {
                if dict.value {
                    count += 1
                }
            }
        }
        return count
    }
    /// 좋아요
    var heartCount: Int = 0

    var indexForCategory: GrewMainCategory {
        switch self.categoryIndex {
        case "100":
            return .artsAndCulture
        case "200":
            return .activity
        case "300":
            return .travel
        case "400":
            return .cookingAndCrafting
        case "500":
            return .foodAndDrinking
        case "600":
            return .gamingAndEntertainment
        case "700":
            return .musicAndInstruments
        case "800":
            return .carAndMotorcycle
        case "900":
            return .photographyAndVideo
        case "1000":
            return .neighborhoodAndSocial
        case "1100":
            return .study
        case "1200":
            return .languages
        default:
            fatalError("Can't find category")
        }
    }
}

extension Grew {
    static var defaultGrew: Grew {
        return Grew(
            categoryIndex: "100",
            categorysubIndex: "1100",
            title: "",
            description: "",
            imageURL: "",
            isOnline: true,
            location: "",
            gender: .any, minimumAge: 12, maximumAge: 20, maximumMembers: 10, currentMembers: [], isNeedFee: false, fee: 0)
    }
}
