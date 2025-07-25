//
//  AppState.swift
//  ChattingModule
//
//  Created by cha_nyeong on 2023/09/26.
//

import Foundation
import SwiftUI
 
/// 로딩 상태 열거형
enum LoadingState: Hashable, Identifiable {
    case idle
    case loading(String)
    
    var id: Self {
        return self
    }
}

/// 라우팅 처리 (탭 뷰 처리)
enum Route: Hashable {
    case initial
    case login
    case signUp
    case main
}
/// 현재 앱 상태 로딩 여부 값
class AppState: ObservableObject {
    @Published var loadingState: LoadingState = .idle
    @Published var routes: [Route] = []
}

class HomeRouter: ObservableObject {
    enum HomeRoute: Hashable {
        case category(category: GrewCategory)
        case grewDetail(grew: Grew)
        case search
    }
    
    @Published var homePath = NavigationPath()
    
    func reset() {
        homePath.removeLast(homePath.count)
    }
    
    func homeNavigate(to route: HomeRoute) {
        homePath.append(route)
    }
}

class ProfileRouter: ObservableObject {
    enum ProfileRoute: Hashable {
        case banner
        case setting
    }
    
    @Published var profilePath = NavigationPath()
    
    func reset() {
        profilePath.removeLast(profilePath.count)
    }
    
    func profileNavigate(to route: ProfileRoute) {
        profilePath.append(route)
    }
}
