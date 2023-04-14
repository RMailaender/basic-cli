app "command"
    packages { pf: "../src/main.roc" }
    imports [pf.Stderr, pf.Stdout, pf.Command, pf.Task.{ await }, pf.Process]
    provides [main] to pf


main =
    cmd = Command.create  
        { 
            name: "ls", 
            args:  [ "-al" ] 
        }

    okStr : List U8 -> Str
    okStr = \bytes ->
        when Str.fromUtf8 bytes is 
            Ok str -> 
                str

            Err _ -> 
                "Invalid bytes"

    Task.attempt (Command.run cmd) \result -> 
        when result is
            Ok bytes ->
                str = okStr bytes
                _ <- await (Stdout.line str)
                Process.exit 0

            Err (SpawnFailed err) -> 
                str = Str.fromUtf8 err |> Result.withDefault "gnark"
                Stderr.line str
   
    