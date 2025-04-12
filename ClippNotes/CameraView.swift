

import SwiftUI


struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var onImagePicked: (UIImage) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.showsCameraControls = true
        picker.cameraOverlayView = context.coordinator.makeOverlay()
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func makeOverlay() -> UIView {
            let overlay = UIView(frame: UIScreen.main.bounds)
            overlay.backgroundColor = .clear
            overlay.isUserInteractionEnabled = false // allow touches through

            let ghostFrame = UIView()
            ghostFrame.layer.borderColor = UIColor.white.cgColor
            ghostFrame.layer.borderWidth = 2
            ghostFrame.layer.cornerRadius = 20
            ghostFrame.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            ghostFrame.translatesAutoresizingMaskIntoConstraints = false

            overlay.addSubview(ghostFrame)

            NSLayoutConstraint.activate([
                ghostFrame.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                ghostFrame.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
                ghostFrame.widthAnchor.constraint(equalTo: overlay.widthAnchor, multiplier: 0.8),
                ghostFrame.heightAnchor.constraint(equalTo: overlay.heightAnchor, multiplier: 0.4)
            ])

            return overlay
        }
    }
}
