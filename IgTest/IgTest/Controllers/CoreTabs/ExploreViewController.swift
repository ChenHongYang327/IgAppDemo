//
//  SearchViewController.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/8.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    private var models = [UserPost]()
    
    private var collectionView: UICollectionView?
    
    private var tabbedSearchCollectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureSearchBar()
        configureExploreCollection()
        configureDimmedView()
        configureTabbedSearch()
    
    }
    
    private func configureTabbedSearch(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/3, height: 52)
        layout.scrollDirection = .horizontal
        tabbedSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tabbedSearchCollectionView?.backgroundColor = .yellow
        tabbedSearchCollectionView?.isHidden = true
        guard let tabbedSearchCollectionView = tabbedSearchCollectionView else {
            return
        }
        tabbedSearchCollectionView.dataSource = self
        tabbedSearchCollectionView.delegate = self
        view.addSubview(tabbedSearchCollectionView)
    }
    
    private func configureDimmedView(){
        // add dimmedView can cancel
        view.addSubview(dimmedView)
        let gessture = UITapGestureRecognizer(target: self, action: #selector(didTapCancelSearch))
        gessture.numberOfTapsRequired = 1
        gessture.numberOfTouchesRequired = 1
        dimmedView.addGestureRecognizer(gessture)
    }
    
    private func configureSearchBar(){
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureExploreCollection(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width-4)/3, height: (view.width-4)/3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
        tabbedSearchCollectionView?.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.bottom,
            width: view.width,
            height: 72)
    }
    
}
extension ExploreViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didTapCancelSearch()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        query(text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didTapCancelSearch))
        
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2,animations: {
            self.dimmedView.alpha = 0.4
        }) { done in
            if done {
                self.tabbedSearchCollectionView?.isEditing = false
            }
        }
    }
    
    @objc func didTapCancelSearch(){
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        
        self.tabbedSearchCollectionView?.isEditing = true
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0
        }){ done in
            if done {
                self.dimmedView.isHidden = true
            }
        }
    }
    
    private func query(_ text: String){
        // preform the search in the back end
        
    }
    
}
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabbedSearchCollectionView {
            return 0
        }
        return 31
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabbedSearchCollectionView {
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else{
            return UICollectionViewCell()
        }
//        cell.configure(with: <#T##UserPost#>)
        cell.configure(debug: "test")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView == tabbedSearchCollectionView {
            // change search context
            return
        }
        
//        let model = models[indexPath.row]
        let user = User(username: "@Hank_Chen",
                        bio: "",
                        name: (first: "first", last: "last"),
                        profilePhoto: URL(string: "https://i.epochtimes.com/assets/uploads/2021/08/id13156667-shutterstock_376153318-450x322.jpg")!,
                        birthday: Date(),
                        gender: .male,
                        counts: UserCount(followers: 1, following: 1, posts: 1),
                        joinDate: Date())
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Cat_November_2010-1a.jpg/1200px-Cat_November_2010-1a.jpg")!,
                            postURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Cat_November_2010-1a.jpg/1200px-Cat_November_2010-1a.jpg")!,
                            caption: nil,
                            likeCount: [],
                            comments: [],
                            createDate: Date(),
                            taggedUsers: [],
                            owner: user)
        let vc = PostViewController(model: post)
        vc.title = post.postType.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
