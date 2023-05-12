//
//  ApiCaller.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 4/19/23.
//

import Foundation

struct Constants {
    static let API_KEY = "1634d6e9be0f8457dd34144652ec6a2b"
    static let BASE_URL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyCA8PuVLiDQAHLTUVf2nTXIwSrM5AiFjtw"
    static let YoutubeBaseUrl = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedTogetData
}

class ApiCaller {
    static let shared = ApiCaller()
    
    /*
     
     Đoạn code này là một hàm để lấy danh sách các phim được xem nhiều nhất trong ngày (trending movies).
     
     Hàm này nhận một closure completion để trả về kết quả, đó là một mảng các Title (tiêu đề) của phim hoặc một lỗi nếu có vấn đề xảy ra khi lấy dữ liệu.

     Trong hàm, đầu tiên nó kiểm tra URL để đảm bảo rằng nó không nil. Sau đó, nó sử dụng URL đó để tạo một task với URLSession.shared.dataTask, được sử dụng để lấy dữ liệu từ server.

     Sau khi lấy được dữ liệu, hàm này sử dụng JSONDecoder để giải mã dữ liệu JSON thành một đối tượng TrendingTitleReponse (có chứa một mảng các đối tượng Title). Nếu thành công, hàm này sẽ trả về mảng các Title thông qua closure completion. Nếu không thành công, nó sẽ trả về một lỗi (APIError.failedTogetData).
     */
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>)  -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _ , error in guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleReponse.self, from: data)
                
                completion(.success(results.results))
            } catch{
                completion(.failure(APIError.failedTogetData))
            }
            
        }
        
        task.resume()
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>)  -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _ , error in guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleReponse.self, from: data)
                
                
                completion(.success(results.results))
            } catch{
                completion(.failure(APIError.failedTogetData))
            }
            
        }
        
        task.resume()
    }
    
    func getUpComingMovies(completion: @escaping (Result<[Title], Error>)  -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _ , error in guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleReponse.self, from: data)
                
                completion(.success(results.results))
            } catch{
                completion(.failure(APIError.failedTogetData))
            }
            
        }
        
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Title], Error>)  -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _ , error in guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleReponse.self, from: data)
                
                completion(.success(results.results))
            } catch{
                completion(.failure(APIError.failedTogetData))
            }
            
        }
        
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleReponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
            
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleReponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
            
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.BASE_URL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleReponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
            
        }
        task.resume()
    }
    
    func getMovies(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.YoutubeBaseUrl)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(results.items[0]))
                
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}
