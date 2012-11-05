###
#   licensed under apache commons license
#   created by: Igor Sarcevic
#   @mail : igisar@gmail.com
#   @github : shiroyahsa   
###

DEBUG = false

ispis = (depth, v, action) ->
    if not DEBUG then return
    prefix = ""
    for i in [0..depth]
        prefix += '----'

    console.log prefix, 'action ', action, '= ',  v, if depth % 2 is 0 then "max" else "min"



class GameRules
    possibleMoves: (state) -> []
    makeMove: (state) -> null
    terminalTest: (state) -> false


class Game

    setDebug: (d) -> DEBUG = d
    
    ###
        rules is an object that contains three functions
        that define the game logic
        - possibleMoves - generates all the moves from the given state
        - makeMove - generates resulting move from the state
        - terminalTest - tests if the game state is terminal
    ###
    constructor: (@rules) ->



    ###
        generates the move using minimax algorithm
        - state is an object that contains information about game state 
        - maxDepth is the maximal depth the algorithm will go
        - heuristic - function that evaluates the given state as an integer

        TODO: make it more 'functional like'
    ###
    generateMove: (state, @heuristic, @maxDepth) ->
        if @rules.terminalTest(state) or @maxDepth is 0 then return null

        value = Number.NEGATIVE_INFINITY
        action = null

        alpha = Number.NEGATIVE_INFINITY
        beta = Number.POSITIVE_INFINITY

        for a in @rules.possibleMoves(state)
            result = @_minMinimax( @rules.makeMove(state, a), 1, alpha, beta )
            
            ispis 0, result, a
            if result > value
                value = result
                action = a

            alpha = Math.max result, alpha

        return action


    _maxMinimax: (state, depth, alpha, beta) ->
        if @rules.terminalTest(state) or @maxDepth is depth
            return @heuristic(state)

        value = Number.NEGATIVE_INFINITY

        for a in @rules.possibleMoves(state)
            result = @_minMinimax( @rules.makeMove(state, a), depth + 1, alpha, beta )
            
            ispis depth, result, a
            value = Math.max value, result
            
            if value >= beta then return value
            
            alpha = Math.max result, alpha

        return value


     _minMinimax: (state, depth, alpha, beta) ->
        if @rules.terminalTest(state) or @maxDepth is depth
            return @heuristic(state)

        value = Number.POSITIVE_INFINITY

        for a in @rules.possibleMoves(state)
            result = @_maxMinimax( @rules.makeMove(state, a), depth + 1, alpha, beta )
            
            ispis depth, result, a

            value = Math.min value, result
            
            if value <= alpha then return value
            
            beta = Math.min result, beta

        return value
      

    
