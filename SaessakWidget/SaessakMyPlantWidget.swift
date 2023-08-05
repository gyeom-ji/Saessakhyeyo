//
//  SaessakMyPlantWidget.swift
//  SaessakWidgetExtension
//
//  Created by 윤겸지 on 2023/08/01.
//

import SwiftUI
import WidgetKit

struct MyPlantProvider: TimelineProvider {
    let widgetModel = WidgetModel.shared
    
    func getSnapshot(in context: Context, completion: @escaping (MyPlantEntry) -> Void) {
        getWidgetData {
            myPlantList  in
            let entry = MyPlantEntry(date: Date(), myPlantList: myPlantList, contextWidth: context.displaySize.width)
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MyPlantEntry>) -> Void) {
        getWidgetData {
            myPlantList  in
            var entries: [MyPlantEntry] = []
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 1 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = MyPlantEntry(date: entryDate, myPlantList: myPlantList, contextWidth: context.displaySize.width)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    func placeholder(in context: Context) -> MyPlantEntry {
        MyPlantEntry(date: Date(), myPlantList: [Myplant](), contextWidth: context.displaySize.width)
    }
    
    func getWidgetData(completion: @escaping ([Myplant]) -> ()) {
        widgetModel.readMyPlantList {
            myPlant in
            for i in 0..<myPlant.count {
                setPhoto(url: myPlant[i].imgUrl)
            }
            completion(myPlant)
        }
    }
    
    private func setPhoto(url: String) {
        let cachedKey = NSString(string: url)
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
           return
        }
        
        guard let url = URL(string: url) else { return }
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                return
            }
        } else {
            ImageCacheManager.shared.setObject(UIImage(named: "saesak_basics")!, forKey: cachedKey)
            return
        }
    }
}

struct MyPlantEntry: TimelineEntry {
    let date: Date
    var myPlantList: [Myplant]
    let contextWidth: CGFloat
}

struct SaessakMyPlantWidgetEntryView : View {
    var entry: MyPlantProvider.Entry
    
    var body: some View {
       LargeWidgetView(entry: entry).background(Color(uiColor: .saessakBeige))
    }
}

struct SaessakMyPlantWidget: Widget {
    let kind: String = "SaessakMyPlantWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MyPlantProvider()) { entry in
            SaessakMyPlantWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("새싹해요")
        .description("내 식물 정보를 간편하게 볼 수 있습니다.")
        .supportedFamilies([.systemLarge])
    }
}

struct SaessakMyPlantWidget_Previews: PreviewProvider {
    static var previews: some View {
        SaessakMyPlantWidgetEntryView(entry: MyPlantEntry(date: Date(), myPlantList: [Myplant](), contextWidth: 300.0))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
