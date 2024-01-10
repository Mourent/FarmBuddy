//
//  PuzzlePage.swift
//  AFL3_MobCom
//
//  Created by MacBook Pro on 04/12/23.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation

struct PuzzlePiece: Identifiable {
    let id = UUID()
    var image: UIImage
    var currentPosition: CGPoint
    var correctPosition: CGPoint
    var size: CGSize
    var isCorrectlyPlaced: Bool = false // Indicates if the piece is correctly placed
    var isHoveringOverBox: Bool = false
}

func sliceImage(image: UIImage, intoRows rowCount: Int, andColumns columnCount: Int) -> [UIImage] {
    let width = image.size.width / CGFloat(columnCount)
    let height = image.size.height / CGFloat(rowCount)
    var images: [UIImage] = []
    
    for row in 0..<rowCount {
        for column in 0..<columnCount {
            let x = CGFloat(column) * width
            let y = CGFloat(row) * height
            let rect = CGRect(x: x, y: y, width: width, height: height)
            
            if let cgImage = image.cgImage?.cropping(to: rect) {
                images.append(UIImage(cgImage: cgImage))
            }
        }
    }
    
    return images
}

//struct CorrectModal: View{
//    @State private var heightLayar = UIScreen.main.bounds.height
//    @State private var widthLayar = UIScreen.main.bounds.width
//    @Binding var displayMode: DisplayMode
//
//    var body: some View{
//        ZStack{
//            Image("board")
//                .resizable()
//                .scaledToFit()
//                .scaleEffect(0.5)
//
//        Button {
//            displayMode = .home
//        } label: {
//            Image("next")
//                .resizable()
//                .scaledToFit()
//                .scaleEffect(0.25)
//        }
//        .position(CGPoint(x: widthLayar * 0.51, y: heightLayar * 0.57))
//
//        Text("Next")
//            .foregroundColor(.black)
//            .font(.custom("PaytoneOne-Regular", size: 50))
//            .position(CGPoint(x: widthLayar * 0.5, y: heightLayar * 0.42))
//        Text("Correct")
//            .foregroundColor(.white)
//            .font(.custom("PaytoneOne-Regular", size: 50))
//            .position(CGPoint(x: widthLayar * 0.50, y: heightLayar * 0.275))
//        }
//    }
//}

struct PuzzlePage: View {
    @Binding var isMusicPlaying: Bool

    @State private var audioPlayers: AVAudioPlayer?
    
    private let rows = 3
    private let columns = 3
    
    @State private var puzzlePieces: [PuzzlePiece] = []
    @State private var imageSlices: [UIImage] = []
    
    @State private var heightLayar = UIScreen.main.bounds.height
    @State private var widthLayar = UIScreen.main.bounds.width
    
    private let imageSize = CGSize(width: 1194, height: 834) // Size of the reference image view
    @State private var hasWon: Bool = false
    
    @Binding var displayMode: DisplayMode
    
    @State private var activeDragOffset: CGSize = .zero
    @State private var activePieceID: UUID?
    
