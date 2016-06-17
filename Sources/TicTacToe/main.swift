//
//  main.swift
//  TikTakToe
//
//  Created by Raul Ferreira on 3/17/16.
//  Copyright © 2016 FCUP. All rights reserved.
//

import Foundation

// VAR to store number of Nodes
var totalNodes = 0

// VARS to store info about whether to print debug stuff or not
var DEBUG = false
var FULLDEBUG = false

processCmdLineArgs()

enum Turn {
    case human
    case computer
}

let emptyChar: Character = " "

let initialGameTable = Array(repeating: Array(repeating: emptyChar,count: 3),count: 3)

var game = State(table: initialGameTable, depth: 0, utility: 0)

let humanSymbol: Character
let computerSymbol: Character


//---Parse which Char Symbol the user inputed and deduce the Char for the Computer from it---//
var charFromUser: Character?

repeat {
    charFromUser = readCharacterFromUser()
} while charFromUser == nil

humanSymbol = charFromUser!

if charFromUser == "O"{
    computerSymbol = "X"
} else {
    computerSymbol = "O"
}

//--------Parse who should play first------//

var goesFirst = whoGoesFirst()
while goesFirst == nil {
    goesFirst = whoGoesFirst()
}

var whosTurn: Turn

if goesFirst == "P"{
    whosTurn = Turn.human
} else {
    whosTurn = Turn.computer
}

//--------Parse Alpha-Beta Info------//

var alphaBetaInfoFromUser = readIsAlphaBeta()
while alphaBetaInfoFromUser == nil {
    alphaBetaInfoFromUser = readIsAlphaBeta()
}

var alphaBeta = false
if let algoInfo = alphaBetaInfoFromUser {
    if algoInfo == "Y"{
        alphaBeta = true
    }
}

//Infite loop where the playing of the Tic Tac Toe actually happens
while true {

    game.prettyPrint()

    if DEBUG {
        print("Nodes generated so far \(totalNodes)")
    }

    let (bool, winnerSymbol) = checkWinner(game.table)

    if bool {
        print("👏👏👏👏👏👏")
        let winnerString = whoWon(winnerSymbol)
        print (winnerString)
        print("👏👏👏👏👏👏")
        exit(0)
    }

    // If a winner can't be found but the the table is full declare a draw
    if isFull(game.table) {
        print("It's a DRAW!!")
        exit(0)
    }


    if whosTurn == Turn.human {

        // The table for the next State starts out as a copy of the table of the current State
        var nextGameTable = game.table

        humanInputInfiniteLoop: while true {

            var inputTuple = readPositionsFromUser()

            while inputTuple == nil {
                print()
                print("Pay attention!")
                print()
                sleep(1)
                inputTuple = readPositionsFromUser()
            }

            let (row, col) = inputTuple!

            if nextGameTable[row][col] != " " {
                print()
                print("Can't play on a position that has already been chosen")
                print()
                sleep(1)
                continue humanInputInfiniteLoop
            } else {
                nextGameTable[row][col] = humanSymbol
                break humanInputInfiniteLoop
            }



        }

        game = State(table: nextGameTable, depth: game.depth+1, utility: getUtility(game.table))


    }

    if whosTurn == Turn.computer {

        let start = NSDate()

        //        computerInputInfiniteLoop: while true{
        //
        //            let row = Int(arc4random_uniform(3))
        //            let col = Int(arc4random_uniform(3))
        //
        //            if gameTable[row][col] != " " {
        //                print()
        //                print("Can't play on a position that has already been chosen")
        //                print()
        //                sleep(1)
        //                continue computerInputInfiniteLoop
        //            } else {
        //                gameTable[row][col] = computerSymbol
        //                break computerInputInfiniteLoop
        //            }
        //
        //        }

        if alphaBeta {
            game = ALPHA_BETA_DECISION(game)
        } else {
            game = MINIMAX_DECISION(game)
        }

        // THIS IS A SILLY TEMP FIX
        let end = Date()
        let timeInterval = abs(start.timeIntervalSinceNow)

        if DEBUG {
            print("Elapsed Time: \(timeInterval) seconds")
        }

    }


    // Give the next turn to the player who didn't play this time
    switch whosTurn {
    case Turn.human:
        whosTurn = Turn.computer
    case Turn.computer:
        whosTurn = Turn.human
    }
    
}
