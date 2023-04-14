app "command"
    packages { pf: "../src/main.roc" }
    imports [pf.Stdout, pf.Command, pf.Path, pf.Task]
    provides [main] to pf


main =
    cmd = Command.withArgs 
        ( Path.fromStr "ls" )
        [
            Command.arg "-a"
        ]
    spawnResult <- Task.await (Command.spawn cmd)

    Str.concat "Cmd: " ( Command.display cmd ) 
        |> Stdout.line

    
    