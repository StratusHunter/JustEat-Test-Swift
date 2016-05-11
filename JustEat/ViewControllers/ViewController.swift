//
//  ViewController.swift
//  JustEat
//
//  Created by Terence Baker on 11/05/2016.
//  Copyright (c) 2016 Bulb Studios Ltd. All rights reserved.
//


import UIKit
import RxCocoa
import RxSwift
import RxAlamofire
import ObjectMapper

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private let bag = DisposeBag()
    private var resturantArray = Variable<[Resturant]>([])

    override func viewDidLoad() {

        super.viewDidLoad()

        //Adaptive cell height
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.rx_setDelegate(self)

        performUIBindings()
    }

    private func searchWithPostcode(postcode: String) {

        guard let observer = JustEatService.resturantSearchObservable(postcode) else {

            return
        }

        observer.observeOn(MainScheduler.instance)
        .subscribe(onNext: {
            [unowned self] json in

            self.parseJSON(json)
        })
        .addDisposableTo(bag)
    }

    private func parseJSON(json: AnyObject) {

        guard let resturantJSON = json["Restaurants"], let resturants = Mapper<Resturant>().mapArray(resturantJSON) else {

            print("Error parsing JSON")
            return
        }

        self.setResturantArray(resturants)
    }

    private func clearSearch() {

        setResturantArray([Resturant]())
    }

    private func setResturantArray(resturants: [Resturant]) {

        self.resturantArray.value.removeAll(keepCapacity: false)
        self.resturantArray.value += resturants
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        super.touchesBegan(touches, withEvent: event)
        searchBar.resignFirstResponder()
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {

        searchBar.resignFirstResponder()
    }

}

//UI Bindings using Rx

extension ViewController {

    func performUIBindings() {

        bindArrayToTableView()
        subscribeSearchChange()
    }

    private func bindArrayToTableView() {

        //Creates a binding between the array having values and the tableview being shown/hidden
        resturantArray.asObservable()
        .map {
            $0.isEmpty
        }
        .bindTo(tableView.rx_hidden)
        .addDisposableTo(bag)

        //Creates a binding to the array and the tableview to load the cells
        resturantArray.asObservable()
        .bindTo(tableView.rx_itemsWithCellIdentifier(R.reuseIdentifier.resturantCell.identifier, cellType: ResturantCell.self)) {
            (_, element, cell) in

            cell.setupWithResturant(element)
        }
        .addDisposableTo(bag)
    }

    private func subscribeSearchChange() {

        //Dismiss keyboard when search is pressed
        searchBar.rx_searchButtonClicked
        .subscribeNext {
            [unowned self] in

            self.searchBar.resignFirstResponder()
        }

        //Use rx to monitor text changes in the search bar. Avoids hammering the API using the throttle command and will not perform a search on the same text input.
        searchBar.rx_text
        .throttle(0.4, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .subscribeNext {
            [unowned self] (postcode: String) in

            postcode.characters.count == 0 ? self.clearSearch() : self.searchWithPostcode(postcode)
        }
        .addDisposableTo(bag)
    }
}
