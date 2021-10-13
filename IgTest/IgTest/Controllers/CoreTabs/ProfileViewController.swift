//
//  ProfileViewController.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/8.
//

import UIKit

/// Profile view controller
class ProfileViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    private var userPosts = [UserPost]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationBar()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let size = (view.width-4)/3
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        layout.itemSize = CGSize(width: size, height: size)
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        
        
        // cell
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        // Headers
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        collectionView?.register(ProfileTabsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier)
        
        
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
    }
    
    
    private func configureNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingButton))
    }

    @objc private func didTapSettingButton(){
        let settingsVC = SettingsViewController()
        settingsVC.title = "Settings"
        navigationController?.pushViewController(settingsVC, animated: true)
    }


}
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        //return userPosts.count
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        //let model = userPosts[indexPath.row]
        cell.configure(debug: "test")
        //cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // get the model and open post controller
        //let model = userPosts[indexPath.row]
        
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
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            // footer
            return UICollectionReusableView()
        }
        
        if indexPath.section == 1 {
            // tabs header
            let tabControlHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: ProfileTabsCollectionReusableView.identifier,
                                                                         for: indexPath) as! ProfileTabsCollectionReusableView
            tabControlHeader.delegate = self
            return tabControlHeader
            
        }
        
        let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier,
                                                                     for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        profileHeader.delegate = self
        return profileHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0{
            return CGSize(width: collectionView.width, height: collectionView.height/3)
        }
        
        // size for section tabs
        return CGSize(width: collectionView.width, height: 50)
    }
}

// MARK: ProfileInfoHeaderCollectionReusableViewDelegate

extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    func profileHeaderDidTapPostsButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        // scroll to the posts
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
    }
    
    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        var mockData = [UserRelationship]()
        for x in 0..<10 {
            mockData.append(UserRelationship(username: "@Hank", name: "Hank", type: x%2 == 0 ? .following : .not_following))
        }
        
        let vc = ListViewController(data: mockData)
        vc.title = "Followers"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        var mockData = [UserRelationship]()
        for x in 0..<10 {
            mockData.append(UserRelationship(username: "@Hank", name: "Hank", type: x%2 == 0 ? .following : .not_following))
        }
        
        let vc = ListViewController(data: mockData)
        vc.title = "Following"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
}

// MARK: ProfileTabsCollectionReusableViewDelegate

extension ProfileViewController: ProfileTabsCollectionReusableViewDelegate {
    func didTapGridButtonTab() {
        // Reload collectionView with data
        print("touch")
    }
    
    func didTapTaggedButtonTab() {
        // Reload collectionView with data
        print("touch")
    }
    
    
}
