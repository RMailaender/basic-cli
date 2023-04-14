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

    Task.attempt (Command.run cmd) \result -> 
        when result is
            Ok s -> 
                _ <- await (Stdout.line s)
                Process.exit 0

            Err (SpawnFailed err) -> 
                Stderr.line err
   
    