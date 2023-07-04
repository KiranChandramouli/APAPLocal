* @ValidationCode : MjoxMTM1MzYwODA1OkNwMTI1MjoxNjg1NDUzNTAwMzM3OklUU1M6LTE6LTE6LTc1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 30 May 2023 19:01:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -75
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 29-05-2023     Conversion tool    R22 Auto conversion       No changes
* 29-05-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
*-----------------------------------------------------------------------------
SUBROUTINE REDO.S.COL.GET.PERIOD.BALANCE(Y.ACCOUNT.ID, Y.PROCESS.DATE, R.STATIC.MAPPING, Y.AA.STATUS, Y.AA.PROPERTY, Y.OUT.AA.AMOUNT)
******************************************************************************
*
*    Field PERIOD.BALANCE on Collector-Interface
*
* =============================================================================
*
*    First Release : TAM
*    Developed for : TAM
*    Developed by  : APAP
*    Date          : 2010-11-15 C.1 Collector Interface
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_REDO.COL.CUSTOMER.COMMON
*
    $USING APAP.TAM
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
*
* Y.AA.STATUS = "STATUS"
* Y.AA.PROPERTY = "ACCOUNT" OR "INTEREST"
* Y.AA.AMOUNT = ""
    ;
* CAPITAL:
* CUR : Vigente      - 1
* AGE : Moroso       - 2
* DUE : Vencido      - 3
    ;
* INTEREST
* ACC : Vigente      - 1
* AGE : Moroso       - 2
* DUE : Vencido      - 3

    Y.MAP.VALUE = Y.AA.STATUS
    BEGIN CASE
        CASE Y.AA.PROPERTY EQ "ACCOUNT"
            Y.MAP.TYPE = "CAPITAL.STATUS"
        CASE Y.AA.PROPERTY EQ "INTEREST"
            Y.MAP.TYPE = "INTEREST.STATUS"
        CASE 1
            E = "ERROR, PROPERTY & WAS NOT DEFINED INTO MAPPING"
            E<2> = Y.AA.PROPERTY
            RETURN
    END CASE

    E = ""
    APAP.TAM.redoRColGetMapping(C.ID.STATIC.MAPPING, R.STATIC.MAPPING, 1, R.STATIC.MAPPING, Y.MAP.TYPE, Y.MAP.VALUE) ;*Manual R22 conversion
    IF E THEN
        RETURN
    END

    Y.AA.STATUS = Y.MAP.VALUE
    BALANCE.TO.CHECK = Y.AA.STATUS : Y.AA.PROPERTY
    BAL.DETAILS = ""
    DATE.OPTIONS = ''
    DATE.OPTIONS<2> = "ALL"     ;* Request NAU movements
    PRESENT.VALUE = ''          ;* THe current balance figure
    ACCOUNT.ID = Y.ACCOUNT.ID
    CALL AA.GET.PERIOD.BALANCES(ACCOUNT.ID, BALANCE.TO.CHECK, DATE.OPTIONS, '', Y.PROCESS.DATE, '', BAL.DETAILS, "")      ;* Get the balance for this date
    Y.OUT.AA.AMOUNT = ABS(BAL.DETAILS<IC.ACT.BALANCE>)        ;* Get the current outstanding amount

RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD = 1
*
*
RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
*    LOOP
*    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
*        BEGIN CASE
*        CASE LOOP.CNT EQ 1
*
*             IF condicion-de-error THEN
*                PROCESS.GOAHEAD = 0
*                E = "EB-mensaje-de-error-para-la-tabla-EB.ERROR"
*             END
**
*        END CASE
*        LOOP.CNT +=1
*    REPEAT
*
RETURN
*
END
