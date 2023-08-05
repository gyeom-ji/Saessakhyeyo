//
//  LargeWidgetView.swift
//  SaessakWidgetExtension
//
//  Created by 윤겸지 on 2023/08/01.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
    let entry: MyPlantProvider.Entry
    
    var body: some View {
        HStack{
            Spacer()
            VStack {
                Image("plantListLogo")
                    .resizable()
                    .frame(width: 90, height: 35)
                    .padding(.top, 5)
                
                Image("bar")
                    .resizable()
                    .frame(width: entry.contextWidth - 15, height: 8)
                    .padding(.top, -8)
                    .padding(.bottom, 5)
                
                Group {
                    ForEach(0..<entry.myPlantList.count, id: \.self) { index in
                        myPlantRow(img: ImageCacheManager.shared.object(forKey: entry.myPlantList[index].imgUrl as NSString)!, plantNickName: entry.myPlantList[index].nickname, dday: entry.myPlantList[index].dday ?? "", weatherIcon: entry.myPlantList[index].icon, weatherRec: entry.myPlantList[index].recommendStr).padding(.bottom, 10)
                    }
                }.padding(.horizontal, 10)
                Spacer()
            }
            Spacer()
        }
    }
    
    func myPlantRow(img:UIImage, plantNickName: String, dday: String, weatherIcon: String, weatherRec: String) -> some View {
        
        HStack(alignment: .center){
           
            Image(uiImage: img)
                .resizable()
                .cornerRadius(20)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading){
  
                Text(plantNickName)
                    .font(Font.system(size: 12, weight: Font.Weight.regular))
                    .kerning(0.5)
                    .foregroundColor(Color(uiColor: .darkGray))

                HStack{
                    
                    Image(weatherIcon)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.trailing, -5)
                    
                    Text(weatherRec)
                        .font(Font.system(size: 11))
                        .kerning(0.5)
                        .foregroundColor(Color(uiColor: .darkGray))
                }.padding(.top, -5)
            }
            
            Spacer()
            
            Text(dday)
                .font(Font.system(size: 12))
                .kerning(0.5)
                .foregroundColor(Color(uiColor: .darkGray))
                .frame(width: 40, alignment: .leading)
        }
    }
}

struct LargeWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidgetView(entry: MyPlantEntry(date: Date(), myPlantList: [Myplant(id: 1, userId: 1, nickname: "겸식이", species: "네펜데스", sunCondition: 1, windCondition: 1, waterCondition: 1, waterCycle: 1, imgUrl: "http://www.nongsaro.go.kr/cms_contents/301/12901_MF_REPR_ATTACH_01.jpg", isActive: true, tempDate: "", icon: "", recommendStr: "해가 쨍쨍", plantRegionEng: "Daegu", dday: "D-Day")], contextWidth: 320))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
