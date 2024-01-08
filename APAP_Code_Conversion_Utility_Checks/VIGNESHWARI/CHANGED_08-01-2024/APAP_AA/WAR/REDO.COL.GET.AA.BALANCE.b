* @ValidationCode : MjoxNjE1MjkwMTc6Q3AxMjUyOjE3MDM4NDIwNTU2OTc6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 29 Dec 2023 14:57:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.COL.GET.AA.BALANCE (Y.AA.AC.ID,Y.AA.BAL)
*-----------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : COLLATERAL
* Attached as     : API ROUTINE
* Primary Purpose : GET BACK THE BALANCE OF AMOUNT
* Incoming:
* ---------
* Y.AA.AC.ID --> MUST BE AA ACCOUNT VALID ID
* Outgoing:
* --------- 
* Y.AA.BAL --> BALANACE OF AA
* Error Variables:
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo - TAM Latin America
* Date            : February 23 2013
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 29-MAR-2023      Conversion Tool       R22 Auto Conversion - No changes
* 29-MAR-2023      Harsha                R22 Manual Conversion - No changes
*29-12-2023       VIGNESHWARI S      R22 MANUAL CONVERSTION -CALL RTN MODIFIED
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AC.BALANCE.TYPE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.ACCT.ACTIVITY
    $USING AA.Framework
    IF NOT(Y.AA.AC.ID) THEN
        Y.AA.BAL = 'ERROR'
    END
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

    Y.AA.BAL = DROUND(Y.AA.BAL ,2)

RETURN

* =========
INITIALISE:
* =========

    Y.ACCOUNT.ID =  Y.AA.AC.ID

    Y.PROCESS.DATE              = TODAY
    Y.OUT.AA.AMOUNT             = 0
    Y.BALANCE.TO.CHECK          = ""
    Y.BAL.DETAILS               = ""
    Y.DATE.OPTIONS              = ''
    Y.DATE.OPTIONS<2>           = ""      ;* Request NAU movements
    Y.DATE.OPTIONS<4>           = "ECB"   ;*Type Of Balance
    Y.PRESENT.VALUE             = ''      ;* THe current balance figure
    Y.BALANCE.TYPE              = ''

    FN.AC.BALANCE.TYPE = 'F.AC.BALANCE.TYPE'
    F.AC.BALANCE.TYPE  = ''
    R.AC.BALANCE.TYPE  = ''

    Y.BALANCE.TYPE.ID = ''
    Y.POS = ''
RETURN

* =========
OPEN.FILES:
* =========


RETURN
* ======
PROCESS:
* ======

    Y.SEL.COMAND  = 'SELECT ' : FN.AC.BALANCE.TYPE
    Y.SEL.COMAND := ' WITH @ID LIKE ...ACCOUNT AND @ID UNLIKE ...UNC... AND @ID UNLIKE ...UND...'
    Y.SEL.COMAND := ' AND REPORTING.TYPE EQ "NON-CONTINGENT"'

    CALL EB.READLIST(Y.SEL.COMAND,Y.BALANCE.TYPE,'',NO.OF.RECO,Y.ERR)
    IF NOT(Y.BALANCE.TYPE) THEN
        RETURN
    END

*For each balance type get the value
    LOOP
        REMOVE Y.BALANCE.TYPE.ID FROM Y.BALANCE.TYPE SETTING Y.POS
    WHILE  Y.POS:Y.BALANCE.TYPE.ID

        Y.BALANCE.TO.CHECK = Y.BALANCE.TYPE.ID

*Get the balance value
       * CALL AA.GET.PERIOD.BALANCES(Y.ACCOUNT.ID, Y.BALANCE.TO.CHECK, Y.DATE.OPTIONS, Y.PROCESS.DATE, Y.PROCESS.DATE, '', Y.BAL.DETAILS, "")    ;* Get the balance for this date
        AA.Framework.GetPeriodBalances(Y.ACCOUNT.ID, Y.BALANCE.TO.CHECK, Y.DATE.OPTIONS, Y.PROCESS.DATE, Y.PROCESS.DATE, '', Y.BAL.DETAILS, "") ;*R22 MANUAL CODE CONVERSION-CALL RTN MODIFIED
        P.TOTAL.OUT += Y.BAL.DETAILS<IC.ACT.BALANCE>
    REPEAT
    Y.AA.BAL = ABS(P.TOTAL.OUT)


RETURN

END
