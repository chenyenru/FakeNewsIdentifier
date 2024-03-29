import UIKit
import NaturalLanguage
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var useDescriptions: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var showResultButton: UIButton!
    @IBOutlet weak var movieReviewText: UITextView!
    
    private lazy var sentimentClassifier: NLModel? = {
        let model = try? NLModel(mlModel: MyTextClassifier_2().model)
        return model
    }()
    
    
    var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //var managedObjectContext: NSManagedObjectContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        super.loadView()
        /*guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        // The persistent container is available
        */
        movieReviewText.delegate = self
        self.showResultButton.isUserInteractionEnabled = false
        /*self.showResultButton.alpha = 0.5
        self.movieReviewText.layer.borderColor = UIColor.lightGray.cgColor
        self.movieReviewText.layer.borderWidth = 1
        self.movieReviewText.layer.cornerRadius = 5
        self.movieReviewText.textColor = UIColor.black
        self.movieReviewText.text = ""
        */
        /*switch self.movieReviewText.text.count {
        case self.movieReviewText.text.count>10:
            self.showResultButton.isUserInteractionEnabled = true
        case self.movieReviewText.text.count < 10:
            self.showResultButton.isUserInteractionEnabled = false
        default:
            self.showResultButton.isUserInteractionEnabled = true
        }
        */
        /*self.movieReviewText.clipsToBounds=true
        self.movieReviewText.backgroundColor = UIColor(named:"Almond")
        self.movieReviewText.textAlignment = .center
 */
        self.movieReviewText.isScrollEnabled = false
        self.view.addSubview(movieReviewText)
        self.resultLabel.text = ""
        self.movieReviewText.becomeFirstResponder()
        
        //This is used to clear the database
        //dbClear()
        
    }
    
        
    
    @IBAction func showResult(_ sender: UIButton) {
        if self.movieReviewText.text.count > 10{
            self.resultLabel.text = "The news is too short"
            return
        }
        if let label = sentimentClassifier?.predictedLabel(for: self.movieReviewText.text) {
            switch label {
            case "True":
                self.resultImage.image = UIImage(named: "positive")
                self.resultLabel.text = "Positive"
                self.movieReviewText.textColor = UIColor.white
                self.movieReviewText.backgroundColor=UIColor(named: "")
            case "False":
                self.resultImage.image = UIImage(named: "negative")
                self.resultLabel.text = "Negative"
            default:
                self.resultImage.image = UIImage(named: "neutral")
                self.resultLabel.text = "Neutral"
            }
        }
        
        
        addUser(news: movieReviewText.text!)
        //movieReviewText.text = ""
    }
    
    //create
    func addUser(news: String){
        if (news == ""){
            return
        }
        if (news.count < 10){
            self.showResultButton.isUserInteractionEnabled = false
            self.resultLabel.text = "please enter more word"
        }
        let user = User(context: context)
        user.input_news = news
        user.actual = ((sentimentClassifier?.predictedLabel(for: self.movieReviewText.text)) != nil)
        user.predicted = ((sentimentClassifier?.predictedLabel(for: self.movieReviewText.text)) != nil)
        container.saveContext()
        print("存入資料 新聞名稱：\(news)")
    }
    
    @IBAction func clearAction(_ sender: UIButton) {
        self.resultImage.image = UIImage(named: "")
        self.resultLabel.text = ""
        self.movieReviewText.text = ""
        self.showResultButton.isUserInteractionEnabled = false
        self.showResultButton.alpha = 0.5
    }
    
    func dbClear() {
        // create the delete request for the specified entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        // perform the delete
        do {
            try container.viewContext.execute(deleteRequest)
            print("cleared!")
        } catch let error as NSError {
            print(error)
        }
    }
}

extension ViewController:UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.isEmpty == false {
            self.showResultButton.isUserInteractionEnabled = true
            self.showResultButton.alpha = 1.0
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        self.showResultButton.isUserInteractionEnabled = true
        self.showResultButton.alpha = 1.0
    }
}
