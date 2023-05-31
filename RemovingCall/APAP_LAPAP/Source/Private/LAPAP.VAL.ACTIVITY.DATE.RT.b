* @ValidationCode : Mjo4ODAyMDEzMzM6Q3AxMjUyOjE2ODQyMjI4MTg2MDI6SVRTUzotMTotMTo4ODoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 88
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.VAL.ACTIVITY.DATE.RT
*---------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------------------

    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY    ;*R22 AUTO CODE CONVERSION.END

    GOSUB LOAD.TABLE
    GOSUB PROCES
RETURN

LOAD.TABLE:
***********
    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    FV.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,FV.AA.ARRANGEMENT.ACTIVITY)
    Y.STATUS = R.NEW(2)
    AA.ARR.ID = R.NEW(1)
RETURN

PROCES:
*******
    IF Y.STATUS EQ 'CLOSE' THEN
        SEL.CMD = '';  LIST.IDS = ''; NO.OF.REC = ''; SEL.ERR = '';
        SEL.CMD = "SELECT ":FN.AA.ARRANGEMENT.ACTIVITY:" WITH ARRANGEMENT EQ ":AA.ARR.ID:" AND EFFECTIVE.DATE GT ":TODAY:""
        CALL EB.READLIST(SEL.CMD, LIST.IDS,'',NO.OF.REC,SEL.ERR)

        IF (LIST.IDS) THEN
            MESSAGE = " EL CONTRATO: ":AA.ARR.ID:" TIENE ACTIVIDADES PENDIENTES, POR FAVOR CORREGIR E INTENTAR NUEVAMENTE "
            E = MESSAGE
            ETEXT = E
            CALL ERR
        END
    END
RETURN
END