    private let boxWidth: CGFloat = 250
    private let boxHeight: CGFloat = 584
    private let boxPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width * 0.88, y: UIScreen.main.bounds.height * 0.55) // Adjust as necessary
    
    
    @State private var selectedPieceID: UUID?
    
    private let scaleEffectInBox: CGFloat = 0.7 // The scale for pieces inside the box
    private let scaleEffectNormal: CGFloat = 1.0 // The normal scale for pieces
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack{
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.55))
                    .edgesIgnoringSafeArea(.all)
                
                Button {
                    displayMode = .home
                } label: {
                    Image("panah")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width:100,height:80)
                .position(CGPoint(x: widthLayar * 0.05, y: heightLayar * 0.05))
                
                Button {
                    //                isStartActive = true
                    toggleMusic()
                } label: {
                    Image(isMusicPlaying ? "lagu" : "lagu")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width:100,height:80)
                .position(CGPoint(x: widthLayar * 0.95, y: heightLayar * 0.1))
                
                Image("puzzle-1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 836, height: 584) // Image size without the border
                    .padding(10) // Space for the border
                    .background(Color.brown) // Border color
                    .position(CGPoint(x: widthLayar * 0.4, y: heightLayar * 0.55))
                
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.85))
                    .frame(width: 836, height: 584)
                    .position(CGPoint(x: widthLayar * 0.4, y: heightLayar * 0.55))
                
                
                
                
                // box for pieces
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.8))
                    .frame(width: 250, height: 584)
                    .border(Color.white, width: 6)
                    .position(CGPoint(x: widthLayar * 0.88, y: heightLayar * 0.55))
                
                Image("cowo")
                    .position(CGPoint(x: widthLayar * 0.9, y: heightLayar * 0.92))
                
                ForEach(puzzlePieces, id: \.id) { piece in
                    Circle()
                        .fill(Color.green.opacity(0.5))
                        .frame(width: 30, height: 30) // Size of the marker
                        .position(piece.correctPosition)
                }
                ForEach($puzzlePieces) { $piece in
                    Image(uiImage: piece.image)
                        .resizable()
                        .frame(width: piece.size.width, height: piece.size.height)
                        .zIndex(piece.isCorrectlyPlaced ? 0 : (piece.id == selectedPieceID ? 2 : 1)) // Adjust zIndex based on state
                        .scaleEffect(piece.isHoveringOverBox ? scaleEffectInBox : scaleEffectNormal)
                        .animation(.easeInOut, value: piece.isHoveringOverBox)
                        .position(piece.currentPosition)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if piece.isCorrectlyPlaced {
                                        // Don't move the piece if it's already in the correct position
                                        return
                                    }
                                    else{
                                        selectedPieceID = piece.id
                                        orderPieces()
                                    }
                                    if activePieceID == nil { // Check if no piece is being dragged
                                        activePieceID = piece.id
                                        activeDragOffset = CGSize(
                                            width: piece.currentPosition.x - gesture.location.x,
                                            height: piece.currentPosition.y - gesture.location.y
                                        )
                                    }
                                    if activePieceID == piece.id {
                                        // Apply the offset to the current drag location
                                        piece.currentPosition = CGPoint(
                                            x: gesture.location.x + activeDragOffset.width,
                                            y: gesture.location.y + activeDragOffset.height
                                        )
                                    }
                                    let newPosX = gesture.location.x + activeDragOffset.width
                                    let newPosY = gesture.location.y + activeDragOffset.height
                                    
                                    let isInBox = newPosX > (widthLayar * 0.88) - (boxWidth / 2) &&
                                    newPosX < (widthLayar * 0.88) + (boxWidth / 2) &&
                                    newPosY > (heightLayar * 0.55) - (boxHeight / 2) &&
                                    newPosY < (heightLayar * 0.55) + (boxHeight / 2)
                                    
                                    if isInBox {
                                        piece.isHoveringOverBox = true
                                    } else {
                                        piece.isHoveringOverBox = false
                                    }
                                }
                                .onEnded { _ in
                                    activePieceID = nil // Clear the active piece ID
                                    activeDragOffset = .zero // Reset the drag offset
                                    // Check for snapping to the correct position
                                    if abs(piece.currentPosition.x - piece.correctPosition.x) < 20 &&
                                        abs(piece.currentPosition.y - piece.correctPosition.y) < 20 {
                                        if !piece.isCorrectlyPlaced { // Check if not already placed correctly
                                            piece.isCorrectlyPlaced = true // Mark as correctly placed
                                            playSound(soundName: "capture", soundType: "mp3") // Play sound only when snapping to correct place
                                        }
                                        piece.currentPosition = piece.correctPosition
                                        checkWinCondition()
                                        
                                    }
                                    else {
                                        // Check if the piece is released inside the box
                                        let isInBox = piece.currentPosition.x > (widthLayar * 0.88) - (boxWidth / 2) &&
                                        piece.currentPosition.x < (widthLayar * 0.88) + (boxWidth / 2) &&
                                        piece.currentPosition.y > (heightLayar * 0.55) - (boxHeight / 2) &&
                                        piece.currentPosition.y < (heightLayar * 0.55) + (boxHeight / 2)
                                        
                                        if isInBox {
                                            // If released inside the box, set the hovering state and possibly scale down
                                            piece.isHoveringOverBox = true
                                            // Here you may want to adjust the position within the box or trigger an animation
                                            orderPieces()
                                        } else {
                                            // If released outside the box, ensure it is not in a hovered state
                                            piece.isHoveringOverBox = false
                                        }
                                    }
                                }
                        )
                    if hasWon {
                        
                        ZStack{
                            Image("board")
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.5)
                            
                            Button {
                                displayMode = .DigFruit
                            } label: {
                                Image("next")
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(0.25)
                            }
                            .position(CGPoint(x: widthLayar * 0.51, y: heightLayar * 0.57))
                            
                            Text("Next")
                                .foregroundColor(.black)
                                .font(.custom("PaytoneOne-Regular", size: 50))
                                .position(CGPoint(x: widthLayar * 0.5, y: heightLayar * 0.42))
                            Text("Correct")
                                .foregroundColor(.white)
                                .font(.custom("PaytoneOne-Regular", size: 50))
                                .position(CGPoint(x: widthLayar * 0.50, y: heightLayar * 0.275))
                        }
                        
                    }
                }
            }
            .onAppear {
                // Load the full puzzle image
                if let fullPuzzleImage = UIImage(named: "puzzle-1") {
                    let slicedImages = sliceImage(image: fullPuzzleImage, intoRows: rows, andColumns: columns)
                    createPuzzlePieces(slicedImages: slicedImages, geometry: geometry)
                    randomlyDisplacePieces(geometry: geometry)
                }
            }
        }
        
    }
    
    func playSound(soundName: String, soundType: String) {
        if let path = Bundle.main.path(forResource: soundName, ofType: soundType) {
            do {
                audioPlayers = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayers?.play()
            } catch {
                print("Could not find and play the sound file.")
            }
        }
    }
    private func orderPieces() {
        // The available height needs to account for the space between pieces.
        let spacing: CGFloat = 10 // Spacing between pieces
        let totalSpacing = spacing * CGFloat(puzzlePieces.count - 1) // Total spacing is spacing times the number of gaps between pieces
        let availableHeight = boxHeight - totalSpacing // Available height for all pieces
        let pieceHeight = availableHeight / CGFloat(puzzlePieces.count) // Height for each piece
        
        var yOffset: CGFloat = (boxPosition.y - (boxHeight / 2.3)) + (pieceHeight) // Start at the top of the box
        
        for index in 0..<puzzlePieces.count {
            if puzzlePieces[index].isHoveringOverBox && !puzzlePieces[index].isCorrectlyPlaced {
                let xPosition = boxPosition.x // Center of the box horizontally
                puzzlePieces[index].currentPosition = CGPoint(x: xPosition, y: yOffset)
                yOffset += (pieceHeight * 2.4 + spacing) // Move the yOffset down for the next piece including the spacing
            }
        }
    }
    
    
    
    
    private func checkWinCondition() {
        // Check if all pieces are in the correct position
        let allPiecesCorrect = puzzlePieces.allSatisfy { piece in
            abs(piece.currentPosition.x - piece.correctPosition.x) < 20 &&
            abs(piece.currentPosition.y - piece.correctPosition.y) < 20
        }
        if allPiecesCorrect {
            print("Puzzle completed!")
            hasWon = true
        }
    }
    
    private func randomlyDisplacePieces(geometry: GeometryProxy) {
        guard puzzlePieces.count >= 3 else { return }
        
        // Randomly pick 5 pieces to not be in the correct position
        var indices = Set<Int>()
        while indices.count < 3 {
            indices.insert(Int.random(in: 0..<puzzlePieces.count))
        }
        
        for i in 0..<puzzlePieces.count {
            if indices.contains(i) {
                // These pieces will not be in the correct position
                // Place them at the bottom of the screen or in another area where they are visible
                let xOffset = CGFloat.random(in: 0...geometry.size.width - puzzlePieces[i].size.width)
                let yOffset = geometry.size.height - puzzlePieces[i].size.height - 50 // Adjust the offset as needed
                puzzlePieces[i].currentPosition = CGPoint(x: xOffset, y: yOffset)
                puzzlePieces[i].isHoveringOverBox = true
                puzzlePieces[i].isCorrectlyPlaced = false
            } else {
                // These pieces will be in the correct position
                puzzlePieces[i].currentPosition = puzzlePieces[i].correctPosition
                puzzlePieces[i].isCorrectlyPlaced = true
            }
        }
        orderPieces()
        
    }
    
   
    
    private func createPuzzlePieces(slicedImages: [UIImage], geometry: GeometryProxy) {
        // Define the size of the puzzle area as seen in the simulator screenshot
        let puzzleAreaWidth: CGFloat = 836 // The width of the puzzle area
        let puzzleAreaHeight: CGFloat = 584 // The height of the puzzle area
        
        // Calculate the scale factor of the puzzle area compared to the original image size
        let scaleFactorWidth = puzzleAreaWidth / imageSize.width
        let scaleFactorHeight = puzzleAreaHeight / imageSize.height
        
        // Calculate the size of each puzzle piece based on the scale factor
        let pieceWidth = (imageSize.width / CGFloat(columns)) * scaleFactorWidth
        let pieceHeight = (imageSize.height / CGFloat(rows)) * scaleFactorHeight
        let pieceSize = CGSize(width: pieceWidth, height: pieceHeight)
        
        // Calculate the offset of the puzzle area within the simulator screen
        let offsetX = widthLayar * 0.4 - puzzleAreaWidth / 2
        let offsetY = heightLayar * 0.55 - puzzleAreaHeight / 2
        
        for (index, image) in slicedImages.enumerated() {
            let row = index / columns
            let column = index % columns
            
            // Calculate the correct position for each piece
            let correctPositionX = offsetX + pieceWidth * CGFloat(column) + pieceWidth / 2
            let correctPositionY = offsetY + pieceHeight * CGFloat(row) + pieceHeight / 2
            
            // Print the correct position for debugging
            print("Piece \(index) correct position: (\(correctPositionX), \(correctPositionY))")
            
            let puzzlePiece = PuzzlePiece(
                image: image,
                currentPosition: CGPoint(x: geometry.size.width * 0.9, y: geometry.size.height * 0.1), // Start position off-screen
                correctPosition: CGPoint(x: correctPositionX, y: correctPositionY),
                size: pieceSize
            )
            
            puzzlePieces.append(puzzlePiece)
        }
    }
    
    
    func toggleMusic() {
        if isMusicPlaying {
            audioPlayer?.stop()
        } else {
            audioPlayer?.play()
        }
        isMusicPlaying.toggle()
    }
}

//struct puzzle_previews: PreviewProvider {
//    @State static var displayMode: DisplayMode = .puzzle
//
//    static var previews: some View {
//        PuzzlePage(displayMode: $displayMode)
//    }
//}


