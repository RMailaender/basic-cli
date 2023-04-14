interface Command
    exposes [ 
        Command, 
        withDefault,
        withArgs, 
        display,
        arg,
        argToStr,
        spawn,
    ] 
    imports [
        Path.{ Path },
        Effect.{ Effect },
        Task.{ Task },
        InternalTask
    ]

# path 

Arg := Str

Command : { 
    cmdPath: Path,
    args: List Arg,
}

withDefault : Path -> Command
withDefault = \cmdPath -> { cmdPath, args : []}

withArgs : Path, List Arg -> Command
withArgs = \cmdPath, args ->{ 
    cmdPath, 
    args,
}

display : Command -> Str
display = \{ cmdPath, args } -> 
    List.map args argToStr
        |> List.walk (Path.display cmdPath) (\state, elem -> "\(state) \(elem)")


arg : Str -> Arg
arg = @Arg

argToStr : Arg -> Str
argToStr = \@Arg argument -> 
    argument

spawn : Command -> Task Str [SpawnFailed Str]
spawn = \{ cmdPath } ->  
    cmdPath
    |> Path.display
    |> Effect.cmdSpawn []
    #|> Effect.map Ok
    |> InternalTask.fromEffect
    |> Task.mapFail \err -> SpawnFailed err