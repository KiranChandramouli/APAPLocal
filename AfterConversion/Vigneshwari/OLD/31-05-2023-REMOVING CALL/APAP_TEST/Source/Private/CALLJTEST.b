* @ValidationCode : MjotMzQzNjc1Mjk0OkNwMTI1MjoxNjgxOTcwMDcxNzY3OklUU1M6LTE6LTE6ODAwOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 11:24:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 800
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TEST
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*19-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           E TO E.VAR, = TO EQ
*19-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
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
