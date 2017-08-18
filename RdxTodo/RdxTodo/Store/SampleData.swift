//
// Created by Boris Schneiderman on 6/17/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

let BROKEN_LIST_ID = ListId()

let SAMPLE_DATA: [TodoList] = [
  TodoList(id: ListId(), name:"Shopping List", lastModified: Date(), todoItems: [
    TodoItem(id: ListItemId(), todoText: "Artichoke"),
    TodoItem(id: ListItemId(), todoText: "Asparagus"),
    TodoItem(id: ListItemId(), todoText: "Arugula"),
    TodoItem(id: ListItemId(), todoText: "Avocado"),
    TodoItem(id: ListItemId(), todoText: "Bamboo shoots"),
    TodoItem(id: ListItemId(), todoText: "Beets"),
    TodoItem(id: ListItemId(), todoText: "Bell peppers"),
    TodoItem(id: ListItemId(), todoText: "Bok choy"),
    TodoItem(id: ListItemId(), todoText: "Broccoli"),
    TodoItem(id: ListItemId(), todoText: "Brussels sprouts"),
    TodoItem(id: ListItemId(), todoText: "Cabbage"),
    TodoItem(id: ListItemId(), todoText: "Carrots"),
    TodoItem(id: ListItemId(), todoText: "Cassava"),
    TodoItem(id: ListItemId(), todoText: "Cauliflower"),
    TodoItem(id: ListItemId(), todoText: "Celery"),
    TodoItem(id: ListItemId(), todoText: "Chard"),
    TodoItem(id: ListItemId(), todoText: "Collard greens"),
    TodoItem(id: ListItemId(), todoText: "Corn"),
    TodoItem(id: ListItemId(), todoText: "Crisphead lettuce"),
    TodoItem(id: ListItemId(), todoText: "Cucumber"),
    TodoItem(id: ListItemId(), todoText: "Daikon"),
    TodoItem(id: ListItemId(), todoText: "Eggplant"),
    TodoItem(id: ListItemId(), todoText: "Endive"),
    TodoItem(id: ListItemId(), todoText: "Garlic"),
    TodoItem(id: ListItemId(), todoText: "Ginger"),
    TodoItem(id: ListItemId(), todoText: "Hot peppers"),
    TodoItem(id: ListItemId(), todoText: "Jicama"),
    TodoItem(id: ListItemId(), todoText: "Kale"),
    TodoItem(id: ListItemId(), todoText: "Kohlrabi"),
    TodoItem(id: ListItemId(), todoText: "Leaf lettuce"),
    TodoItem(id: ListItemId(), todoText: "Mushrooms"),
    TodoItem(id: ListItemId(), todoText: "Nopales"),
    TodoItem(id: ListItemId(), todoText: "Okra"),
    TodoItem(id: ListItemId(), todoText: "Onions"),
    TodoItem(id: ListItemId(), todoText: "Peas"),
    TodoItem(id: ListItemId(), todoText: "Potatoes"),
    TodoItem(id: ListItemId(), todoText: "Radishes"),
    TodoItem(id: ListItemId(), todoText: "Radicchio"),
    TodoItem(id: ListItemId(), todoText: "Romaine lettuce"),
    TodoItem(id: ListItemId(), todoText: "Shallots / Leeks"),
    TodoItem(id: ListItemId(), todoText: "Spinach"),
    TodoItem(id: ListItemId(), todoText: "Sprouts"),
    TodoItem(id: ListItemId(), todoText: "Squash"),
    TodoItem(id: ListItemId(), todoText: "Sweet potatoes"),
    TodoItem(id: ListItemId(), todoText: "Taro"),
    TodoItem(id: ListItemId(), todoText: "Tomatillo"),
    TodoItem(id: ListItemId(), todoText: "Tomatoes"),
    TodoItem(id: ListItemId(), todoText: "Turnips / Parsnips"),
    TodoItem(id: ListItemId(), todoText: "Water chestnuts"),
    TodoItem(id: ListItemId(), todoText: "Watercress"),
    TodoItem(id: ListItemId(), todoText: "Zucchini")
  ]),

  TodoList(id: ListId(), name: "Linux Distros to try", lastModified: Date(), todoItems: [
    TodoItem(id: ListItemId(), todoText: "Arch Linux"),
    TodoItem(id: ListItemId(), todoText: "Debian"),
    TodoItem(id: ListItemId(), todoText: "Ubuntu"),
    TodoItem(id: ListItemId(), todoText: "OpenSUSE"),
    TodoItem(id: ListItemId(), todoText: "Fedora")
  ]),

  TodoList(id: ListId(), name: "Hugo Finalists To Read", lastModified: Date(), todoItems: [
    TodoItem(id: ListItemId(), todoText: "The Obelisk Gate, by N. K. Jemisin"),
    TodoItem(id: ListItemId(), todoText: "All the Birds in the Sky, by Charlie Jane Anders"),
    TodoItem(id: ListItemId(), todoText: "Ninefox Gambit, by Yoon Ha Lee"),
    TodoItem(id: ListItemId(), todoText: "Death’s End, by Cixin Liu, translated by Ken Liu"),
    TodoItem(id: ListItemId(), todoText: "A Closed and Common Orbit, by Becky Chambers"),
    TodoItem(id: ListItemId(), todoText: "Too Like the Lightning, by Ada Palmer"),
  ]),

  TodoList(id: BROKEN_LIST_ID, name: "NOT FOUND LIST", lastModified: Date(), todoItems: [])
]


