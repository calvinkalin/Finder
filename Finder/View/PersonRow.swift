//
//  PersonRow.swift
//  Finder
//
//  Created by Ilya Kalin on 07.02.2025.
//

import SwiftUI

struct PersonRow: View {
    var person: Person
    var distance: String
    var isSelected: Bool
    
    var body: some View {
        HStack {
            person.avatar
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            VStack(alignment: .leading) {
                Text(person.name)
                    .font(.headline)
                Text(distance)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(isSelected ? Color.cyan.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
}
