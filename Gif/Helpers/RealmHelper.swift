//
//  RealmHelper.swift
//  Gif
//
//  Created by Liya Wu-17 on 7/20/16.
//  Copyright © 2016 ms. All rights reserved.
//

import RealmSwift

class RealmHelper {
    
    static func addVideo(video: Video) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(video)
        }
    }
    
    static func deleteVideo(video: Video) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(video)
        }
    }
    
    static func retrieveVideo() -> Results<Video> {
        let realm = try! Realm()
        return realm.objects(Video).sorted("modificationTime", ascending: false)
    }
}