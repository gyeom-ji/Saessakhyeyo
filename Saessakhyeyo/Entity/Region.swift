//
//  City.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/06.
//

import Foundation

struct Region {
    let name: String
    let city: [String]
    let engRegion: String
    let engCity: [String]
}

struct City {
    let region = [
        Region(name: "강원도", city: ["강릉시","고성군","동해시","삼척시","속초시","양구군","양양군","영월군","원주시","인제군","정선군","철원군","춘천시","태백시","평창군","홍천군","화천군","횡성군"],engRegion: "Gangwon-do" ,engCity: ["Gangneung-si","Goseong-gun","Donghae-si","Samcheok-si","Sokcho-si","Yanggu-gun","Yangyang-gun","Yeongwol-gun","Wonju-si","Inje-gun","Jeongseon-gun","Cheorwon-gun","Chuncheon-si","Taebaek-si","Pyeongchang-gun","Hongcheon-gun","Hwacheon-gun","Hoengseong-gun"]),
        Region(name: "경기도", city: ["가평군","고양시","과천시","광명시","광주시","구리시","군포시","김포시","남양주시","동두천시","부천시","성남시","수원시","시흥시","안산시","안성시","안양시","양주시","양평군","여주시","연천군","오산시","용인시","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시","화성시"], engRegion: "Gyeonggi-do" ,engCity: ["Gapyeong-gun","Goyang-si","Gwacheon-si","Gwangmyeong-si","Gwangju","Guri-si","Gunpo-si","Gimpo-si","Namyangju-si","Dongducheon-si","Bucheon-si","Seongnam-si","Suwon-si","Siheung-si","Ansan-si","Anseong-si","Anyang-si","Yangju-si","Yangpyeong-gun","Yeoju-si","Yeoncheon-gun","Osan-si","Yongin-si","Uiwang-si","Uijeongbu-si","Icheon-si","Paju-si","Pyeongtaek-si","Pocheon-si","Hanam-si","Hwaseong-si"]),
        Region(name: "경상남도", city: [
            "거제시","거창군","고성군","김해시","남해군","밀양시","사천시","산청군","양산시","의령군","진주시","창녕군","창원시","통영시","하동군","함안군","합천군"
        ], engRegion: "Gyeongsangnam-do", engCity: [
            "Geoje-si","Geochang-gun","Goseong-gun","Gimhae-si","Namhae-gun","Miryang-si","Sacheon-si","Sancheong-gun","Yangsan-si","Uiryeong-gun","Jinju-si","Changnyeong-gun","Changwon-si","Tongyeong-si","Hadong-gun","Haman-gun","Hapcheon-gun"
        ]),
        Region(name: "경상북도", city: [
            "경산시","경주시","고령군","구미시","군위군","김천시","문경시","봉화군","상주시","성주군","안동시","영덕군","영양군","영주시","영천시","예천군","울릉군","울진군","의성군","청도군","청송군","칠곡군","포항시"
        ],engRegion: "Gyeongsangbuk-do", engCity: ["Gyeongsan-si","Gyeongju-si","Goryeong-gun","Gumi-si","Gunwi-gun","Gimcheon-si","Mungyeong-si","Bonghwa-gun","Sangju-si","Seongju-gun","Andong-si","Yeongdeok-gun","Yeongyang-gun","Yeongju-si","Yeongcheon-si","Yecheon-gun","Ulleung-gun","Uljin-gun","Uiseong-gun","Cheongdo-gun","Cheongsong-gun","Chilgok-gun","Pohang-si"]),
        Region(name: "광주광역시", city:[""],engRegion: "Gwangju!", engCity: ["Gwangju!"]),
        Region(name: "대구광역시", city:[""], engRegion: "Daegu", engCity: ["Daegu"]),
        Region(name: "대전광역시", city:[""], engRegion: "Daejeon", engCity: ["Daejeon"]),
        Region(name: "부산광역시", city:[""], engRegion: "Busan", engCity: ["Busan"]),
        Region(name: "서울특별시", city:[""],engRegion: "Seoul", engCity: ["Seoul"]),
        Region(name: "세종특별자치시", city:[""],engRegion: "Sejong", engCity: ["Sejong"]),
        Region(name: "울산광역시", city:[""],engRegion: "Ulsan", engCity: ["Ulsan"]),
        Region(name: "인천광역시", city:[""],engRegion: "Incheon", engCity: ["Incheon"]),
        Region(name: "전라남도", city:[
            "강진군","고흥군","곡성군","광양시","구례군","나주시","담양군","목포시","무안군","보성군","순천시","신안군","여수시","영광군","완도군","장성군","장흥군","진도군","함평군","해남군","화순군"],engRegion: "Jeollanam-do", engCity:["Gangjin-gun","Goheung-gun","Gokseong-gun","Gwangyang-si","Gurye-gun","Naju-si","Damyang-gun","Mokpo-si","Muan-gun","Boseong-gun","Suncheon-si","Shinan-gun","Yeosu-si","Yeonggwang-gun","Wando-gun","Jangseong-gun","Jangheung-gun","Jindo-gun","Hampyeong-gun","Haenam-gun","Hwasun-gun"] ),
        Region(name: "전라북도", city: [
            "고창군","군산시","김제시","남원시","무주군","부안군","순창군","완주군","익산시","임실군","장수군","전주시","정읍시","진안군"],engRegion: "jeollabuk-do", engCity: ["Gochang-gun","Gunsan-si","Gimje-si","Namwon-si","Muju-gun","Buan-gun","Sunchang-gun","Wanju-gun","Iksan-si","Imsil-gun","Jangsu-gun","Jeonju-si","Jeongeup-si","Jinan-gun"]),
        Region(name: "제주도", city: ["서귀포시","제주시"],engRegion: "Jeju-do", engCity: ["Seogwipo-si","Jeju-si"]),
        Region(name: "충청남도", city: [
            "계룡시","공주시","금산군","논산시","당진시","보령시","부여군","서산시","서천군","아산시","예산군","천안시","청양군","태안군","홍성군"],engRegion: "Chungcheongnam-do", engCity: ["Gyeryong-si","Gongju-si","Geumsan-gun","Nonsan-si","Dangjin-si","Boryeong-si","Buyeo-gun","Seosan-si","Seocheon-gu","Asan-si","Yesan-gun","Cheonan-si","Cheongyang-gun","Taean-gun","Hongseong-gun"]),
        Region(name: "충청북도", city: [
            "괴산군","단양군","보은군","영동군","옥천군","음성군","제천시","증평군","진천군","청주시","충주시"],engRegion: "Chungcheongbuk-do", engCity:  ["Goesan-gun","Danyang-gun","Boeun-gun","Yeongdong-gun","Okcheon-gun","Eumseong-gun","Jecheon-si","Jeungpyeong-gun","Jincheon-gun","Cheongju-si","Chungju-si"]
)
    ]
}
