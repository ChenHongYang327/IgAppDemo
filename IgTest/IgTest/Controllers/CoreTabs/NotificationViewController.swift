//
//  NotificationViewController.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/8.
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost)
    case follow(followstate: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTableViewCell.self, forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    // lazy 有需要才呼叫
    private lazy var noNotificationsView = NoNotificationsView()
    
    private var models = [UserNotification]()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchmodels()
        
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        
        view.addSubview(spinner)
//        spinner.startAnimating()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchmodels(){
        for x in 0...50 {
            let user = User(username: "Hank",
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
            //x%2 == 0 ? .like(post: post) : .follow
            let model = UserNotification(type: x%2 == 0 ? .like(post: post) : .follow(followstate: .not_following),
                                         text: "Hello Word",
                                         user: user)
            models.append(model)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func addNoNotificationsView(){
        tableView.isHidden = true
        view.addSubview(noNotificationsView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationsView.center = view.center
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        
        switch model.type {
        case .like(_):
            // like cwll
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier, for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
            
        case .follow:
            // follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier, for: indexPath) as! NotificationFollowEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }

}
// MARK: Notification-Like-EventTableViewCellDelegate
extension NotificationViewController: NotificationLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotification) {
        switch model.type{
        case .like(post: let post):
            // open the post
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .follow(_):
            fatalError("Dev issue: Should never get called")
        }
    }
    
}
// MARK: Notification-Follow-EventTableViewCellDelegate
extension NotificationViewController: NotificationFollowEventTableViewCellDelegate {
    func didTapFollowUnFollowButton(model: UserNotification) {
        print("tapped follow button")
        // perform database update
    }
    
    
}

