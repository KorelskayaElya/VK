//
//  FilesViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit


class FilesViewController: UIViewController{ //UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isSorted = true
    // получаем флаг сортировки
    func settingsViewControllerDidUpdateSortOrder(isSorted: Bool) {
        self.isSorted = isSorted
        // медленно обновляется
        self.table.reloadData()

    }
    // создаем путь
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    var initialPath: String?
    // создание ячейки
    var file: [String] {
        do {
            let fileManager = FileManager.default
            let fileNames = try fileManager.contentsOfDirectory(atPath: path)
            let isSorted = UserDefaults.standard.bool(forKey: "sort")
            let sortedFileNames = isSorted ? fileNames.sorted { $0 < $1 } : fileNames.sorted { $0 > $1 }
            return sortedFileNames

        } catch {
            print(error.localizedDescription)
            return []
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Файлы"
    }
    let table: UITableView = {
        let table = UITableView.init(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    func setupView() {
        // прикрепление таблицы
        view.addSubview(self.table)
        //table.dataSource = self
        //table.delegate = self
        NSLayoutConstraint.activate([
            self.table.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.table.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.table.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.table.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
        ])
        // Последний компонент пути приемника - будет отображаться при переходе
//        title = NSString(string: path).lastPathComponent
        
        // добавляем изображение
//        let img = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapPicker))
//        navigationItem.rightBarButtonItem = img
//
//        // кнопка добавить файл с содержимым
//        let file = UIBarButtonItem(image: UIImage(systemName: "plus.app.fill"), style: .done, target: self, action: #selector(tapBtn))
//        // кнопка добавить папку
//        let addDirectory = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(createDirectory))
//
//        navigationItem.rightBarButtonItems = [img, file, addDirectory]
//        navigationItem.rightBarButtonItem?.tintColor = .black
//        navigationController?.navigationBar.tintColor = .black
        
    }
    // создать папку
//    @objc func createDirectory() {
//        let alert = UIAlertController(title: "Create new folder", message: nil, preferredStyle: .alert)
//        alert.addTextField { (textField) in
//            textField.placeholder = "Folder name"
//        }
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [self] _ in
//            guard let textField = alert.textFields?[0].text else {return}
//            var newDirectoryURL: URL
//            // чтобы при переходе по папкам путь менялся
//            if let initialPath = initialPath {
//                newDirectoryURL = URL(fileURLWithPath: initialPath).appendingPathComponent(textField)
//            } else {
//               // newDirectoryURL = getDocumentsDirectory().appendingPathComponent(textField)
//            }
//            do {
//                try FileManager.default.createDirectory(atPath: newDirectoryURL.path, withIntermediateDirectories: false)
//                self.table.reloadData()
//            } catch {
//                print("createDirectory error: \(error.localizedDescription)")
//            }
//        }))
//        self.present(alert, animated: true, completion: nil)
//
//    }
    // запускаем пикер изображения
//    @objc func tapPicker() {
       // ImagePicker.defaultPicker.getImage(in: self)
  //  }
    // запускаем пикер текста
//    @objc func tapBtn() {
//        TextPicker.defaultPicker.getText(showPickerIn: self, title: "Create file", message: "Enter filename") {
//            text1, text2 in
//            let filePath = self.path + "/" + text1
//            let fileData = text2.data(using:.utf8)
//            do {
//                try fileData?.write(to:URL(filePath: filePath))
//            } catch {
//                print(error)
//            }
//            self.table.reloadData()
//        }
//    }
//    // количество ячеек
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return file.count
//    }
//    // размер ячейки
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
    // кнопка для переменования файлов и папок - не работает из-за того что массив свойство
   // @objc func buttonTapped(_ sender: UIButton) {
//        guard let cell = sender.closestParent(of: UITableViewCell.self) else {
//               return
//           }
//           guard let indexPath = table.indexPath(for: cell) else {
//               return
//           }
//        // Получаем текущее значение названия ячейки
//        let currentName = cell.textLabel?.text ?? ""
        
        // Создаем алерт с TextPicker
//        let alert = UIAlertController(title: "Введите новое название", message: nil, preferredStyle: .alert)
//        alert.addTextField { textField in
//            // Настраиваем TextPicker
//            textField.text = currentName
//        }
//
//        // Добавляем действия для сохранения и отмены изменений
//        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
//            // Проверяем, что новое название ячейки уникально
//            if self.file.contains(currentName) {
//                // Если название уже используется, показываем сообщение об ошибке
//                let errorAlert = UIAlertController(title: "Ошибка", message: "Ячейка с таким названием уже существует", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
//                errorAlert.addAction(okAction)
//                self.present(errorAlert, animated: true, completion: nil)
//            } else {
//                // Обновляем название ячейки в таблице
//                // не работает кнопка замены имени файла так как тут свойство а не переменная
//                // не знаю как исправить
//                //self.file[indexPath.row] = currentName
//                self.table.reloadRows(at: [indexPath], with: .automatic)
//            }
//        }
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//
//        // Показываем алерт
//        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        //let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // название файлов
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), for: .normal)
//        //button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//        button.frame = CGRect(x: cell.frame.width - 40, y: 10, width: 150, height: cell.frame.height)
//        cell.contentView.addSubview(button)
//
//        //cell.textLabel?.text = String(file[indexPath.row].prefix(10))
//        cell.backgroundColor = .systemBackground
//        var objcBool: ObjCBool = false
//        FileManager.default.fileExists(atPath: path + "/" + file[indexPath.row], isDirectory: &objcBool)
//        if objcBool.boolValue {
//            if let detailTextLabel = cell.detailTextLabel {
//                detailTextLabel.text = "Folder"
//            }
//        } else {
//            if let detailTextLabel = cell.detailTextLabel {
//                detailTextLabel.text = "File"
//            }
//        }
//        // путь к изображению
//        let imagePath = path + "/" + file[indexPath.row]
//        // добавить изображение
//        cell.imageView?.image = UIImage(contentsOfFile: imagePath)
        return cell
    }
    // для удаления ячейки
 //   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // путь удаления
//            let deletePath = path + "/" + file[indexPath.row]
//            // удалить изображение
//            try? FileManager.default.removeItem(atPath: deletePath)
//            // удаление ячейки
//            table.deleteRows(at: [indexPath], with: .middle)
//        }
  //  }
//    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> UITableViewCell {
//        let selectedPath = path + "/" + file[indexPath.row]
//        var objcBool: ObjCBool = false
//        FileManager.default.fileExists(atPath: path + "/" + file[indexPath.row], isDirectory: &objcBool)
//        if objcBool.boolValue {
//            let imageViewController = ImageViewController()
//            imageViewController.path = selectedPath
//            imageViewController.initialPath = selectedPath
//            navigationController?.pushViewController(imageViewController, animated: true)
//        } else {
//            if FileManager.default.fileExists(atPath: selectedPath), let contents = try? String(contentsOfFile: selectedPath) {
//                let textViewController = TextViewController(fileContents: contents)
//                navigationController?.pushViewController(textViewController, animated: true)
//            } else if let image = UIImage(contentsOfFile: selectedPath) {
//                   let dataViewController = DataViewController()
//                   dataViewController.image = image
//                   dataViewController.title = "Image Details"
//                   navigationController?.pushViewController(dataViewController, animated: true)
//            }
      //  }
        // не знаю как скрывать такие файлы
//        if file[indexPath.row] == "default.re" {
//            return UITableViewCell()
//        } else {
//            return UITableViewCell()
//        }
  //  }

    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        guard let selectedImage = info[.originalImage] as? UIImage else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//        let imageURL = info[.imageURL] as! URL
//        // вернуть изображение
//        if let image = selectedImage.jpegData(compressionQuality: 1.0) {
//            do {
//                // не знаю как отображать тут пикер для ввода текста
//                let file = getDocumentsDirectory().appendingPathComponent(imageURL.lastPathComponent)
//                // записать название ячейки
//                try image.write(to: file)
//                // обновить таблицу
//                table.reloadData()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        dismiss(animated: true, completion: nil)
//    }
//    // Найдет и при необходимости создает указанный общий каталог в домене
//    private func getDocumentsDirectory() -> URL {
//        if let initialPath = initialPath {
//            return URL(fileURLWithPath: initialPath)
//        } else {
//            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//            return paths[0]
//        }
//    }
    
//}
// чтобы на ячейке можно было кликнуть кнопку изменить название
//extension UIView {
//    func closestParent<T: UIView>(of type: T.Type) -> T? {
//        var view: UIView? = self
//        while let currentView = view {
//            if let result = currentView as? T {
//                return result
//            }
//            view = currentView.superview
//        }
//        return nil
//    }
//}
