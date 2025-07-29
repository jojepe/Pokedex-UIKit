import UIKit

class PokedexViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let viewModel = PokedexViewModel()
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Pokédex"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureCollectionView()
        
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        configureSearchController()
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.presentErrorAlert(message: errorMessage)
            }
        }
        viewModel.fetchData()
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle:.alert)
        let retryAction = UIAlertAction(title: "Retry", style:.default) { [weak self] _ in
            self?.viewModel.fetchData()
        }
        alert.addAction(retryAction)
        alert.addAction(UIAlertAction(title: "OK", style:.cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemGray6
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self // O VC lida com as atualizações
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokémon"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension PokedexViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredPokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseIdentifier, for: indexPath) as! PokemonCell
        
        let pokemon = viewModel.filteredPokemons[indexPath.item]
        
        cell.configure(with: pokemon)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = viewModel.pokemons[indexPath.item]
        
        let detailVC = PokemonDetailViewController()
        detailVC.pokemon = selectedPokemon
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension PokedexViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        viewModel.filterPokemons(with: query)
    }
}
