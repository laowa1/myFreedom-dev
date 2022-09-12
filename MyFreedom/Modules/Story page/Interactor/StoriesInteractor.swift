//
//  StoryPageInteractor.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.03.2022.
//

import UIKit

struct StoryItem {
    var image: BaseImage
    var title: String?
    var subtitle: String?
}

class StoriesInteractor {
    
    private var storiesData = [StoryItem]()
    private var view: StoriesViewInput

    private var buttonTitle: String
    private var buttonImage: BaseImage?

    init(view: StoriesViewInput,
         closeHidden: Bool = true,
         buttonTitle: String = "Начать",
         buttonImage: BaseImage? = nil,
         buttonAction: (() -> Void)? = nil) {
        self.view = view

        self.buttonTitle = buttonTitle
        self.buttonImage = buttonImage
    }
}

extension StoriesInteractor: StoriesInteractorInput {

    func fetchStoriesData() {
        storiesData = [
            StoryItem(image: .onboarding_1),
            StoryItem(image: .onboarding_2),
            StoryItem(image: .onboarding_3),
            StoryItem(image: .onboarding_4)
        ]
    }
    
    func getStoryItem(for index: Int) -> StoryItem {
        return storiesData[index]
    }
    
    func numberOfItems() -> Int {
        return storiesData.count
    }

    func configureButtons() {
        view.storyButtons(title: buttonTitle, image: buttonImage)
    }
}
