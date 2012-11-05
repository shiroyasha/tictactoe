
POSITIONS = [ [0, 0],   [200, 0],   [400, 0], \
              [0, 200], [200, 200], [395, 200], \
              [0, 400], [200, 390], [390, 390] ]

MODES = { player_vs_comp: 0, comp_vs_player: 1, comp_vs_comp: 2 }

class TicTacToeView

    constructor: (@id, @images) ->
        @ctx = document.getElementById(@id).getContext('2d')
        $('#' + @id ).click ( ev )=> @onClick(ev)
        @gameInProcess = false
        @moveTimer = null

    restart: (@mode) ->
        @gameInProcess = true
        clearTimeout( @moveTimer )
        @ctx.clearRect(0, 0, 550, 550)

        @state = { board: [2, 2, 2,  2, 2, 2,   2, 2, 2], player: 0 }
        
        if @mode is MODES.comp_vs_player or @mode is MODES.comp_vs_comp
            game.setPlayer 0
            field = game.play(@state)
            @makeMove(field)
        else
            game.setPlayer 1

    makeMove: (field) ->
        if not @gameInProcess then return
        if @state.board[field] != 2 then return
        
        @state.board[field] = @state.player
        @draw( @state.player, field)

        @state.player = if @state.player is 0 then 1 else 0

        if @mode is MODES.comp_vs_comp then game.setPlayer @state.player

        if game.rules.terminalTest(@state)
            @gameInProcess = false
            info = game.rules.wonGameTest(@state)
            if info? then @drawLine( info.index )
            return

        if (@mode is MODES.comp_vs_comp) or \
           (@mode is MODES.player_vs_comp and @state.player is 1) or \
           (@mode is MODES.comp_vs_player and @state.player is 0)
                callback = => @makeMove game.play(@state)
                @moveTimer = setTimeout( callback, 500 )

    draw: ( player, field ) ->
        img = if player is 0 then @images.x else @images.o
        x = POSITIONS[field][0]
        y = POSITIONS[field][1]
        #console.log 'draw', img
        @ctx.drawImage( img , 0, 0, 150, 150, x, y, 150, 150 )

    drawLine: (index) ->
        console.log index
        if index in [0, 1, 2]
            y = POSITIONS[index*3][1] + 60
            @ctx.drawImage( @images.horizontal , 0, 0, 550, 50, 0, y, 550, 50 )
        else if index in [3, 4, 5]
            x = POSITIONS[index-3][0] + 60
            @ctx.drawImage( @images.vertical, 0, 0, 50, 550, x, 0, 50, 550 )
        else if index is 6
            @ctx.drawImage( @images.main_diagonal, 0, 0, 550, 550, 0, 0, 550, 550 )
        else if index is 7
            @ctx.drawImage( @images.minor_diagonal, 0, 0, 550, 550, 0, 0, 550, 550 )

    
    draw: ( player, field ) ->
        img = if player is 0 then @images.x else @images.o
        x = POSITIONS[field][0]
        y = POSITIONS[field][1]
        #console.log 'draw', img
        @ctx.drawImage( img , 0, 0, 150, 150, x, y, 150, 150 )


    onClick: (ev) ->
       if @mode is MODES.player_vs_comp and @state.player is 1 then return
       if @mode is MODES.comp_vs_comp then return
       if @mode is MODES.comp_vs_player and @state.player is 0 then return
       
       x = ev.pageX - $('#' + @id ).offset().left
       y = ev.pageY - $('#' + @id ).offset().top

       for i in [0..POSITIONS.length-1]
           if POSITIONS[i][0] <= x <= POSITIONS[i][0] + 150 and \
              POSITIONS[i][1] <= y <= POSITIONS[i][1] + 150
                @makeMove( i )
                return


class TicTacToeTesting

    constructor: (@id, @images) ->
        @ctx = document.getElementById(@id).getContext('2d')
        $('#' + @id ).click ( ev )=> @onClick(ev)
        @state = { board: [2, 2, 2,  2, 2, 2,   2, 2, 2], player: 0 }

        $('#calculate').click (ev) => @test()

        $('#clearField').click (ev) =>
            @ctx.clearRect(0, 0, 550, 550)
            @state = { board: [2, 2, 2,  2, 2, 2,   2, 2, 2], player: 0 }

    makeMove: (i) ->
        if @state.board[i] != 2
            which = 2
        else
            which = if $('#drawingRadiosX').attr('checked')? then 0 else 1
        
        @state.board[i] = which
        @draw(which, i)

    draw: (player, field) ->
        console.log 'tu', player, field

        img = if player is 0 then @images.x else @images.o
        x = POSITIONS[field][0]
        y = POSITIONS[field][1]
        #console.log 'draw', img

        if player is 2
            @ctx.clearRect(x, y, 150, 150)
        else
            @ctx.drawImage( img , 0, 0, 150, 150, x, y, 150, 150 )


    onClick: (ev) ->
       x = ev.pageX - $('#' + @id ).offset().left
       y = ev.pageY - $('#' + @id ).offset().top

       for i in [0..POSITIONS.length-1]
           if POSITIONS[i][0] <= x <= POSITIONS[i][0] + 150 and \
              POSITIONS[i][1] <= y <= POSITIONS[i][1] + 150
                @makeMove(i)
                return

    test: () ->
        $('#testResults').html("")
        temp = game.player
        
        if $('#maxDepth').attr('value').length > 0
            console.log 'menjam dubinu'
            game.maxDepth = parseInt( $('#maxDepth').attr('value') )

        game.setPlayer if $('#optionsRadiosX').attr('checked')? then 0 else 1
        @state.player = game.player

        console.log game.player
        terminal = game.rules.terminalTest( @state )
        heuristic = game.heuristic( @state )
        move = game.play( @state )

        rez = "<p>terminal state: " + (if terminal then "<b>yes</b>" else "<b>no</b>") + "</p>"
        rez += "<p>heuristic: " + heuristic + "</p>"
        rez += "<p>best move for " + (if game.player is 0 then 'x' else 'o') + ": " + move + "</p>"
        $('#testResults').html(rez)

        game.setPlayer( temp )



window.startGame = ->
    to_load = ['img/x.png'
               'img/o.png'
               'img/horizontal.png'
               'img/vertical.png'
               'img/main_diagonal.png'
               'img/minor_diagonal.png' ]

    imgpreload to_load, (images) ->
        rez = { x: images[0],\
                o: images[1],\
                horizontal: images[2],\
                vertical: images[3],\
                main_diagonal: images[4],\
                minor_diagonal: images[5] }


        view = new TicTacToeView('gameField', rez )
        view.restart(MODES.comp_vs_player)

        testing = new TicTacToeTesting('testingField', rez)

        $('#restartCompPlayerBtn').addClass('btn-inverse')

        removeButtonClasses = ->
            $('#restartPlayerCompBtn').removeClass('btn-inverse')
            $('#restartCompPlayerBtn').removeClass('btn-inverse')
            $('#restartCompCompBtn').removeClass('btn-inverse')
 
        $('#restartPlayerCompBtn').click -> 
            view.restart MODES.player_vs_comp
            removeButtonClasses()
            $(this).addClass('btn-inverse')

        $('#restartCompPlayerBtn').click -> 
            view.restart MODES.comp_vs_player
            removeButtonClasses()
            $(this).addClass('btn-inverse')

        $('#restartCompCompBtn').click -> 
            view.restart MODES.comp_vs_comp
            removeButtonClasses()
            $(this).addClass('btn-inverse')


