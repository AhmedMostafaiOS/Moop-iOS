//
//  FutureMovieData.swift
//  Moop
//
//  Created by kor45cw on 08/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

class FutureMovieData {
    var items: [MovieInfo] = []
    var filteredMovies: [MovieInfo] = []
    var searchedMovies: [MovieInfo] = []
}

extension FutureMovieData {
    func update(items: [MovieInfo]) {
        self.items = items.sorted(by: { $0.rank < $1.rank })
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

