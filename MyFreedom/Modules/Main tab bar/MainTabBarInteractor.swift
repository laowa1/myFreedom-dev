//
//  MainTabBarInteractor.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 27.04.2022.
//


class MainTabBarInteractor {

    private unowned let view: MainTabBarViewInput

    init(view: MainTabBarViewInput) {
        self.view = view
    }
}

extension MainTabBarInteractor: MainTabBarInteractorInput {

}
