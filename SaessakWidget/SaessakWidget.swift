//
//  SaessakWidget.swift
//  SaessakWidget
//
//  Created by 윤겸지 on 2023/07/31.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let widgetModel = WidgetModel.shared
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        
        getWidgetData {
            value in
            let entry = SimpleEntry(date: Date(), planList: value, contextWidth: context.displaySize.width)
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
       
        getWidgetData {
            value in
            var entries: [SimpleEntry] = []
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 1 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate,planList: value, contextWidth: context.displaySize.width)
                entries.append(entry)
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), planList: [Plan](), contextWidth: context.displaySize.width)
    }
    
    func getWidgetData(completion: @escaping ([Plan]) -> ()) {
        widgetModel.readPlanList {
            plan in
            completion(plan)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var planList: [Plan]
    let contextWidth: CGFloat
}

struct SaessakWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch self.family {
        case .systemSmall:
            SmallWidgetView(entry: entry).background(Color(uiColor: .saessakBeige))
        case .accessoryRectangular:
            RectangleWidgetView(entry: entry)
        default:
            Text("SaessakWidget")
        }
    }
}

struct SaessakWidget: Widget {
    let kind: String = "SaessakWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SaessakWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("새싹해요")
        .description("오늘 할일을 볼 수 있습니다.")
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}

struct SaessakWidget_Previews: PreviewProvider {
    static var previews: some View {
        SaessakWidgetEntryView(entry: SimpleEntry(date: Date(), planList: [Plan](), contextWidth: 155.0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        SaessakWidgetEntryView(entry: SimpleEntry(date: Date(), planList: [Plan](), contextWidth: 155.0))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
