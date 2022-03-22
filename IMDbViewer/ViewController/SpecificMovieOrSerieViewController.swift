//
//  SpecificMovieOrSerieViewController.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 9.03.2022.
//

import UIKit
import AVKit
import AVFoundation

class SpecificMovieOrSerieViewController: UIViewController {

    var id: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var plotInfoLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var durationOrSeasonsLabel: UILabel!
    @IBOutlet weak var trailerLabel: UILabel!
    @IBOutlet weak var trailerImageView: UIImageView!
    @IBOutlet weak var trailerPlayImage: UIImageView!
    @IBOutlet weak var trailerPlayButton: UIButton!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var metacriticRatingLabel: UILabel!
    @IBOutlet weak var themoviedbRatingLabel: UILabel!
    @IBOutlet weak var rottentomatoesRatingLabel: UILabel!
    @IBOutlet weak var similarsLabel: UILabel!
    @IBOutlet weak var similarsCollectionView: UICollectionView!
    
    var trailerVideoUrl: String?
    
    var starFilledButton: UIBarButtonItem?
    var starUnfilledButton: UIBarButtonItem?
    
    var castViewControllerHelper: CastCollectionViewHelper?
    var similarsViewControllerHelper: SimilarsCollectionViewHelper?
    
    let specificMovieOrSerieModel = SpecificMovieOrSerieModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIView()
        starFilledButton = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(removeFromFavorites(sender:)))
        starUnfilledButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(addToFavorites(sender:)))
        navigationItem.rightBarButtonItem = starUnfilledButton
        
        titleLabel.sizeToFit()
        releaseDateLabel.sizeToFit()
        plotLabel.sizeToFit()
        plotLabel.attributedText = NSMutableAttributedString(string: "Plot:", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        plotInfoLabel.sizeToFit()
        genresLabel.sizeToFit()
        castLabel.sizeToFit()
        castLabel.attributedText = NSMutableAttributedString(string: "Cast", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        directorLabel.sizeToFit()
        writerLabel.sizeToFit()
        durationOrSeasonsLabel.sizeToFit()
        trailerLabel.sizeToFit()
        trailerLabel.attributedText = NSMutableAttributedString(string: "Trailer", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        ratingsLabel.sizeToFit()
        ratingsLabel.attributedText = NSMutableAttributedString(string: "Ratings", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        imdbRatingLabel.sizeToFit()
        metacriticRatingLabel.sizeToFit()
        themoviedbRatingLabel.sizeToFit()
        rottentomatoesRatingLabel.sizeToFit()
        similarsLabel.sizeToFit()
        similarsLabel.attributedText = NSMutableAttributedString(string: "Similars", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        
        let flowLayout1 = UICollectionViewFlowLayout()
        flowLayout1.scrollDirection = .horizontal
        flowLayout1.itemSize = CGSize(width: 150, height: 250)
        castCollectionView.collectionViewLayout = flowLayout1
        castViewControllerHelper = CastCollectionViewHelper(viewController: self, collectionView: castCollectionView)
        castCollectionView.dataSource = castViewControllerHelper
        castCollectionView.delegate = castViewControllerHelper
        let cellNib1 = UINib(nibName: "DetailedCollectionViewCell", bundle: nil)
        castCollectionView.register(cellNib1, forCellWithReuseIdentifier: "detailedCollectionViewCell")
        
        let flowLayout2 = UICollectionViewFlowLayout()
        flowLayout2.scrollDirection = .horizontal
        flowLayout2.itemSize = CGSize(width: 150, height: 250)
        similarsCollectionView.collectionViewLayout = flowLayout2
        similarsViewControllerHelper = SimilarsCollectionViewHelper(viewController: self, collectionView: similarsCollectionView)
        similarsCollectionView.dataSource = similarsViewControllerHelper
        similarsCollectionView.delegate = similarsViewControllerHelper
        let cellNib2 = UINib(nibName: "DetailedCollectionViewCell", bundle: nil)
        similarsCollectionView.register(cellNib2, forCellWithReuseIdentifier: "detailedCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        specificMovieOrSerieModel.specificMovieOrSerieDelegate = self
        specificMovieOrSerieModel.getSpecificMovieOrSerie(id: id)
    }
    
    @IBAction func trailerPlayClicked(_ sender: UIButton) {
        guard let url = URL(string: trailerVideoUrl ?? "") else { return }
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
    }
    
    @objc private func addToFavorites(sender: AnyObject) {
        navigationItem.rightBarButtonItem = starFilledButton
    }
    
    @objc private func removeFromFavorites(sender: AnyObject) {
        navigationItem.rightBarButtonItem = starUnfilledButton
    }
    
    private func setTitle(title: String) {
        titleLabel.attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30.0)])
        navigationItem.title = title
    }
    
    private func setReleaseDate(releaseDate: String) {
        let attributedReleaseDateText = NSMutableAttributedString(string: "Release Date: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        let text = NSMutableAttributedString(string: releaseDate)
        attributedReleaseDateText.append(text)
        releaseDateLabel.attributedText = attributedReleaseDateText
    }
    
    private func setPlotInfo(plotInfo: String) {
        plotInfoLabel.text = plotInfo
    }
    
    private func setGenres(genres: String) {
        let attributedGenresText = NSMutableAttributedString(string: "Genres: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        let text = NSMutableAttributedString(string: genres)
        attributedGenresText.append(text)
        genresLabel.attributedText = attributedGenresText
    }
    
    private func setDirector(director: String) {
        let attributedDirectorText = NSMutableAttributedString(string: "Director: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        let text = NSMutableAttributedString(string: director)
        attributedDirectorText.append(text)
        directorLabel.attributedText = attributedDirectorText
    }
    
    private func setWriter(writer: String) {
        let attributedWriterText = NSMutableAttributedString(string: "Writer: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        let text = NSMutableAttributedString(string: writer)
        attributedWriterText.append(text)
        writerLabel.attributedText = attributedWriterText
    }
    
    private func setDuration(duration: String) {
        let attributedDurationText = NSMutableAttributedString(string: "Duration: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        let text = NSMutableAttributedString(string: "\(duration) minutes")
        attributedDurationText.append(text)
        durationOrSeasonsLabel.attributedText = attributedDurationText
    }
    
    private func setSeasons(seasons: String) {
        let attributedSeasonsText = NSMutableAttributedString(string: "Seasons: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        let text = NSMutableAttributedString(string: seasons)
        attributedSeasonsText.append(text)
        durationOrSeasonsLabel.attributedText = attributedSeasonsText
    }
    
    private func setCast(cast: [ActorListItemType]) {
        var data = [DetailedCollectionViewCellModel]()
        for castActor in cast {
            data.append(DetailedCollectionViewCellModel(id: castActor.id, imageUrl: castActor.image, name: castActor.name))
        }
        castViewControllerHelper?.updateData(data: data)
    }
    
    private func setTrailerImageUrl(trailerImageUrl: String) {
        let url = URL(string: trailerImageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.trailerImageView.image = UIImage(data: data!)
            }
        }
    }
    
    private func setTrailerVideoUrl(trailerVideoUrl: String) {
        self.trailerVideoUrl = trailerVideoUrl
    }
    
    private func setSimilars(similars: [MovieOrSerieListItemType]) {
        var data = [DetailedCollectionViewCellModel]()
        for similar in similars {
            data.append(DetailedCollectionViewCellModel(id: similar.id, imageUrl: similar.image, name: similar.title))
        }
        similarsViewControllerHelper?.updateData(data: data)
    }
    
    private func setImdbRating(rating: String) {
        imdbRatingLabel.text = rating
    }
    
    private func setMetacriticRating(rating: String) {
        metacriticRatingLabel.text = rating
    }
    
    private func setThemoviedbRating(rating: String) {
        themoviedbRatingLabel.text = rating
    }
    
    private func setRottentomatoesRating(rating: String) {
        rottentomatoesRatingLabel.text = rating
    }
    
    fileprivate func navigateToSpecificActor(id: String) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "specificActorViewController") as? SpecificActorViewController
        vc?.id = id
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    fileprivate func navigateToSpecificMovieOrSerie(id: String) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "specificMovieOrSerieViewController") as? SpecificMovieOrSerieViewController
        vc?.id = id
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension SpecificMovieOrSerieViewController: SpecificMovieOrSerieDelegate {
    func onSpecificMovieOrSerieReceived(specificMovieOrSerie: SpecificMovieOrSerieType) {
        DispatchQueue.main.async { [self] in
            setTitle(title: specificMovieOrSerie.title)
            setReleaseDate(releaseDate: specificMovieOrSerie.releaseDate)
            setPlotInfo(plotInfo: specificMovieOrSerie.plotInfo)
            setGenres(genres: specificMovieOrSerie.genres)
            setDirector(director: specificMovieOrSerie.director)
            setWriter(writer: specificMovieOrSerie.writer)
            if let duration = specificMovieOrSerie.duration {
                setDuration(duration: duration)
            }
            else if let seasons = specificMovieOrSerie.seasons {
                setSeasons(seasons: seasons)
            }
            setCast(cast: specificMovieOrSerie.cast)
            setTrailerImageUrl(trailerImageUrl: specificMovieOrSerie.trailerImageUrl)
            setTrailerVideoUrl(trailerVideoUrl: specificMovieOrSerie.trailerVideoUrl)
            setImdbRating(rating: specificMovieOrSerie.imdbRating)
            setMetacriticRating(rating: specificMovieOrSerie.metacriticRating)
            setThemoviedbRating(rating: specificMovieOrSerie.themoviedbRating)
            setRottentomatoesRating(rating: specificMovieOrSerie.rottentomatoesRating)
            setSimilars(similars: specificMovieOrSerie.similars)
        }
    }
}

class CastCollectionViewHelper: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let viewController: SpecificMovieOrSerieViewController
    let collectionView: UICollectionView
    var collectionViewData = [DetailedCollectionViewCellModel]()
    
    init(viewController: SpecificMovieOrSerieViewController, collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
    }
    
    func updateData(data: [DetailedCollectionViewCellModel]) {
        collectionViewData = data
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ViewConstants.spacingBetweenDetailedCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailedCollectionViewCell", for: indexPath) as? DetailedCollectionViewCell {
            let url = URL(string: collectionViewData[indexPath.row].imageUrl)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data!)
                }
            }
            cell.nameLabel.text = collectionViewData[indexPath.row].name
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController.navigateToSpecificActor(id: collectionViewData[indexPath.row].id)
    }
}

class SimilarsCollectionViewHelper: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let viewController: SpecificMovieOrSerieViewController
    let collectionView: UICollectionView
    var collectionViewData = [DetailedCollectionViewCellModel]()
    
    init(viewController: SpecificMovieOrSerieViewController, collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
    }
    
    func updateData(data: [DetailedCollectionViewCellModel]) {
        collectionViewData = data
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ViewConstants.spacingBetweenDetailedCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailedCollectionViewCell", for: indexPath) as? DetailedCollectionViewCell {
            let url = URL(string: collectionViewData[indexPath.row].imageUrl)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data!)
                }
            }
            cell.nameLabel.text = collectionViewData[indexPath.row].name
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController.navigateToSpecificMovieOrSerie(id: collectionViewData[indexPath.row].id)
    }
}
