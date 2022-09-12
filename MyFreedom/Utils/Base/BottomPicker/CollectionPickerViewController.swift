//
//  CollectionPickerViewController.swift
//  MyFreedom
//
//  Created by m1pro on 10.06.2022.
//

import UIKit

protocol ICollectionPickerInput: IPickerInput, UICollectionViewDataSource, UICollectionViewDelegate { }

class CollectionPickerViewController<Cell: CollectionPickerCellProtocol>: UIViewController, ICollectionPickerInput {

    var presenter: IBottomSheetPresenter? {
        didSet {
            guard let presenter = presenter else {
                return
            }

            updateData()
            print(presenter.getSelectedIndex())
            collectionView.selectItem(at: IndexPath.init(item: presenter.getSelectedIndex(), section: 0),
                                      animated: false,
                                      scrollPosition: [])
        }
    }

    private lazy var layout: UICollectionViewFlowLayout = build {
        $0.sectionInset = .zero
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.itemSize = Cell.itemSize
        $0.headerReferenceSize = CGSize(width: UIView.screenWidth, height: presenter?.headerInSectionHeight() ?? 0)
    }

    private lazy var collectionView: UICollectionView = build(UICollectionView(frame: .zero, collectionViewLayout: layout))  {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.register(Cell.self)
        $0.register(
            CollectionHeaderFooterView<BackdropHeaderView>.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        $0.dataSource = self
        $0.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }

    private func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(collectionView)
    }

    private func setupLayout() {
        var layoutConstraints = [NSLayoutConstraint]()

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += collectionView.getLayoutConstraints(over: self.view, safe: false)

        NSLayoutConstraint.activate(layoutConstraints)
        updateData()
    }

    func closePicker() {
        dismissDrawer(completion: nil)
    }

    func updateData() {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfItemsInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueReusableCell(for: indexPath)
        if let viewModel = presenter?.getItemBy(index: indexPath.row) as? Cell.Item {
            cell.configure(viewModel: viewModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelect(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let title = presenter?.getTitle(), kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerView: CollectionHeaderFooterView<BackdropHeaderView> = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            for: indexPath
        )
        headerView.innerView.configure(title: title) { [weak self] in
            self?.closePicker()
        }
        return headerView
    }
}

extension CollectionPickerViewController: BaseDrawerContentViewControllerProtocol {

    var contentViewHeight: CGFloat { collectionView.contentSize.height }
}
