//
//  SmallWidgetView.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/08/01.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    let entry: Provider.Entry
    
    var body: some View {
        HStack{
            Spacer()
            VStack{
                Image("todayPlanLogo")
                    .resizable()
                    .frame(width: 70, height: 25)
                    .padding(.top, 2)
                
                Image("bar")
                    .resizable()
                    .frame(width: entry.contextWidth - 15, height: 8)
                    .padding(.top, -8)
                
                Group{
                    ForEach(0..<(entry.planList.count > 4 ? 4 : entry.planList.count), id:\.self) { index in

                        todoRow(img: entry.planList[index].planType, text: entry.planList[index].myplantName)
                    }

                    Spacer()
                }.padding([.horizontal], 3)
            }
            Spacer()
        }
    }
    
    func todoRow(img:String, text: String) -> some View {
        
        HStack(alignment: .center){
            Image(img)
                .resizable()
                .frame(width: 17, height: 17)
            
            Text(text)
                .font(Font.system(size: 12))
                .kerning(0.5)
                .foregroundColor(Color(uiColor: .darkGray))
            
            Spacer()
        }
    }
}

struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView(entry: Provider.Entry(date: Date(), planList: [Plan(id: 0, date: "2023-08-01", planType: "water", myplantId: 1, myplantName: "첫번째", isDone: false), Plan(id: 0, date: "2023-08-01", planType: "energy", myplantId: 1, myplantName: "두번째", isDone: false), Plan(id: 0, date: "2023-08-01", planType: "pruning", myplantId: 1, myplantName: "세번째", isDone: false), Plan(id: 0, date: "2023-08-01", planType: "soil", myplantId: 1, myplantName: "네번째", isDone: true), Plan(id: 0, date: "2023-08-01", planType: "soil", myplantId: 1, myplantName: "다섯번째", isDone: true)], contextWidth: 155.0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
