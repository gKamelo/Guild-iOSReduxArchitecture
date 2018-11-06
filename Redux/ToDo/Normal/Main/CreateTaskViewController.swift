//
//  CreateTaskViewController.swift
//  ToDo
//
//  Copyright © 2017 Oink oink. All rights reserved.
//

import UIKit
import ReSwift

final class CreateTaskViewController: UIViewController, UITextViewDelegate, DatePickerViewControllerDelegate, StoreSubscriber {

    private struct Constant {

        static let minimalDescriptionHeight: CGFloat = 200
    }

    @IBOutlet private var scrollView: UIScrollView!

    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var descriptionTextView: UITextView!

    @IBOutlet private var dueDateButton: UIButton!
    @IBOutlet private var createButton: UIButton!
    @IBOutlet private var loaderIndicator: UIActivityIndicatorView!

    @IBOutlet private var textViewHeightConstraint: NSLayoutConstraint!

    private let networkServie = NetworkService(baseURL: AppConstant.networkURL)

    private let dateFormatter = DateFormatter()
    private var currentDueDate: Date?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateFormatter.dateFormat = "dd/MM/yyyy"

        self.updateDescritpionField()
        self.updateCreateAvailablity()
        self.updateDateField()

        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { state in
            state.select { $0.taskCreationViewState }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        store.unsubscribe(self)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            self.updateDescritpionField()
        }
    }

    private func updateDescritpionField() {
        self.textViewHeightConstraint.constant = max(Constant.minimalDescriptionHeight, self.descriptionTextView.contentSize.height)
        self.descriptionTextView.contentOffset = .zero
    }

    private func updateCreateAvailablity() {
        self.createButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true)
    }

    private func updateDateField() {
        if let dueDate = self.currentDueDate {
            self.dueDateButton.setTitle(self.dateFormatter.string(from: dueDate), for: .normal)
        } else {
            self.dueDateButton.setTitle("Set due date", for: .normal)
        }
    }

    private func resetFields() {
        self.titleTextField.text = ""
        self.descriptionTextView.text = ""
        self.currentDueDate = nil
        self.dueDateButton.setTitle("Set due date", for: .normal)

        self.updateCreateAvailablity()
    }

    // MARK: - StoreSubscriber
    func newState(state: TaskCreationViewState) {
        switch state {
            case .creating:
                self.loaderIndicator.startAnimating()
                self.createButton.isHidden = true
                self.titleTextField.isEnabled = false
                self.descriptionTextView.isEditable = false
            case .ready:
                self.loaderIndicator.stopAnimating()
                self.createButton.isHidden = false
                self.titleTextField.isEnabled = true
                self.descriptionTextView.isEditable = true
        }
    }

    // MARK: - Keyboard
    @objc private func onKeyboardShowNotification(notification: Notification) {
        guard let keyboardHeiht = (notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect)?.height else { return }

        self.scrollView.contentInset.bottom = keyboardHeiht
        self.scrollView.scrollIndicatorInsets.bottom = keyboardHeiht
    }

    @objc private func onKeyboardHideNotification(notification: Notification) {
        self.scrollView.contentInset.bottom = 0
        self.scrollView.scrollIndicatorInsets.bottom = 0
    }

    // MARK: - Actions
    @IBAction func onDueDateAction(_ sender: UIButton) {
        let pickerController = DatePickerViewController()

        pickerController.delegate = self

        self.present(pickerController, animated: true, completion: nil)
    }

    @IBAction private func onCreateTask(_ sender: UIButton) {
        guard let title = self.titleTextField.text else { return }

        let description = self.descriptionTextView.text.isEmpty ? nil : self.descriptionTextView.text
        let createTaskAsyncAction = CreateTaskAsyncAction(networkService: self.networkServie, title: title, description: description, dueDate: self.currentDueDate)

        store.dispatch(createTaskAsyncAction.create())
    }

    @IBAction private func onTitleChangeAction(_ sender: UITextField) {
        self.updateCreateAvailablity()
    }

    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        self.updateDescritpionField()
    }

    // MARK: - DatePickerViewControllerDelegate
    func datePicker(_ controller: DatePickerViewController, with newDate: Date?) {
        controller.dismiss(animated: true, completion: nil)

        self.currentDueDate = newDate

        self.updateDateField()
    }
}
