import Foundation
import UIKit

public protocol SnackTypeViewControllerDelegate: class {
    func snackTypeViewController(_ snackTypeViewController: SnackTypeViewController, didSelectSnackType snackType: String)
}

public class SnackTypeViewController: UITableViewController {
    
    private let services: Services
    
    public var delegate: SnackTypeViewControllerDelegate? = nil
    
    private let snackTypes = [
        "Muffin",
        "Cookie",
        "Tim tam",
        "Scroggin"
    ]
    
    public init(services: Services) {
        self.services = services
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Select Snack"
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // I like slightly larger cells 😃
        self.tableView.rowHeight = 50
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let snackType = self.snackTypes[indexPath.row]
        self.delegate?.snackTypeViewController(self, didSelectSnackType: snackType)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let snackType = self.snackTypes[indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = snackType
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.snackTypes.count
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
