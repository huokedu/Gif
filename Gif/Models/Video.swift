//
//  Video.swift
//  Gif
//
//  Created by Liya Wu-17 on 7/20/16.
//  Copyright © 2016 ms. All rights reserved.
//

import Foundation
import RealmSwift

class Video: Object {
    dynamic var title = ""
    dynamic var content = ""
    dynamic var modificationTime = NSDate()
}