//
//  UpComingViewController.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 4/15/23.
//

import UIKit

class UpComingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let upcomingTable: UITableView =  {
        
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.indentifier)
        return table
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "UpComing"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    // fetch api Upcoming
    private func fetchUpcoming() {
        ApiCaller.shared.getUpComingMovies{[weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.sync {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpComingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    // lấy thông tin titles
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.indentifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title =  titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name" , posterUrl: title.poster_path ?? ""))
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
