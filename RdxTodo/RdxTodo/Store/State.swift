//
// Created by Boris Schneiderman on 2017-05-06.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

enum TodoListsSorting {
    case byName
    case byDate
}

struct State {
    var lists: [TodoList] = []
    var sortBy: TodoListsSorting = .byDate
    var selectedListId: ID? = nil
}

extension State {
    var selectedList: TodoList? {
        guard let id = self.selectedListId else {
            return nil
        }

        return self.lists.first(where: {$0.id == id})
    }
}

enum Action {
    case addTodoList(TodoList)
    case removeTodoList(ID)
    case setListSort(TodoListsSorting)
    case changeList(ID, ListAction)
}

extension Action {
    init(_ id: ID, _ listAction: ListAction) {
        self = .changeList(id, listAction)
    }
}

func reducer(_ state: State, action: Action) -> State {

    var state = state

    func listIndex(_ id: ID) -> Int? {
        return state.lists.index(where: { $0.id == id })
    }

    switch action {
    case .addTodoList(let todoList):
        state.lists.append(todoList)
    case .removeTodoList(let id):
        if let ix = listIndex(id) {
            state.lists.remove(at: ix)
        }
    case .setListSort(let sort):
        state.sortBy = sort
    case .changeList(let id, let action):
        if let ix = listIndex(id) {
            state.lists[ix] = listReducer(state.lists[ix], action: action)
        }
    }

    return state
}
