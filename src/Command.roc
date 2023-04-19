interface Command
    exposes [ 
        Command, 
        display,
        run,
        WorkingDirectory,
        setCwd,
        create
    ] 
    imports [
        Effect.{ Effect },
        Task.{ Task },
        InternalTask,
        Path.{ Path },
    ]

# TODO Figure out how to roc glue
# TODO should args and envs be an opaque type? 
# TODO  impl a way to update all props. meybe there is a way 
#       to work with an optiona record instead of writing a function for each prop
# TODO impl clear and delete envs 
# TODO Write Docs

WorkingDirectory : [CurrentDir, DifferenDir Path]


Command := { 
    name: Str,
    args: List Str,
    cwd: WorkingDirectory,
    envs: Dict Str Str
}
# TODO report format error
create : 
    {
        name : Str,
        args ? List Str,
        cwd ? WorkingDirectory,
        envs ? Dict Str Str
    } -> Command
create = \{ name, args ? [], cwd ? CurrentDir,envs ? Dict.empty {} } -> 
    @Command {
        name,
        args,
        cwd,
        envs,
    }

setCwd : Command, WorkingDirectory -> Command
setCwd = \@Command command, dir -> 
    @Command { command & cwd: dir }

display : Command -> Str
display = \@Command{ name, args } -> 
    List.walk args (name) (\state, elem -> "\(state) \(elem)")

run : Command -> Task Str [SpawnFailed Str, StdoutDecodingFailed]
run = \@Command{ name,args } ->  
    name
    |> Effect.commandRun args
    |> InternalTask.fromEffect
    |> Task.attempt \result ->
        when result is
            Ok bytes -> 
                when Str.fromUtf8 bytes is 
                    Ok str -> Task.succeed str
                    Err _ -> Task.fail StdoutDecodingFailed 

            Err bytes -> 
                str = Str.fromUtf8 bytes |> Result.withDefault "unknown"
                Task.fail (SpawnFailed str)
        