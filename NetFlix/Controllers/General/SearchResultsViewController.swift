//
//  SearchResultsTableViewCell.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 5/8/23.
//

import UIKit

/*
 
 Đây là một protocol với tên SearchResultsViewControllerDelegate được định nghĩa trong Swift. Protocol này định nghĩa một phương thức có tên là searchResultsViewControllerDidTapItem, và nó được định nghĩa để được sử dụng bởi một lớp hay struct khác.

 Phương thức searchResultsViewControllerDidTapItem được gọi khi một mục trong kết quả tìm kiếm được chọn. Phương thức này nhận đối số là một TitlePreviewViewModel, đại diện cho dữ liệu của mục được chọn.

 AnyObject được sử dụng ở đây để chỉ ra rằng protocol chỉ có thể được áp dụng cho các đối tượng class, chứ không phải cho các đối tượng struct. Có nghĩa là các đối tượng class có thể triển khai protocol này để xử lý sự kiện được kích hoạt bởi người dùng.
 
 */
protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}


class SearchResultsViewController: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    /*
     Đây là một thuộc tính có kiểu là một đối tượng (SearchResultsViewControllerDelegate) được định nghĩa trước đó. Thuộc tính này được khai báo là weak để tránh vấn đề về bộ nhớ khi sử dụng protocol delegate.

     delegate được sử dụng để giữ một tham chiếu tới một đối tượng đã triển khai SearchResultsViewControllerDelegate. Đối tượng này sẽ được sử dụng để xử lý sự kiện được kích hoạt trong SearchResultsViewController.

     Từ khóa weak ở đầu khai báo đảm bảo rằng nếu đối tượng được giữ bởi thuộc tính delegate đã bị giải phóng, thì delegate sẽ tự động trở thành nil, tránh gây ra vấn đề về bộ nhớ như "memory leak".
     */
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.indentifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.indentifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           collectionView.deselectItem(at: indexPath, animated: true)
           
           let title = titles[indexPath.row]
           let titleName = title.original_title ?? ""
           ApiCaller.shared.getMovies(with: titleName) { [weak self] result in
               switch result {
               case .success(let videoElement):
                   self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewViewModel(title: title.original_title ?? "", youtubeView: videoElement, titleOverview: title.overview ?? ""))

                   
               case .failure(let error):
                   print(error.localizedDescription)
               }
           }
           

       }
    
    
}
