import Foundation
import UIKit

public protocol DrinkTypeControllerDelegate: class {
    func drinkTypeViewControllerDidTapClose(_ drinkTypeViewController: DrinkTypeViewController)
    func drinkTypeViewController(_ drinkTypeViewController: DrinkTypeViewController, didSelectDrinkType drinkType: String)
}

public class DrinkTypeViewController: UITableViewController {
    
    private let services: Services
    
    public weak var delegate: DrinkTypeControllerDelegate?
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.closeButtonTapped))
        return closeBarButtonItem
    }()
    
    private let drinkTypes = [
        "Coffee",
        "Tea",
        "Flat white",
        "Coke"
    ]
    
    public init(services: Services) {
        self.services = services
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Select Drink"
        self.navigationItem.leftBarButtonItem = self.closeBarButtonItem
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonTapped(sender: UIBarButtonItem) {
        self.delegate?.drinkTypeViewControllerDidTapClose(self)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // I like slightly larger cells 😃
        self.tableView.rowHeight = 50
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let drinkType = self.drinkTypes[indexPath.row]
        self.delegate?.drinkTypeViewController(self, didSelectDrinkType: drinkType)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let drinkType = self.drinkTypes[indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = drinkType
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drinkTypes.count
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
