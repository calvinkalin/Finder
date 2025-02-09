//
//  PersonRow.swift
//  Finder
//
//  Created by Ilya Kalin on 07.02.2025.
//

import SwiftUI

struct PersonRow: View {
    var person: Person
    
    var body: some View {
        HStack {
            person.avatar
                .resizable()
                .frame(width: 50, height: 50)
            Text(person.name)
        }
    }
}
