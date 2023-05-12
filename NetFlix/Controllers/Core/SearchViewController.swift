//
//  SearchViewController.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 4/15/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    /*
     Đoạn mã này định nghĩa một biến (variable) titles là một mảng (array) của kiểu Title, và khởi tạo mảng đó với một mảng rỗng.
     
     Để giải thích kỹ hơn:

     => private là một từ khóa truy cập (access modifier) trong Swift, nó chỉ ra rằng biến này chỉ có thể truy cập được trong phạm vi của lớp hay cấu trúc (class hoặc struct) chứa nó.
     => var là từ khóa để khai báo biến (variable) trong Swift.
     => titles là tên của biến.
     => [Title] là kiểu dữ liệu của biến, trong trường hợp này là một mảng (array) chứa các phần tử kiểu Title.
     => [Title]() là cú pháp khởi tạo giá trị cho biến titles. Trong trường hợp này, titles được khởi tạo với một mảng rỗng (empty array) của kiểu Title.
     
     */
    private var titles: [Title] = [Title]()
    
    private let discoverTable: UITableView = {
       let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.indentifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .white
        
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    /*
     
     Đoạn mã này định nghĩa một hàm (function) fetchDiscoverMovies làm việc với API (Application Programming Interface) để lấy danh sách phim mới.
     
     Để giải thích kỹ hơn:
     
     Hàm này sử dụng một đối tượng ApiCaller để gọi phương thức getDiscoverMovies để lấy danh sách phim mới. Đối số của phương thức này là một completion handler (closure) với một tham số kiểu Result<[Title], Error>.

     [weak self] là một khối mã để tránh bị retain cycle khi sử dụng trong closure (có thể hiểu là một tình huống mà đối tượng được lưu giữ trong closure vẫn còn tồn tại sau khi closure được gọi xong).
     
     result là một tham số của closure, kiểu Result<[Title], Error>. Result là một kiểu đại diện cho kết quả của một hoạt động có thể thành công hoặc thất bại.
     
     switch result là một câu lệnh switch-case, kiểm tra giá trị của result.
     
     case.success(let titles) là một trường hợp của câu lệnh switch-case, chỉ thực thi nếu kết quả trả về là thành công (success), và đồng thời gán giá trị titles được trả về vào thuộc tính titles của đối tượng self. let titles được sử dụng để ràng buộc giá trị trả về của result thành một biến tạm có kiểu [Title].
     
     DispatchQueue.main.async được sử dụng để đảm bảo rằng việc cập nhật UI (gọi phương thức reloadData của bảng hiển thị danh sách phim mới) được thực hiện trên luồng chính (main thread).
     
     case.failure(let error) là một trường hợp của câu lệnh switch-case, chỉ thực thi nếu kết quả trả về là thất bại (failure), và hiển thị thông báo lỗi trong console.
     */
    
    private func fetchDiscoverMovies () {
        ApiCaller.shared.getDiscoverMovies{ [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    /*
     
     Đoạn mã này định nghĩa một phương thức (method) tableView(_:cellForRowAt:) của lớp (class) được kế thừa từ UITableViewDataSource, được sử dụng để hiển thị dữ liệu trong một UITableViewCell trên bảng (table view).
     
     func là từ khóa để khai báo một phương thức (method) trong Swift.Z
     tableView là tên của tham số đầu tiên, kiểu UITableView, biểu thị cho bảng (table view) đang được hiển thị.
     _ là một wildcard pattern, được sử dụng để bỏ qua tên tham số đầu tiên.
     cellForRowAt là tên của phương thức.
     indexPath là tên của tham số thứ hai, kiểu IndexPath, biểu thị cho vị trí (index path) của ô (cell) đang được hiển thị trên bảng.
     -> UITableViewCell là kiểu giá trị trả về của phương thức, là một UITableViewCell.
     Phương thức này sử dụng phương thức dequeueReusableCell(withIdentifier:for:) của đối tượng tableView để lấy một ô tái sử dụng (reusable cell) từ bộ nhớ đệm của bảng. Nếu không có ô tái sử dụng nào khả dụng, phương thức này trả về một UITableViewCell.

     guard là một câu lệnh kiểm tra điều kiện, sử dụng để kiểm tra xem việc tái sử dụng ô thành công hay không.
     let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.indentifier, for: indexPath ) as? TitleTableViewCell là cú pháp để lấy ô tái sử dụng từ đối tượng tableView, với TitleTableViewCell.indentifier là một chuỗi định danh (identifier) của lớp TitleTableViewCell. Nếu việc lấy ô thành công, cell sẽ được gán giá trị của ô đó.
     else là một khối mã được thực thi nếu việc lấy ô tái sử dụng thất bại, và trả về một UITableViewCell().
     Sau khi có được ô tái sử dụng, phương thức này sử dụng vị trí của ô đó để lấy dữ liệu từ mảng titles, sau đó tạo một TitleViewModel từ dữ liệu đó. TitleViewModel được sử dụng để cấu hình ô, thông qua phương thức configure(with:) của lớp TitleTableViewCell.

     Cuối cùng, phương thức trả về ô đã được cấu hình để hiển thị trên bảng.
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.indentifier, for: indexPath ) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let model =  TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown name" , posterUrl: title.poster_path ?? "" )
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           
           let title = titles[indexPath.row]
           
           guard let titleName = title.original_title ?? title.original_name else {
               return
           }
           
           
           ApiCaller.shared.getMovies(with: titleName) { [weak self] result in
               switch result {
               case .success(let videoElement):
                   DispatchQueue.main.async {
                       let vc = TitlePreviewViewController()
                       vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                       self?.navigationController?.pushViewController(vc, animated: true)
                   }

                   
               case .failure(let error):
                   print(error.localizedDescription)
               }
           }
       }
    
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        resultsController.delegate = self
        
        ApiCaller.shared.search(with: query) {
            result in DispatchQueue.main.async {
                switch result {
                case.success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
                
    }
    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
            
            DispatchQueue.main.async { [weak self] in
                let vc = TitlePreviewViewController()
                vc.configure(with: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    
    
}
