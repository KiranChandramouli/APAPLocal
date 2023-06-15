* @ValidationCode : MjotMTc0MjAzMDQyNDpDcDEyNTI6MTY4MTEzNTE2NTc5MDpJVFNTOi0xOi0xOjQ1MToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 19:29:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 451
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.ORANGE.PAYMENTS.INIT
*-----------------------------------------------------------------------------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*----------------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
*
    $INSERT I_F.REDO.INTERFACE.PARAM
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END ELSE
        CALL TXT(W.ERROR)
    END
*
RETURN
*
* =====
PROCESS:
* =====
*
    POS=''
    FILE.PATH         = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>
    PRE.FILE.NAME     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FILE.NAME>
*
    W.LEN             = LEN(FILE.PATH)
    IF FILE.PATH[W.LEN,1] EQ "\" THEN
        W.LEN -= 1
        FILE.PATH = FILE.PATH[1,W.LEN]
    END

    OPEN FILE.PATH TO DIRECTORY.POINTER ELSE
        W.ERROR = "Erroneous.Path.&":@FM:FILE.PATH
    END
    SELECT DIRECTORY.POINTER TO ORANGE.LIST
*  LOOP WHILE READNEXT FI.FILE.ID FROM ORANGE.LIST DO
* Tus Start
    LOOP
        REMOVE FI.FILE.ID FROM ORANGE.LIST SETTING POS
    WHILE FI.FILE.ID:POS
* Tus End
        DELETE DIRECTORY.POINTER, FI.FILE.ID
    REPEAT
*
RETURN
*
* ========
INITIALISE:
* ========
*
    PROCESS.GOAHEAD   = 1
    PARAM.ID          = "ORANGE.PAYMT"
*
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    FV.REDO.INTERFACE.PARAM = ""
*
    LOOP.CNT       = 1
    MAX.LOOPS      = 5
*
    W.ERROR        = ""
*
RETURN
*
* ========
OPEN.FILES:
* ========
*
    CALL OPF(FN.REDO.INTERFACE.PARAM,FV.REDO.INTERFACE.PARAM)
*
RETURN
*
* ===================
CHECK.PRELIM.CONDITIONS:
* ===================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                CALL F.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID, R.REDO.INTERFACE.PARAM, FV.REDO.INTERFACE.PARAM, Y.ERR)
                IF Y.ERR THEN
                    W.ERROR = "PARAMETER.MISSING.&":@FM:PARAM.ID
                END

        END CASE

        IF W.ERROR THEN
            PROCESS.GOAHEAD = 0
        END

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
