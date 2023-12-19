* @ValidationCode : MjotMTQ5MTcyODU4MjpDcDEyNTI6MTY4NjY3NjAxNzE4OTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:36:57
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

$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.GET.PERIOD.AMTS(Y.ACCOUNT.ID, Y.START.DATE, Y.PROCESS.DATE, Y.AA.BALANCE.LIST, Y.OUT.AA.AMOUNT.LIST)
*******************************************************************************
*
*    REDO COLLECTOR EXTRACT SERVICE
*    Get AA amount details by item
*             TMPCREDITOMONTOSEGUROVIDAVIGEN
*             TMPCREDITOMONTOSEGUROVIDAVENCI
*             TMPCREDITOMONTOSEGUROFISICOVIG
*             TMPCREDITOMONTOSEGUROFISICOVEN
*             TMPCREDITOMONTOVIGENTEOTROS
*             TMPCREDITOMONTOMOROSOOTROS
*
* @Parameters:
* -----------------------------------------------------------------------------
*                 Y.ACCOUNT.ID    (in) acount ID (arrangement)
*                 Y.START.DATE    (in) START.DATE for AA.GET.PERIOD.BALANCES
*                 Y.PROCESS.DATE  (in) PROCESS.DATE for AA.GET.PERIOD.BALANCES
*                 Y.AA.BALANCE.LIST (in) List of balance types to query
*                 Y.OUT.AA.AMOUNT.LIST (out) balances for each balance types
*
* =============================================================================
*
*    First Release : TAM
*    Developed for : APAP
*    Developed by  : APAP
*    Date          : 2010-11-18 - C.1 First Version
*
*=======================================================================
*
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 18.05.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, ++ TO += 1
* 18.05.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_REDO.COL.CUSTOMER.COMMON
*
*************************************************************************
*

    GOSUB INITIALISE
*
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ----------------------------------------------------------------------------------
PROCESS:
* ----------------------------------------------------------------------------------
*
*
* For each Element in the original
    Y.OUT.AA.AMOUNT.LIST = ''
    Y.TOT.AAP.LIST=DCOUNT(Y.AA.BALANCE.LIST,@FM)
    I.POS = 1
    LOOP
    WHILE I.POS LE Y.TOT.AAP.LIST
        Y.AA.PROPERTY.ID.LIST=Y.AA.BALANCE.LIST<I.POS>
        GOSUB PROCESS.BALANCE
        Y.OUT.AA.AMOUNT.LIST<I.POS> = Y.TOT.AMOUNT
        I.POS += 1           ;** R22 Auto conversion - ++ TO += 1
    REPEAT
RETURN

* ----------------------------------------------------------------------------------
* Process each entry in Balance
PROCESS.BALANCE:
* ----------------------------------------------------------------------------------
*
*
    Y.TOT.AMOUNT = 0
    LOOP
        REMOVE Y.AA.PROPERTY FROM Y.AA.PROPERTY.ID.LIST SETTING Y.AA.PROPERTY.ID.MARK
    WHILE Y.AA.PROPERTY : Y.AA.PROPERTY.ID.MARK
        GOSUB GET.BALANCE
        Y.TOT.AMOUNT += Y.OUT.AA.AMOUNT
    REPEAT
RETURN
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
* ----------------------------------------------------------------------------------
* Allows to call AA.GET.PERIOD.BALANCES and get the curernt balance for Y.AA.PROPERTY
GET.BALANCE:
* ----------------------------------------------------------------------------------
*
    Y.OUT.AA.AMOUNT = 0
    BALANCE.TO.CHECK = Y.AA.PROPERTY
    BAL.DETAILS = ""
    DATE.OPTIONS = ''
    DATE.OPTIONS<2> = "ALL"     ;* Request NAU movements
    PRESENT.VALUE = ''          ;* THe current balance figure
    ACCOUNT.ID = Y.ACCOUNT.ID
    CALL AA.GET.PERIOD.BALANCES(ACCOUNT.ID, BALANCE.TO.CHECK, DATE.OPTIONS, Y.START.DATE, Y.PROCESS.DATE, '', BAL.DETAILS, "")      ;* Get the balance for this date
    Y.OUT.AA.AMOUNT = ABS(BAL.DETAILS<IC.ACT.BALANCE>)        ;* Get the current outstanding amount

RETURN
*
* ----------------------------------------------------------------------------------
END
