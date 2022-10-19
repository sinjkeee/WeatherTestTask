//
//  ListTableVC.swift
//  WeatherTestTask
//
//  Created by Vladimir Sekerko on 10.10.2022.
//

import UIKit

class ListTableVC: UITableViewController {
    
    private var citiesArray = [Weather]()
    private var filterCityArray = [Weather]()
    private var nameCitiesArray = ["Москва", "Минск", "Одесса", "Гомель", "Ставрополь", "Уфа", "Сочи", "Томск", "Новосибирск", "Пенза"]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCitiesWeather()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addCitiesWeather() {
        if citiesArray.isEmpty {
            citiesArray = Array(repeating: Weather(), count: nameCitiesArray.count)
        }
        
        getCityWeather(cities: nameCitiesArray) { [weak self] (index, weather) in
            guard let self = self else { return }
            self.citiesArray[index] = weather
            self.citiesArray[index].name = self.nameCitiesArray[index]
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addNewCity(_ sender: UIBarButtonItem) {
        showAlert(name: "Город", placeholder: "Введите название города") { city in
            self.nameCitiesArray.append(city)
            self.citiesArray.append(Weather())
            self.addCitiesWeather()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filterCityArray.count : citiesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else { return UITableViewCell() }
        
        let weather = isFiltering ? filterCityArray[indexPath.row] : citiesArray[indexPath.row]
        listCell.configure(withWeather: weather)
        
        return listCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DescriptionVC") as? DescriptionVC else { return }
        let cityWeather = isFiltering ? filterCityArray[indexPath.row] : citiesArray[indexPath.row]
        detailViewController.weatherModel = cityWeather
        present(detailViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, completionHandler in
            
            let editingRow = self.nameCitiesArray[indexPath.row]
            if let index = self.nameCitiesArray.firstIndex(of: editingRow) {
                self.isFiltering ? self.filterCityArray.remove(at: index) : self.citiesArray.remove(at: index)
            }
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: - UISearchResultsUpdating
extension ListTableVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filterCityArray = citiesArray.filter({ city in
            city.name.uppercased().contains(searchText.uppercased())
        })
        tableView.reloadData()
    }
}
