*-------------------------------------------------------------------------
* <Rating>0</Rating>
*-------------------------------------------------------------------------
    PROGRAM CALLJTEST

    param = "TEMENOS"
    ret =""
    CALLJ "Logic.Hash","SHA1", param SETTING ret ON ERROR
        E= 'Unable to call JAVA PGM'
        Err = SYSTEM(0)
        BEGIN CASE
        CASE Err = 1
            CRT "FATAL ERROR CREATING THREAD"
        CASE Err = 2
            CRT "CANNOT FIND THE JVM FILE"
        CASE Err = 3
            CRT "CLASS DOES'NT EXIST"
        CASE Err = 4
            CRT "UNICODE CONVERSION ERROR"
        CASE Err = 5
            CRT "METHOD DOES'NT EXIST"
        CASE Err = 6
            CRT "CANNOT FIND OBJECT CONSTRUCTOR"
        CASE Err = 7
            CRT "CANNOT INSTANTIATE OBJECT"
        CASE @TRUE
            CRT "UNKNOWN ERROR"
        END CASE
    END
    CRT "Return : ":ret
    RETURN
END
