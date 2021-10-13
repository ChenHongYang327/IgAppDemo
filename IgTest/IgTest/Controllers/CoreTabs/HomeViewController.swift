//
//  HomeViewController.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/8.
//

import UIKit
import FirebaseAuth

struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        // register cells
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModels()
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func createMockModels(){
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
        var comments = [PostComment]()
        for x in 0...2 {
            comments.append(PostComment(identifier: "\(x)",
                                        username: "Jack",
                                        text: "This is good post",
                                        createdDate: Date(),
                                        likes: []))
        }
        
        for _ in 0..<5 {
            
            let viewModel = HomeFeedRenderViewModel(
                header: PostRenderViewModel(randerType: .header(provider: user)),
                post: PostRenderViewModel(randerType: .primaryContent(provider: post)),
                actions: PostRenderViewModel(randerType: .actions(provider: "")),
                comments: PostRenderViewModel(randerType: .comments(comments: comments)))
            
            feedRenderModels.append(viewModel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        handleNotAuthenticated()
    }
    
    private func handleNotAuthenticated(){
        // check Auth Status
        if Auth.auth().currentUser == nil {
            // show login
            let logVC = LoginViewController()
            logVC.modalPresentationStyle = .fullScreen
            present(logVC, animated: false, completion: nil)
        }
    }
    
    
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model: HomeFeedRenderViewModel
        // x==0 計算會崩潰，且他是header 較特殊
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let position = x%4 == 0 ? x/4 : (x-x%4)/4
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0{
            // header
            return 1
        }
        else if subSection == 1{
            // post
            return 1
        }
        else if subSection == 2{
            // actions
            return 1
        }
        else if subSection == 3{
            // comments
            let commentsModel = model.comments
            switch commentsModel.randerType {
            case .comments(comments: let comments):
                return comments.count > 2 ? 2 : comments.count
            case .primaryContent, .actions, .header: return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let position = x%4 == 0 ? x/4 : (x-x%4)/4
            model = feedRenderModels[position]
        }
        
        let subSecction = x % 4
        
        if subSecction == 0{
            // header
            switch model.header.randerType{
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .actions, .primaryContent, .comments: return UITableViewCell()
            }
        }
        else if subSecction == 1{
            // post
            let postModel = model.post
            switch postModel.randerType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
                cell.configure(with: post)
                return cell
            case .actions, .header , .comments: return UITableViewCell()
            }
        }
        else if subSecction == 2{
            // actions
            switch model.actions.randerType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
                cell.delegate = self
                return cell
            case .header, .primaryContent, .comments: return UITableViewCell()
            }
        }
        else if subSecction == 3{
            // comments
            switch model.comments.randerType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                return cell
            case .actions, .primaryContent, .header: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        
        if subSection == 0{
            // header
            return 70
        }
        else if subSection == 1{
            // post
            return tableView.width
        }
        else if subSection == 2{
            // actions (like / comment)
            return 60
        }
        else if subSection == 3{
            // comments row
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
    
}

// MARK: IGFeedPost-Header-TableViewCellDelegate
extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func reportPost(){
        
    }
    
}

// MARK: IGFeedPost-Actions-TableViewCellDelegate
extension HomeViewController: IGFeedPostActionsTableViewCellDelegate {
    func didTapLikeButton() {
        print("like")
    }
    
    func didTapCommentButton() {
        print("comment")
    }
    
    func didTapSendButton() {
        print("send")
    }
    
}
