//
//  CUAccessCodeInteractorInput.swift
//  MyFreedom
//
//  Created by m1pro on 10.04.2022.
//

protocol CUAccessCodeInteractorInput: AnyObject {
    func passItem(at index: Int)
    func getType() -> CUAccessCodeType
}
