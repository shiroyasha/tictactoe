

###
    state is an object that contains the board and player
     - board : array of length nine
        - 0 : x
        - 1 : y
        - 2 : nothing
     - player
        - 0 : x
        - 1 : y
###

class TicTacToeRules extends GameRules

    possibleMoves: (state) ->
        (i for i in [0..state.board.length] when state.board[i] is 2)
        
    makeMove: (state,action) ->
        b = state.board.slice(0)
        b[action] = state.player

        return { board : b, player: if state.player is 0 then 1 else 0 }


    wonGameTest: (state) ->
        check = (i, j, k, player) ->
            return (state.board[i] is player and state.board[j] is player and state.board[k] is player)

        niz1 = [ check(0, 1, 2, 0), check(3, 4, 5, 0), check(6, 7, 8, 0), \
                 check(0, 3, 6, 0), check(1, 4, 7, 0), check(2, 5, 8, 0), \
                 check(0, 4, 8, 0), check(2, 4, 6, 0) ]

        niz2 = [ check(0, 1, 2, 1), check(3, 4, 5, 1), check(6, 7, 8, 1), \
                 check(0, 3, 6, 1), check(1, 4, 7, 1), check(2, 5, 8, 1), \
                 check(0, 4, 8, 1), check(2, 4, 6, 1) ]

        for i in [0..niz1.length-1]
            if niz1[i] then return {winer: 0, index: i}

        for i in [0..niz2.length-1]
            if niz2[i] then return {winer: 1, index: i}

        return null

        
    tieTest: (state) ->
        for b in state.board
            if b is 2 then return false
        return true

    terminalTest: (state) ->
        return @wonGameTest(state)? or @tieTest(state)


class TicTacToeGame extends Game

    constructor: (player) ->
        @setPlayer player
        super new TicTacToeRules()
        @ddd = false
        @maxDepth = 20

    play: (state) ->
        @generateMove( state, @heuristic, @maxDepth)

    setPlayer: (@player) ->
        @opponent = if @player is 0 then 1 else 0

    setddd: (@ddd) ->

    heuristic: (state) ->
        WIN = 5000
        LOSE = -5000

        calculate = (i, j, k) ->
            rez = [0,0, 0]
            rez[state.board[i]] = rez[state.board[i]] + 1
            rez[state.board[j]] = rez[state.board[j]] + 1
            rez[state.board[k]] = rez[state.board[k]] + 1
            return [ rez[0], rez[1] ]

        niz = [ calculate(0, 1, 2), \
                calculate(3, 4, 5), \
                calculate(6, 7, 8), \
                calculate(0, 3, 6), \
                calculate(1, 4, 7), \
                calculate(2, 5, 8), \
                calculate(0, 4, 8), \
                calculate(2, 4, 6) ]

        if @ddd then console.log niz

        rez = 0

        for i in niz
            p = i[@player]
            o = i[@opponent]

            if p is 3 then return WIN
            if o is 3 then return LOSE

        for i in niz
            p = i[@player]
            o = i[@opponent]

            if p is 2 and o is 0 and state.player is @player then return WIN
            if p is 0 and o is 2 and state.player is @opponent then return LOSE

            if p is 2 and o is 0 and state.player is @opponent then return 1000
            if p is 0 and o is 2 and state.player is @player then return -1000
            

        return rez
            

window.game = new TicTacToeGame(0)


