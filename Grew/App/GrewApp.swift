//
//  GrewApp.swift
//  Grew
//
//  Created by cha_nyeong on 10/4/23.
//
import FacebookCore
import FBSDKCoreKit
import FirebaseCore
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

@main
struct GrewApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var userStore = UserStore()
    @StateObject private var chatStore = ChatStore()
    @StateObject private var messageStore = MessageStore()
    @StateObject private var grewViewModel = GrewViewModel()
    @StateObject private var appState = AppState()
    @StateObject private var stumpStore = StumpStore()
    @StateObject private var mapStore = MapStore()
    @StateObject private var scheduleStore = ScheduleStore()
    @StateObject private var profileStore = ProfileStore()
    @StateObject private var userViewModel = UserViewModel()
    
    /// 카카오 로그인 키 값
    init() {
        KakaoSDK.initSDK(appKey: "93a5453be087d1c02859e56e80132f73")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LaunchView()
            }
            .environmentObject(userStore)
            .environmentObject(chatStore)
            .environmentObject(messageStore)
            .environmentObject(grewViewModel)
            .environmentObject(appState)
            .environmentObject(stumpStore)
            .environmentObject(mapStore)
            .environmentObject(scheduleStore)
            .environmentObject(profileStore)
            .environmentObject(userViewModel)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
  
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}
