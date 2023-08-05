//
//  WidgetModel.swift
//  SaessakWidgetExtension
//
//  Created by 윤겸지 on 2023/08/01.
//

import Foundation

class WidgetModel {
    
    static let shared = WidgetModel()
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_kr")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }()
    
    private init(){}
    
    var dateFormat: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        return dateFormat
    }
    
    func readPlanList(completion: @escaping ([Plan]) -> ())
    {
        let dateString = dateFormat.string(from: Date())
        
        guard let url = URL(string: APIConstrants.baseURL + "/plan/\(dateString)/user=\(userId)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            // 에러검사
            guard error == nil else {
                print("Error occur: error calling GET - \(String(describing: error))")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: readPlanList HTTP request failed")
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode([Plan].self, from: data) else {
                print("Error: readPlanList JSON parsing failed")
                return
            }
            var tempPlanList = [Plan]()
            for i in 0..<decodedData.count {
                if !decodedData[i].isDone{
                    tempPlanList.append(decodedData[i])
                }
            }
            
            completion(tempPlanList)
        }
        dataTask.resume()
    }
    
    func readMyPlantList(completion: @escaping ([Myplant]) -> ())
    {
        guard let url = URL(string: APIConstrants.baseURL + "/my-plant/\(userId)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request) { [self] (data, response, error) in
            // 에러검사
            guard error == nil else {
                print("Error occur: error calling GET - \(String(describing: error))")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: readMyPlantList HTTP request failed")
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode([Myplant].self, from: data) else {
                print("Error: readMyPlantList JSON parsing failed")
                return
            }
            
            var tempPlantList = [Myplant]()
            
            for i in 0..<decodedData.count {
                if decodedData[i].isActive && tempPlantList.count < 6{
                    var tempPlant = Myplant()
                    tempPlant = decodedData[i]
                    tempPlant.dday = self.setDday(date: tempPlant.tempDate, waterCycle: tempPlant.waterCycle)
                    tempPlant.recommendStr = tempPlant.recommendStr.components(separatedBy: "\n")[1]
                    tempPlant.icon = setIcon(icon: tempPlant.icon)
                    
                    tempPlantList.append(tempPlant)
                }
            }
            completion(tempPlantList)
        }
        dataTask.resume()
    }
    
    func setIcon(icon: String) -> String {
        return icon.contains("01") ? "sun" :
        icon.contains("02") ? "suncloud" :
        icon.contains("03") ? "cloud" :
        icon.contains("04") ? "cloud" :
        icon.contains("09") ? "rain" :
        icon.contains("10") ? "rain" :
        icon.contains("11") ? "thundercloud" :
        icon.contains("13") ? "snow" : "fog"
    }
    
    func setDday(date: String, waterCycle: Int) -> String{
        let latestWaterStr = date
      
        
        let latestWater = dateFormatter.date(from: latestWaterStr)
        
        let waterDate = Calendar.current.date(byAdding: .day, value: waterCycle, to: latestWater!)

        let offsetComps = Calendar.current.dateComponents([.day], from: Date(), to: waterDate!).day

        let today = dateFormatter.string(from: Date())
        let waterday = dateFormatter.string(from: waterDate!)

        if today == waterday{
           return "D-Day"
        }
        else if offsetComps! < 0 {
            return "D-Day"
        }
        else if offsetComps == 0 {
            return "D-1"
        }
        else{
            return "D-\(offsetComps! + 1)"
        }
    }
}
