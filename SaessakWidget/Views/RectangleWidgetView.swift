//
//  RectangleWidgetView.swift
//  SaessakWidgetExtension
//
//  Created by 윤겸지 on 2023/08/01.
//

import SwiftUI
import WidgetKit

struct RectangleWidgetView: View {
    let entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading){
            Group{
                ForEach(0..<(entry.planList.count > 3 ? 3 : entry.planList.count), id:\.self) { index in
                    todoRow(img: entry.planList[index].planType, text: entry.planList[index].myplantName)
                }
            }
        }
    }
    
    func todoRow(img:String, text: String) -> some View {
        
        HStack(alignment: .center){
            VStack {
                Image(systemName: img == "soil" ? "homepodmini.fill" : img == "energy" ? "medical.thermometer" : img == "pruning" ?"scissors" : "homepodmini")
                    .font(Font.system(size: 12))
            }.frame(width: 13)
            VStack {
                Text(text)
                    .font(Font.system(size: 14, weight: Font.Weight.regular))
                    .kerning(0.5)
                    .padding(.leading, -1)
                    .frame(width: entry.contextWidth - 30, alignment: .leading)
            }
            Spacer()
        }
        .padding(.bottom, -2).padding(.leading, 1)
    }
}

struct RectangleWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleWidgetView(entry: Provider.Entry(date: Date(), planList: [Plan(id: 0, date: "2023-08-01", planType: "water", myplantId: 1, myplantName: "첫번째", isDone: false), Plan(id: 0, date: "2023-08-01", planType: "energy", myplantId: 1, myplantName: "두번째", isDone: false), Plan(id: 0, date: "2023-08-01", planType: "pruning", myplantId: 1, myplantName: "세번째", isDone: false), Plan(id: 0, date: "2023-08-01", planType: "soil", myplantId: 1, myplantName: "네번째", isDone: true), Plan(id: 0, date: "2023-08-01", planType: "soil", myplantId: 1, myplantName: "다섯번째", isDone: true)], contextWidth: 155.0))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
