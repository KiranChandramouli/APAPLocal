* @ValidationCode : MjotMTM3MjU0NDUwNTpDcDEyNTI6MTY4MTgyOTA5MDg4NTpJVFNTOi0xOi0xOjY3NzoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 677
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 FM TO @FM
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
SUBROUTINE REDO.CUS.WTH.TRANS(CUST.ID,WTRAN1,WTRAN2,WTRAN3,WTRAN4,WTRAN5)

*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* through transaction
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : TRANS.WTH
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 28-DEC-2009      B Renugadevi     ODR-2010-04-0425      Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.CUSTOMER.ACCOUNT
    GOSUB INIT
    GOSUB PROCESS
RETURN

*****
INIT:
*****
    CUS.ID = '' ; FLAG  = 1 ; CNT = 0 ; PARR2 = '' ; PARR1 = '' ; PROD.ACCT.NO = '' ; AMT.TRANS = ''
    WTRAN1 = '' ; WTRAN2 = '' ; WTRAN3 = '' ; WTRAN4 = '' ; WTRAN5 = '' ; NO.OF.ACC = ''
    COUNT1 = '' ; COUNT2 = '' ; COUNT3 = '' ; COUNT4 = '' ; COUNT5 = ''

    FN.ACCOUNT          = 'F.ACCOUNT'
    FN.FUNDS.TRANSFER   = 'F.FUNDS.TRANSFER'
    FN.FT.HIS           = 'F.FUNDS.TRANSFER$HIS'
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT  = ''
    F.FT.HIS            = ''
    F.ACCOUNT           = ''
    F.FUNDS.TRANSFER    = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    CALL OPF(FN.FT.HIS,F.FT.HIS)
    CALL OPF(FN.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT)

RETURN
********
PROCESS:
********
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUS.ID,R.CUST,F.CUSTOMER.ACCOUNT,CUST.ERR)
    CNT = DCOUNT(R.CUST,@FM)
    INC = 1
    LOOP
    WHILE INC LE CNT
        ACC.ID = R.CUST<INC>
        SELECT.CMD="SELECT ":FN.FT.HIS:" WITH DEBIT.ACCT.NO EQ ":ACC.ID:" AND CHEQUE.NUMBER EQ ''"
        CALL EB.READLIST(SELECT.CMD,SELECT.LIS,'',NOR,ERR1)
        LOOP
            REMOVE TRANS.ID FROM SELECT.LIS SETTING POS2
        WHILE TRANS.ID:POS2
            CALL F.READ(FN.FT.HIS,TRANS.ID,R.FT.HIS,F.FT.HIS,FT.ERR)
            AMT.TRANS=R.FT.HIS<FT.DEBIT.AMOUNT>
            GOSUB COUNT.VAR
        REPEAT

        SELECT.CMD="SELECT ":FN.FUNDS.TRANSFER:" WITH DEBIT.ACCT.NO EQ ":ACC.ID:" AND CHEQUE.NUMBER EQ ''"
        CALL EB.READLIST(SELECT.CMD,SELECT.LIS,'',NOR,ERR1)
        LOOP
            REMOVE TRANS.ID FROM SELECT.LIS SETTING POS2
        WHILE TRANS.ID:POS2
            CALL F.READ(FN.FUNDS.TRANSFER,TRANS.ID,R.FUNDS.TRANS,F.FUNDS.TRANSFER,FT.ERR)
            AMT.TRANS=R.FUNDS.TRANS<FT.DEBIT.AMOUNT>
            GOSUB COUNT.VAR
        REPEAT

        INC +=1
    REPEAT
RETURN
*
**********
COUNT.VAR:
**********

    BEGIN CASE
        CASE AMT.TRANS GT 0 AND AMT.TRANS LE 10000
            WTRAN1+=1
        CASE AMT.TRANS GT 10000 AND AMT.TRANS LE 100000
            WTRAN2+=1
        CASE AMT.TRANS GT 100001 AND AMT.TRANS LE 250000
            WTRAN3+=1
        CASE AMT.TRANS GT 250001 AND AMT.TRANS LE 500000
            WTRAN4+=1
        CASE AMT.TRANS GT 500001
            WTRAN5+=1
        CASE 1

    END CASE
RETURN
**********
END
