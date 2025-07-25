//
//  SavedGrewView.swift
//  Grew
//
//  Created by daye on 2023/10/21.
//

import SwiftUI

struct SavedGrewView: View {

    let grewList: [Grew]
    
    var body: some View {
        
        if grewList.isEmpty {
            ProfileGrewDataEmptyView(systemImage: "heart", message: "그루를 찜해보세요!", isSavedView: true)
            
        } else {
            VStack {
                ForEach(0 ..< grewList.count, id: \.self) { index in
                    if let grew = grewList[safe: index] {
                        NavigationLink {
                            GrewDetailView(grew: grew)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            
                            GrewCellView(grew: grew)
                                .padding(.trailing, 16)
                                .padding(.bottom, 5)
                                .foregroundColor(.black)
                        }
                    }
                }
            }.padding(.top, 5)
        }
    }
}
