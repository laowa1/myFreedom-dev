//
//  TPFavoritesViewInput.swift
//  MyFreedom
//
//  Created by &&TairoV on 28.04.2022.
//

import UIKit.UISearchController

protocol TPFavoritesViewInput: BaseViewController {

    func pass(segmentTitles: [String])
    func deleteItemElement(at indexPath: IndexPath)
    func reload()
}
