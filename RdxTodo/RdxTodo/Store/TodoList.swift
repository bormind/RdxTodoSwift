//
// Created by Boris Schneiderman on 2017-05-06.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

struct TodoList {
    let id: ID
    let name: String
    var lastModified: Date
    
    var todoItems: [TodoItem] = []
    var filterOption: FilterOptions = .showAll
}

enum ListAction {
    case addItem(TodoItem)
    case removeItem(ID)
    case markAsCompleted(ID, Bool)
    case setFilter(FilterOptions)
}

func listReducer(_ state: TodoList, action: ListAction) -> TodoList {

    var state = state

    func itemIndex(_ id: ID) -> Int? {
        return state.todoItems.index(where: { $0.id == id })
    }

    switch action {
    case .addItem(let item):
        state.todoItems.append(item)
    case .removeItem(let id):
        if let ix = itemIndex(id) {
            state.todoItems.remove(at: ix)
        }
    case .markAsCompleted(let id, let isCompleted):
        if let ix = itemIndex(id) {
            state.todoItems[ix].isCompleted = isCompleted
        }
    case .setFilter(let filter):
        state.filterOption = filter
    }

    return state

}

