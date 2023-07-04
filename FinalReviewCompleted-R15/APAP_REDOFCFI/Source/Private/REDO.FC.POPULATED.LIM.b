* @ValidationCode : MjotMTk0ODQ0MDIzMzpDcDEyNTI6MTY4MDc4MzY2NjIyNDpJVFNTOi0xOi0xOjE3NDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:51:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 174
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.POPULATED.LIM

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.VALIDATE
* Attached as     :
* Primary Purpose : GET THE LIMIT RECORD FROM LIMIT APP WITH LIMIT ID
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : mgudino - TAM Latin America
* Date            : 11 AGU 2011
** Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_System
    $INSERT I_F.LIMIT


    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.MAIN
    END

RETURN  ;* Program RETURN

PROCESS.MAIN:
*============
* OPEN THE LIMIT RECORD
    CALL F.READ(FN.LIMIT, Y.ID.LIMIT, R.LIMIT, F.LIMIT, YERR)
    IF YERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.LIMIT
        CALL STORE.END.ERROR
        RETURN
    END
    GOSUB VALIDATE.INT.AMOUNT

    IF NOT(Y.FLAG.AMOUNT) THEN
        ETEXT = 'EB-FC-LIMIT-AMOUNT'
        CALL STORE.END.ERROR
        RETURN
    END

    IF NOT(YERR) THEN
        R.NEW(REDO.FC.APPROVAL.DATE) = R.LIMIT<LI.APPROVAL.DATE>
        R.NEW(REDO.FC.EXPIRY.DATE) = R.LIMIT<LI.EXPIRY.DATE>
        R.NEW(REDO.FC.NOTES) = R.LIMIT<LI.NOTES>
        R.NEW(REDO.FC.INTERNAL.AMOUNT) = R.LIMIT<LI.INTERNAL.AMOUNT>
        R.NEW(REDO.FC.COLLATERAL.CODE) = R.LIMIT<LI.COLLATERAL.CODE>
        R.NEW(REDO.FC.LIMIT.CURRENCY) = R.LIMIT<LI.LIMIT.CURRENCY>
    END

RETURN

INITIALISE:
*=========

    PROCESS.GOAHEAD = 1
    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
    Y.VALUE = ''
    R.LIMIT = ''
    Y.FLAG.AMOUNT = 0

    Y.ID.LIMIT = R.NEW(REDO.FC.ID.LIMIT)

    IF Y.ID.LIMIT THEN
        Y.CUSTOMER = R.NEW(REDO.FC.CUSTOMER)

        Y.LIMIT = Y.ID.LIMIT
        Y.POS = INDEX(Y.LIMIT, ".", 1)
        Y.LEN = LEN(Y.LIMIT)
        Y.SEC = SUBSTRINGS(Y.LIMIT, Y.POS + 1, Y.LEN)

        Y.LIMIT  = SUBSTRINGS(Y.LIMIT, 1, Y.POS - 1)

        Y.LIMIT    = FMT(Y.LIMIT,"7'0'R")

        Y.ID.LIMIT     = Y.CUSTOMER : "." : Y.LIMIT:".":Y.SEC
    END ELSE
        PROCESS.GOAHEAD = 0
    END

RETURN


OPEN.FILES:
*=========

    CALL OPF(FN.LIMIT, F.LIMIT)
RETURN

VALIDATE.INT.AMOUNT:
*===================

    Y.VALUE = R.LIMIT<LI.INTERNAL.AMOUNT>

    IF Y.VALUE GT 0 AND Y.VALUE GE R.NEW(REDO.FC.AMOUNT) THEN
        Y.FLAG.AMOUNT = 1
    END
RETURN

END
