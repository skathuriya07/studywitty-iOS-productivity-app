//
//  RecordNoteViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 29/05/21.
//
// to use lottie: https://www.youtube.com/watch?v=ZtIPsg07bb4 and
//  https://www.youtube.com/watch?v=1nzYysilBNo

import AVFoundation
import Lottie
import UIKit

class RecordNoteViewController: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    //MARK: - Outlets
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var dismissButton: UIButton!

    //MARK: - Properties

    var fromRecordNote: Bool!
    var session: String!
    var audioFileName: String!

    var isRecording: Bool = false
    var isPlaying: Bool = false
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    let helper = Helpers.sharedInstance
    var animation: AnimationView!
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    deinit {
        animationView = nil
    }

    func setupView() {
        //UI
        self.view.backgroundColor = .black.withAlphaComponent(0.4)

        databaseController = helper.getDataBaseController()

        recordView.layer.cornerRadius = 15
        recordView.layer.masksToBounds = true   //animation
        toggleButtons()

        stopButton.addBorder(side: .top, color: UIColor.systemGray6, width: 1)
        stopButton.layer.masksToBounds = true
        stopButton.tintColor = .black

        dismissButton.addBorder(side: .top, color: UIColor.systemGray6, width: 1)
        dismissButton.addBorder(side: .right, color: UIColor.systemGray6, width: 1)
        dismissButton.layer.masksToBounds = true
        dismissButton.tintColor = .black

        recordButton.centerButtonContent(5)
        recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
        recordButton.setImage(UIImage(systemName: "record.circle"), for: .selected)
        recordButton.adjustsImageWhenHighlighted = false
        recordButton.layer.borderWidth = 1
        recordButton.layer.borderColor = UIColor.systemGray6.cgColor
        recordButton.layer.cornerRadius = recordButton.frame.height/2
        recordButton.tintColor = .systemPink

        playButton.centerButtonContent(5)
        playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        playButton.setImage(UIImage(systemName: "play.circle"), for: .selected)
        playButton.adjustsImageWhenHighlighted = false
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.systemGray6.cgColor
        playButton.layer.cornerRadius = recordButton.frame.height/2
        playButton.tintColor = .systemBlue
    }

    func toggleButtons() {
        if fromRecordNote { //from when recording
            playButton.isHidden = true
            animation = AnimationView(name: "recordNote")
        } else {    //from view notes screen
            playButton.isHidden = false
            animation = AnimationView(name: "playNote")
        }
        showAnimation() //recording/play animation
        recordButton.isHidden = !playButton.isHidden
    }

    func showAnimation () {
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 0.5
        animation.frame = animationView.bounds
        animationView.addSubview(animation)
    }

    func generateAudioNoteUrl() -> URL{
        // to get filepath
        //https://www.hackingwithswift.com/example-code/system/how-to-find-the-users-documents-directory
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = filePath.first!
        audioFileName = UUID().uuidString
        return documentsDirectory.appendingPathComponent("\(audioFileName!).m4a")
    }

    func recordAudio() {
        let recordSession = AVAudioSession.sharedInstance()//Create recording session
        do {
            //category: play and record
            //https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder

            try recordSession.setCategory(.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try recordSession.setActive(true, options: .notifyOthersOnDeactivation)

            // Set up a high-quality recording session
            //default values
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: generateAudioNoteUrl(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            animation.play()
            isRecording = true
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }

    func saveRecording() {
    //actual file in the device memory, here we save name
        var nameTextField = UITextField()
        let alertController = UIAlertController(title: nil, message: "Provide a recording name", preferredStyle: .alert)
        let saveButton = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            self.databaseController?.createANote(nameTextField.text!, Date(), false, self.session, audioFileName)
            self.databaseController?.saveChanges()
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addTextField { textField in
            nameTextField = textField
            nameTextField.placeholder = "Type here..."
        }
        alertController.addAction(saveButton)
        alertController.view.tintColor = .black
        present(alertController, animated: true, completion: nil)
    }

    func stopRecording() {
        //https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder
        if isRecording {
            audioRecorder.stop()
            animation.stop()
            saveRecording()
        }
        isRecording = false
    }

    func stopPlaying() {
        //https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder
        if isPlaying {
            audioPlayer.stop()
            animation.stop()
        }
        isPlaying = false
    }

    func playRecordedNote() {
        //get the location where it is saved
        // https://www.hackingwithswift.com/forums/swiftui/avaudioplayerdelegate-swiftui/2872
        audioPlayer.delegate = self
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent("\(audioFileName!).m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay() //system defined
            audioPlayer.play()
            isPlaying = true
            animation.play()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    @IBAction func onRecordButtonDidClick(_ sender: Any) {
        if !isRecording {
            recordAudio()
        }
    }

    @IBAction func onStopButtonDidClick(_ sender: Any) {
        stopRecording()
        stopPlaying()
    }

    @IBAction func onPlayButtonDidClick(_ sender: Any) {
        if !isPlaying {
            playRecordedNote()
        }
    }

    @IBAction func onDismissDidClick(_ sender: Any) {
        if !isRecording {
            dismiss(animated: true, completion: nil)
        } else if isPlaying {
            stopPlaying()
            dismiss(animated: true, completion: nil)
        } else {
            helper.showConfirmationDialog("Info", "Recording is in progress, please stop recording and dismiss", displayOnController: self)
        }
    }
    //stops recording on phone disturbace
    //https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            stopRecording()
        } else {
            helper.showConfirmationDialog("Info", "Recording interrupted by system", displayOnController: self)
        }
    }

    //ends playing when phone inter
    //https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            stopPlaying()
        } else {
            helper.showConfirmationDialog("Info", "Interrupted by system due to some reason", displayOnController: self)
        }
    }
}
