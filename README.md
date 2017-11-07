# One Drive Picker

Is a File picker selector to OneDrive.


## Install

Clone project and run `pod install`

* Copy the assets to your project
* Copy folder ODPicker to your project
* Use de pods in Podfile


## Use

Create the object


````swift
var odPicker:ODPicker!

let key = "YOUR APP ID"
    
self.odPicker = ODPicker(applicationId: key)
self.odPicker.delegate = self

// To open picker
let viewController = self.odPicker.viewController()
self.present(viewController, animated: true) {

}
````

And implement delegate


````swift
extension ViewController: ODPickerDelegate {
    func onClose(selectedFiles: [ODPickerItem]) {
        print(selectedFiles)
    }
}
````