$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.V.REGN16.AC.OPEN.UPDATE
*--------------------------------------------------------------------------------------------
* Subroutine Type : VERSION.CONTROL
* Attached to     : ACCOUNT VERSION.CONTROL As Auth rtn.
* Attached as     : AUTHORISATION.ROUTINE
* Primary Purpose : Capture the OPEN.DATE and update into concat table.
* Incoming:
* ---------
* N/A
* * Outgoing:
* ---------
* N/A
* Error Variables:
* ----------------
*
* *---------------------------------------------------------------------------------------------
* Development:
* ------------
* 17/Feb/14 - Gangadhar.S.V.
*             gangadhar@temenos.com
*M o d i f i c a t i o n  H i s t o r y :
*----------------------------------------
*   Date        Author             Modification Description
*
* 23-Feb-2015   V.P.Ashokkumar     PACS00309822 - Updating the REDO.APAP.ACCOUNT.ACT file for Account changes.
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE TAM.BP TO $INSERT AND VM TO @VM AND F.READ TO CACHE.READ AND REMOVED F.CURRENCY AND VAR1+ TO += 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.REDO.APAP.ACCOUNT.ACT

    GOSUB OPEN.FILES
    IF R.NEW(AC.CURRENCY) NE LCCY THEN
        GOSUB PROCESS
    END
    GOSUB PROCESS.ACCT.ACT
RETURN
*-----------------------------------------------------------------------------------------------
PROCESS:
********
    GOSUB READ.ACCT
    IF R.ACCOUNT ELSE
        CCY.VAL = R.NEW(AC.CURRENCY)
        R.CURRENCY = ''
        CURRENCY.ERR = ''
        CALL CACHE.READ(FN.CURRENCY, CCY.VAL, R.CURRENCY, CURRENCY.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.CURRENCY
        CCY.MKT.POS = ''
        LOCATE '1' IN R.CURRENCY<EB.CUR.CURRENCY.MARKET,1> SETTING CCY.MKT.POS THEN
            R.DR.REG.REGN16.AC.CONCAT = R.CURRENCY<EB.CUR.MID.REVAL.RATE,CCY.MKT.POS>
            CALL F.WRITE(FN.DR.REG.REGN16.AC,ID.NEW,R.DR.REG.REGN16.AC.CONCAT)
        END
    END
RETURN

READ.ACCT:
**********
    R.ACCOUNT = ''; ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
RETURN

OPEN.FILES:
***********
    FN.DR.REG.REGN16.AC = 'F.DR.REG.REGN16.AC'; F.DR.REG.REGN16.AC = ''
    CALL OPF(FN.DR.REG.REGN16.AC,F.DR.REG.REGN16.AC)
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.CURRENCY = 'F.CURRENCY'; F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)
    FN.REDO.APAP.ACCOUNT.ACT = 'F.REDO.APAP.ACCOUNT.ACT'; F.REDO.APAP.ACCOUNT.ACT =''
    CALL OPF(FN.REDO.APAP.ACCOUNT.ACT,F.REDO.APAP.ACCOUNT.ACT)
RETURN

PROCESS.ACCT.ACT:
*****************
    ACCOUNT.NO = ''; Y.CURR.OLD = ''; R.REDO.APAP.ACCOUNT.ACT = ''; YDTE.CURR= ''
    Y.CURR.OLD = R.OLD(AC.CURR.NO)
    IF NOT(Y.CURR.OLD) THEN
        RETURN
    END
    ACCOUNT.NO = ID.NEW
    YDTE.CURR = ACCOUNT.NO:"*":TODAY:"*":Y.CURR.OLD
    ACCOUNT.HIST.NO = ACCOUNT.NO:";":Y.CURR.OLD
    ERR.REDO.APAP.ACCOUNT.ACT = ''; R.REDO.APAP.ACCOUNT.ACT = ''; YACCT.CNT = ''; YACCT.CNT = '-1'

    CALL F.READ(FN.REDO.APAP.ACCOUNT.ACT,TODAY,R.REDO.APAP.ACCOUNT.ACT,F.REDO.APAP.ACCOUNT.ACT,ERR.REDO.APAP.ACCOUNT.ACT)
    IF R.REDO.APAP.ACCOUNT.ACT THEN
        YACCT.CNT = DCOUNT(R.REDO.APAP.ACCOUNT.ACT<REDO.ACC.ACT.ACCT.NO>,@VM)
        YACCT.CNT += 1
    END
    R.REDO.APAP.ACCOUNT.ACT<REDO.ACC.ACT.ACCT.NO,YACCT.CNT> = ACCOUNT.HIST.NO
    R.REDO.APAP.ACCOUNT.ACT<REDO.ACC.ACT.ACCT.DATE.CURR,YACCT.CNT> = YDTE.CURR
    CALL F.WRITE(FN.REDO.APAP.ACCOUNT.ACT,TODAY,R.REDO.APAP.ACCOUNT.ACT)
RETURN
END
