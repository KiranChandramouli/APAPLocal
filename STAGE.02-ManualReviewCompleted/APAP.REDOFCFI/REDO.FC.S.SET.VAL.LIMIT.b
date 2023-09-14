* @ValidationCode : MjotNDA1NjA2OTc3OkNwMTI1MjoxNjgwNzgzNjY4OTM1OklUU1M6LTE6LTE6MTc0OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:51:08
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
SUBROUTINE REDO.FC.S.SET.VAL.LIMIT

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.VALIDATE
* Attached as     : ROUTINE
* Primary Purpose : Setting the values for LIMIT
*
* Incoming:
* ---------
*
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
* Development by  :
* Date            :
** Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.LIMIT

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.MAIN
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*======================

* Get Limit Product for the given Category Code

* Set Limit information
*****************************************************

    Y.LIM.ID = R.NEW(REDO.FC.ID.LIMIT)
    Y.CUS.ID = R.NEW(REDO.FC.CUSTOMER)

    Y.LIMIT.ID = Y.CUS.ID:'.000':Y.LIM.ID
    CALL F.READ(FN.LIMIT,Y.LIMIT.ID,R.LIMIT,F.LIMIT,LIM.ERR)

    IF NOT(R.LIMIT) THEN
        RETURN
    END

    R.NEW(REDO.FC.LIMIT.CURRENCY) = R.NEW(REDO.FC.LOAN.CURRENCY)
    R.NEW(REDO.FC.APPROVAL.DATE) = R.NEW(REDO.FC.EFFECT.DATE)
    R.NEW(REDO.FC.OFFERED.UNTIL) = R.NEW(REDO.FC.EFFECT.DATE)

    Y.MAT.DATE = R.NEW(REDO.FC.TERM)
    CALL CALENDAR.DAY(R.NEW(REDO.FC.EFFECT.DATE),'+',Y.MAT.DATE)

    R.NEW(REDO.FC.EXPIRY.DATE)       = Y.MAT.DATE
    R.NEW(REDO.FC.NOTES)             = "MANUAL_LIMIT"

    R.NEW(REDO.FC.INTERNAL.AMOUNT)   = R.LIMIT<LI.INTERNAL.AMOUNT>
    R.NEW(REDO.FC.MAXIMUM.TOTAL)     = R.LIMIT<LI.MAXIMUM.TOTAL>
    R.NEW(REDO.FC.AVAILABLE.MARKER)  = "Y"

    Y.COLS = R.NEW(REDO.FC.TYPE.OF.SEC.BR)
    Y.COL.CNT = DCOUNT(Y.COLS,@VM) ; FLG = '' ; Y.MAXSEC.AMT = ''
    LOOP
    WHILE Y.COL.CNT GT 0 DO
        FLG += 1
        Y.COLSS = Y.COLS<1,FLG>
        LOCATE Y.COLSS IN R.LIMIT<LI.COLLATERAL.CODE,1> SETTING POSL THEN
            Y.MAXSEC.AMT += R.LIMIT<LI.MAXIMUM.SECURED,POSL>
        END
        Y.COL.CNT -= 1
    REPEAT

    R.NEW(REDO.FC.MAXIMUM.SECURED) = Y.MAXSEC.AMT
    R.NEW(REDO.FC.REVIEW.FREQUENCY) = R.LIMIT<LI.REVIEW.FREQUENCY>
    R.NEW(REDO.FC.PROPO.SAL.DATE) = R.LIMIT<LI.APPROVAL.DATE>
    R.NEW(REDO.FC.ONLINE.LIMIT.DATE) = TODAY
    R.NEW(REDO.FC.FIXED.VARIABLE) = 'FIXED'

RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1

RETURN

*------------------------
OPEN.FILES:
*=========

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

RETURN
*------------------

END
