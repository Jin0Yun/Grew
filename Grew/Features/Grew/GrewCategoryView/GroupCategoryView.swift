//
//  GroupCategoryView.swift
//  CircleRecruitment
//
//  Created by 윤진영 on 2023/09/21.
//

import SwiftUI

struct GroupCategoryView: View {
    @EnvironmentObject var viewModel: GrewViewModel
    @Binding var selection: Selection
    @Binding var showSubCategories: Bool
    @Binding var isCategoryValid: Bool
    
    private let gridItems: [GridItem] = [
        .init(.flexible()),
        .init(.flexible()),
        .init(.flexible())
    ]
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("그루의 카테고리를 선택해주세요")
                    .font(.b1_R)
                    .padding(.bottom, 10)
                LazyVGrid(columns: gridItems) {
                    ForEach(viewModel.categoryArray) { category in
                        let isSelected = selection.categoryID == category.id
                        HStack {
                            Button {
                                self.selection.categoryID = category.id
                                self.selection.subCategoryID = nil
                                viewModel.selectedCategoryId = category.id
                                showSubCategories = true
                                isCategoryValid = true
                            } label: {
                                Text(category.name)
                                    .grewButtonModifier(
                                        width: 90,
                                        height: 41,
                                        buttonColor: isSelected ? Color.Sub : Color.BackgroundGray,
                                        font: .b3_B,
                                        fontColor: isSelected ? Color.white : Color.black,
                                        cornerRadius: 22)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                        }
                    }
                }
            }.padding()
        }
    }
}



#Preview {
    GroupCategoryView(selection: .constant(Selection(categoryID: "", subCategoryID: "")), showSubCategories: .constant(true), isCategoryValid: .constant(true))
        .environmentObject(GrewViewModel())
}
