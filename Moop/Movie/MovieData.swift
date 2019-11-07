//
//  MovieData.swift
//  Moop
//
//  Created by kor45cw on 2019/10/12.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

class MovieData {
    var items: [MovieInfo] = []
    var filteredMovies: [MovieInfo] = []
    var searchedMovies: [MovieInfo] = []
    
    enum SortType {
        case rank
        case day
    }
}

extension MovieData {
    func update(items: [MovieInfo], sortType: SortType) {
        switch sortType {
        case .rank:
            self.items = items.sorted(by: { $0.rank < $1.rank })
        case .day:
            self.items = items.sorted(by: { $0.getDay < $1.getDay })
        }
    }
    
    func search(query: String) {
        self.searchedMovies = filteredMovies.filter({ $0.title.contains(query) })
    }
    
    func filter() {
        let theaters = UserDefaults.standard.object([TheaterType].self, forKey: .theater) ?? TheaterType.allCases
        let ages = UserDefaults.standard.object([AgeType].self, forKey: .age) ?? AgeType.allCases
        self.filteredMovies = items
            .filter { $0.contain(types: theaters) }
            .filter { $0.contain(ages: ages) }
    }
}
