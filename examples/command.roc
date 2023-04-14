app "command"
    packages { pf: "../src/main.roc" }
    imports [pf.Stderr, pf.Stdout, pf.Command, pf.Path, pf.Task.{ await }, pf.Process]
    provides [main] to pf


main =
    cmd = Command.withArgs 
        ( Path.fromStr "ls" )
        [
            Command.arg "-a"
        ]
    Task.attempt (Command.spawn cmd) \result -> 
        when result is
            Ok s -> 
                # Stdout.line s
                Process.exit 0

            Err (SpawnFailed err) -> 
                Stderr.line err

# Str.concat "Cmd: " ( Command.display cmd ) 
#     |> Stdout.line

    
    