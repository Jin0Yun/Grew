//
//  ScheduleCellView.swift
//  Grew
//
//  Created by KangHo Kim on 2023/10/13.
//

import SwiftUI

struct ScheduleCellView: View {
    let index: Int
    let schedule: Schedule
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("# \(index + 1)")
                    .font(.b1_B)
                    .padding()
                    .foregroundColor(.white)
            }
            .frame(height: 40)
            .background(Color(hexCode: schedule.color))
            CircleImage()
                .offset(x: -38, y: -32)
                .padding(.bottom, -32)
            HStack {
                VStack(alignment: .leading) {
                    Text("제목")
                        .padding(.vertical, 1)
                    Text("날짜")
                        .padding(.vertical, 1)
                    Text("인원")
                        .padding(.vertical, 1)
                }
                .font(.c1_R)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(schedule.scheduleName)")
                        .padding(.vertical, 1)
                    Text("\(schedule.grewCellDateString)")
                        .padding(.vertical, 1)
                    Text("\(schedule.participants.count)/\(schedule.maximumMember)")
                        .padding(.vertical, 1)
                }
                .font(.c1_B)
            }
            .foregroundStyle(.black)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
        }
        .background(Color.white)
        .cornerRadius(6)
        .frame(width: 160, height: 160)
        .shadow(radius: 3)
    }
}

#Preview {
    ScheduleCellView(index: 0, schedule: Schedule(id: "", gid: "", scheduleName: "", date: Date(), maximumMember: 0, participants: [], fee: "", location: "", latitude: "", longitude: "", color: ""))
}
