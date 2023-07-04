* @ValidationCode : Mjo5OTI4MTQ5MjM6Q3AxMjUyOjE2ODA2NzkxOTk1NTA6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:49:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CORR.ATH.TERM.LOC.NAME
*------------------------------------------------------------------------------
*Written by :Prabhu
*This routine converts latin1 character to UTF8.
** 06-04-2023 R22 Auto Conversion
** 06-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_F.REDO.ATH.SETTLMENT ;* R22 Auto conversion



    FN.REDO.ATH.SETTLMENT='F.REDO.ATH.SETTLMENT'
    F.REDO.ATH.SETTLMENT =''
    CALL OPF(FN.REDO.ATH.SETTLMENT,F.REDO.ATH.SETTLMENT)

    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------

    EXECUTE "GET.LIST ATHPROLIST"
    READLIST Y.ID.LIST ELSE Y.ID.LIST = ''

    IF NOT(Y.ID.LIST) THEN
        RETURN
    END
    LOOP
        Y.ATH.ID = ''
        REMOVE Y.ATH.ID FROM Y.ID.LIST SETTING Y.ATH.POS
    WHILE Y.ATH.ID:Y.ATH.POS
        R.REDO.ATH.SETTLEMENT=''
        CALL F.READ(FN.REDO.ATH.SETTLMENT,Y.ATH.ID,R.REDO.ATH.SETTLEMENT,F.REDO.ATH.SETTLMENT,Y.ERR)
        IF R.REDO.ATH.SETTLEMENT THEN
            GOSUB PROCESS.ATH.RECORD
        END
    REPEAT


    OPEN '&SAVEDLISTS&' TO FN.SAVED.LIST THEN
        Y.ATH.SL.ID='ATHPROLIST'
        DELETE FN.SAVED.LIST,Y.ATH.SL.ID
    END

RETURN

*------------------
PROCESS.ATH.RECORD:
*------------------

    Y.TERM.LOC.VAL =R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.LOC.NAME>
    IF Y.TERM.LOC.VAL THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.LOC.NAME>=UTF8(Y.TERM.LOC.VAL)
    END

    Y.TERM.OWN.NAME=R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.OWNER.NAME>
    IF Y.TERM.OWN.NAME THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.OWNER.NAME>=UTF8(Y.TERM.OWN.NAME)
    END

    Y.TERM.ID      =R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.FIID>
    IF  Y.TERM.ID THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.FIID>=UTF8(Y.TERM.ID)
    END

    Y.ATM.CITY.STATE=R.REDO.ATH.SETTLEMENT<ATH.SETT.ATM.CITY.STATE>
    IF Y.ATM.CITY.STATE THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.ATM.CITY.STATE>=UTF8(Y.ATM.CITY.STATE)
    END
    CALL F.WRITE(FN.REDO.ATH.SETTLMENT,Y.ATH.ID,R.REDO.ATH.SETTLEMENT)

    CALL JOURNAL.UPDATE(Y.ATH.ID)
RETURN
END
