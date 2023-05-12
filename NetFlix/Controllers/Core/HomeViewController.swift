//
//  HomeViewController.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 4/15/23.
//

import UIKit

// enum Section output là số.
enum Section: Int {
    case TrendingMovie = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

// class HomeViewController kế thừa UIViewController
// thể hiện đây là một View có thể overide để dùng các phương thức của class UIViewController
class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles:[String] = ["Trending Movie", "Popular", "Trending Tv", "Upcoming Movies", "Top Rated" ]
    
    // B1: Khởi tạo ban đầu
    // Tạo list danh sách dùng UITableView ( kế thừa UITableView là một lớp tạo một list )
    private let homeFeedTable: UITableView = {
        // Định nghĩa table là một UITableView
        let table = UITableView(frame: .zero, style: .grouped)
        // Đăng ký một list là CollectionViewTableViewCell để hiện thị
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    // B2: Thêm và sử dụng
    override func viewDidLoad() {
        super.viewDidLoad()
        // ViewDidLoad là một hàm thể hiện life circle của một màn hình
        // Sau khi màn hình đó được khởi tạo thành công
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.height, height: 450))
        
        homeFeedTable.tableHeaderView = headerView
        
        configureHeroHeaderView()
        
    }
    
    private func configureHeroHeaderView() {

        ApiCaller.shared.getTrendingMovies { [weak self] result in
                switch result {
                case .success(let titles):
                    let selectedTitle = titles.randomElement()
                    
                    self?.randomTrendingMovie = selectedTitle
                    self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterUrl: selectedTitle?.poster_path ?? ""))
                    
                case .failure(let erorr):
                    print(erorr.localizedDescription)
                }
            }
            


        }
    
    // private func: func chỉ dùng trong file này.
    private func configureNavBar(){
        var logoImage = UIImage(named: "netflix-logo")
        // lấy mầu chuẩn của ảnh
        logoImage = logoImage?.withRenderingMode(.alwaysOriginal)
        // thêm button điều hướng bên trái
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .done, target: self, action: nil)
        
        // thêm các button điều hướng bên phải
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
            
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

}


// extension (Swift) cho phép phương thức hiện tại bổ sung thêm thuộc tính mới
// cụ thể ở đây do đã khai báo homeFeedTable.delegate = self và homeFeedTable.dataSource = self
// nên HomeViewController sẽ phải thêm 2 protocol là UITableViewDelegate và UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    
    // Hàm này trả về số lượng hàng trong bảng
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Thay số 0 bằng số lượng hàng mong muốn
        return 1
    }

    // Hàm này cung cấp UITableViewCell cho từng hàng trong bảng
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // ép kiểu sang CollectionViewTableViewCell nếu thành công dùng CollectionViewTableViewCell
        // nếu không trả về kiểu mặc định UITableViewCell()
        // guard let cell - ý nghĩa là nếu việc ép kiểu không thành công thì tiếp tục
        // sẽ trả về kiểu mặc định UITableViewCell()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Section.TrendingMovie.rawValue:
            ApiCaller.shared.getTrendingMovies{
                
                result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.TrendingTv.rawValue:
            ApiCaller.shared.getTrendingTvs{
                
                result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.Popular.rawValue:
            ApiCaller.shared.getPopular{
                
                result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.Upcoming.rawValue:
            ApiCaller.shared.getUpComingMovies{
                
                result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.TopRated.rawValue:
            ApiCaller.shared.getTopRated{
                
                result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Hàm này trả về chiều cao của tiêu đề cho mỗi phần trong bảng
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Hàm này trả về chiều cao của mỗi hàng trong bảng.
        return 200
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        
    }
    
    // Tiêu đề cho các bảng
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
