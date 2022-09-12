//
//  StoriesInteractorInpput.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.03.2022.
//

import UIKit

protocol StoriesInteractorInput: AnyObject {
    func fetchStoriesData()
    func getStoryItem(for index: Int) -> StoryItem
    func numberOfItems() -> Int
    func configureButtons()
}
