interface Command
    exposes [ 
        Command, 
        withDefault,
        withArgs, 
        display,
        run,
    ] 
    imports [
        Effect.{ Effect },
        Task.{ Task },
        InternalTask,
    ]

# path 

Arg := Str

Command : { 
    cmdPath: Str,
    args: List Str,
}

withDefault : Str -> Command
withDefault = \cmdPath -> { cmdPath, args : []}

withArgs : Str, List Str -> Command
withArgs = \cmdPath, args -> { 
    cmdPath, 
    args,
}

display : Command -> Str
display = \{ cmdPath, args } -> 
    List.walk args (cmdPath) (\state, elem -> "\(state) \(elem)")

run : Command -> Task Str [SpawnFailed Str]
run = \{ cmdPath,args } ->  
    cmdPath
    |> Effect.commandRun args
    |> InternalTask.fromEffect
    |> Task.mapFail \err -> SpawnFailed err