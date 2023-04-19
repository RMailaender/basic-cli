app "command"
    packages { pf: "../src/main.roc" }
    imports [pf.Stderr, pf.Stdout, pf.Command, pf.Task.{ await }, pf.Process]
    provides [main] to pf

grepEcho = \text ->
    Command.run (Command.create { name: "grep", args: [ "-l", "Exampl", "README.md"]})

main =
    cmd = Command.create  
        { 
            name: "ls",
        }

    
    task = 
        text <- await (Command.run cmd)
        lsa <- await ( Command.run (Command.create { name: "ls", args: [ "-al" ] }) )
        _ <- await (Stdout.line lsa)
        grepEcho text

    Task.attempt task \result -> 
        when result is
            Ok str ->
                _ <- await (Stdout.line str)
                Process.exit 0

            Err (SpawnFailed err) -> 
                Stderr.line (Str.concat "Error: " err)

            Err (StdoutDecodingFailed) ->
                Stderr.line "Error: docing failed"
   
    