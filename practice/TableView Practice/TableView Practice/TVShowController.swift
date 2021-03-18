//
//  TVShowController.swift
//  TableView Practice
//
//  Created by Ryan Bitner on 3/11/21.
//

import Foundation

struct TVShowController {
    static let shared = TVShowController()
    
    var shows: [TVShow] = [
        TVShow(watchedAt: Date(), title: "Agents of Sheild", description: "Marvel awesomeness"),
        TVShow(watchedAt: Date(), title: "Demon Slayer", description: "Slayin Demons adflajfl;adsfl fajd fjdfljasdf;k jdfajsdfl;jadflj dslfjalsdfj dlfjdl fjadl;fjasldfj ladfal d;jfldjfl;jdf;ladjs;jadflsd"),
        TVShow(watchedAt: Date(), title: "Wadavision", description: "Scarlet Witch awesomeness")
    ]

}
