//
//  PDBCardType.swift
//  MyFreedom
//
//  Created by m1pro on 23.06.2022.
//

enum PDBCardType: Int {
    case freedom, invest, children

    var currentGradient: GradientColor {
        switch self {
        case .children:
            return .rouse
        case .freedom:
            return .green
        case .invest:
            return .black
        }
    }
}

enum GradientColor: CaseIterable {
    case green, rouse, darkBlue, black

    var gradientColors: [BaseColor] {
        switch self {
        case .green: return [._36A75D, ._3E847E]
        case .rouse: return [._FF8181, ._C23378]
        case .darkBlue: return [._65649A, ._2D2D46]
        case .black: return [._454543, ._3A3939]
        }
    }
}
