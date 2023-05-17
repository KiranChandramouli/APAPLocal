PROGRAM CALLJTEST

    param = "TEMENOS"
    ret =""
    CALLJ "Logic.Hash","SHA1", param SETTING ret ON ERROR
        E.VAR= 'Unable to call JAVA PGM'
        Err = SYSTEM(0)
        BEGIN CASE
            CASE Err EQ 1
                CRT "FATAL ERROR CREATING THREAD"
            CASE Err EQ 2
                CRT "CANNOT FIND THE JVM FILE"
            CASE Err EQ 3
                CRT "CLASS DOES'NT EXIST"
            CASE Err EQ 4
                CRT "UNICODE CONVERSION ERROR"
            CASE Err EQ 5
                CRT "METHOD DOES'NT EXIST"
            CASE Err EQ 6
                CRT "CANNOT FIND OBJECT CONSTRUCTOR"
            CASE Err EQ 7
                CRT "CANNOT INSTANTIATE OBJECT"
            CASE @TRUE
                CRT "UNKNOWN ERROR"
        END CASE
    END
    CRT "Return : ":ret
RETURN
END
