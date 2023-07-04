* @ValidationCode : MjotNjM2NzEyMjc1OkNwMTI1MjoxNjgzMDE4MDk3MTgwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 14:31:37
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

SUBROUTINE REDO.TFS.PROCESS.VALIDATE
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.TFS.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.TFS.PROCESS.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*12.05.2010      SUDHARSANAN S     ODR-2009-10-0322 INITIAL CREATION
*16.06.2010      PRABHU N          ODR-2009-10-0315 ERROR MESSAGE REMOVED FOR INTERNAL ACCOUNT
*15-02-2010      Prabhu.N          N.78               HD1103429-CONCEPT is modified as multi value field
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             VM TO @VM,++ TO +=,F.READ TO CACHE.READ
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TFS.PROCESS
    $INSERT I_F.REDO.USER.ACCESS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY

    GOSUB INIT
    GOSUB PROCESS
RETURN

*---
INIT:
*---
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.CURRENCY='F.CURRENCY'
    F.CURRENCY=''
    CALL OPF(FN.CURRENCY,F.CURRENCY)
    TRANS.COUNT=1
RETURN
*-------
PROCESS:
*-------

    VAR.ACCOUNT.ID=R.NEW(TFS.PRO.PRIMARY.ACCT)
    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    R.NEW(TFS.PRO.ACCOUNT.NAME)=R.ACCOUNT<AC.ACCOUNT.TITLE.1>
    CNT.TRANS=DCOUNT(R.NEW(TFS.PRO.TRANSACTION),@VM)
    Y.CURRENCY=R.ACCOUNT<AC.CURRENCY>
    CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY, R.CURRENCY, ERR) ;*AUTO R22 CODE CONVERSION
    Y.LEN.CUR=R.CURRENCY<EB.CUR.NO.OF.DECIMALS>
    Y.LEN.CUR="L%":Y.LEN.CUR
    Y.SUM=''

    LOOP
    WHILE TRANS.COUNT LE CNT.TRANS
        R.NEW(TFS.PRO.CURRENCY)<1,TRANS.COUNT>=Y.CURRENCY
        Y.SUM+=R.NEW(TFS.PRO.AMOUNT)<1,TRANS.COUNT>
        Y.TEMP.AMOUNT=R.NEW(TFS.PRO.AMOUNT)<1,TRANS.COUNT>
        Y.TEMP.AMOUNT.FIR=FIELD(Y.TEMP.AMOUNT,'.',1)
        Y.TEMP.AMOUNT.DEC=FIELD(Y.TEMP.AMOUNT,'.',2)
        Y.TEMP.AMOUNT.DEC= FMT(Y.TEMP.AMOUNT.DEC,Y.LEN.CUR)
        R.NEW(TFS.PRO.AMOUNT)<1,TRANS.COUNT> = Y.TEMP.AMOUNT.FIR:'.':Y.TEMP.AMOUNT.DEC
        VAR.TRANS = R.NEW(TFS.PRO.TRANSACTION)<1,TRANS.COUNT>
        VAR.ACC =   R.NEW(TFS.PRO.ACCOUNT)<1,TRANS.COUNT>
        VAR.ACC.1 = VAR.ACC[1,3]
        CALL CACHE.READ(FN.CURRENCY, VAR.ACC.1, R.CURRENCY, CURR.ERR) ;*AUTO R22 CODE CONVERSION
        IF VAR.TRANS EQ 'FROM' OR VAR.TRANS EQ 'TO' THEN
            VAR.CCY = R.NEW(TFS.PRO.CURRENCY)<1,TRANS.COUNT>
            CALL F.READ(FN.ACCOUNT,VAR.ACC,R.ACC,F.ACCOUNT,ACCT.ERR)
            VAR.ACCT.CURRENCY=R.ACC<AC.CURRENCY>
*IF VAR.CCY NE VAR.ACCT.CURRENCY THEN
*   AF=TFS.PRO.CURRENCY
*   AV=TRANS.COUNT
*   ETEXT='EB-MIS.MATCH.CURR'
*   CALL STORE.END.ERROR
*END
        END ELSE
            IF VAR.ACC NE '' THEN
                IF R.CURRENCY EQ '' THEN
                    AF=TFS.PRO.ACCOUNT
                    AV=TRANS.COUNT
                    ETEXT='TT-INT.ACCT'
                    CALL STORE.END.ERROR
                END
            END
        END
        TRANS.COUNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
*********************************************************
*Checking Primary account field must be Customer Account
*********************************************************
    VAR.ACCOUNT.ID1 = VAR.ACCOUNT.ID[1,3]
    CALL CACHE.READ(FN.CURRENCY, VAR.ACCOUNT.ID1, R.CURRENCY, CURR.ERR) ;*AUTO R22 CODE CONVERSION
    IF R.CURRENCY NE '' THEN
        AF=TFS.PRO.PRIMARY.ACCT
        ETEXT='TT-CUST.ACCT'
        CALL STORE.END.ERROR
    END
    IF R.NEW(TFS.PRO.TOTAL.AMOUNT) NE Y.SUM THEN
        AF=TFS.PRO.TOTAL.AMOUNT
        ETEXT="EB-AMT.NOT.EQUAL"
        CALL STORE.END.ERROR
    END ELSE
        Y.TEMP.AMOUNT=R.NEW(TFS.PRO.TOTAL.AMOUNT)
        Y.TEMP.AMOUNT.FIR=FIELD(Y.TEMP.AMOUNT,'.',1)
        Y.TEMP.AMOUNT.DEC=FIELD(Y.TEMP.AMOUNT,'.',2)
        Y.TEMP.AMOUNT.DEC= FMT(Y.TEMP.AMOUNT.DEC,Y.LEN.CUR)
        R.NEW(TFS.PRO.TOTAL.AMOUNT) = Y.TEMP.AMOUNT.FIR:'.':Y.TEMP.AMOUNT.DEC
    END
RETURN
*------------------------------------------------------------------------------------
END
