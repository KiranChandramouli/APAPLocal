* @ValidationCode : MjoyMDExODA1MTg0OlVURi04OjE2ODQyMjI4MzY1NDE6SVRTUzotMTotMTo2NjE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:36
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 661
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.VAL.AA.CP.LOAN.STATUS

*---------------------------------------------------------------------------------
* Description: This routine is to validate the Account overdue balance and
*             special condition of AA overpayment through CASH & CHEQUE version.
*
* Version Involved:
*              VERSION>FT,REDO.MULTI.AA.ACRP.UPD.TR
*              VERSION>FT,REDO.MULTI.AA.ACRP.UPD
* Dev By: V.P.Ashokkumar
*
* Date : 10/10/2016
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED, FM TO @FM,VM TO @VM, ++ TO +=1
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   Call method format changed
*---------------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ARRANGEMENT ;*R22 AUTO CONVERSION END
    $USING APAP.REDOVER
    $USING APAP.TAM


    IF cTxn_CommitRequests EQ '1' THEN
        RETURN
    END

    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END

    GOSUB GET.LRF.POS
    GOSUB PROCESS
RETURN

*-----------
GET.LRF.POS:
*-----------
*----------------------------------------------------------------------
* This section gets the position of the local reference field positions
*----------------------------------------------------------------------

    LR.APP = 'AA.PRD.DES.OVERDUE':@FM:'FUNDS.TRANSFER':@FM:'ACCOUNT' ;*R22 AUTO CONVERSION START
    LR.FLDS = 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@FM
    LR.FLDS := 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@FM:'L.OD.STATUS' ;*R22 AUTO CONVERSION END
    LR.POS = ''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)
    OD.LOAN.STATUS.POS = LR.POS<1,1>
    OD.LOAN.COND.POS =  LR.POS<1,2>
    FT.LOAN.STATUS.POS = LR.POS<2,1>
    FT.LOAN.COND.POS =  LR.POS<2,2>
    POS.L.OD.STATUS  = LR.POS<3,1>

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'; F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'; F.AA.ARRANGEMENT =''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
RETURN

*-------
PROCESS:
*-------
*------------------------------------------------------------------------------------------------------------------------------------
* This section gets the latest overdue record for the arrangement id and stores the value of loan status and condition in R.NEW of FT
*------------------------------------------------------------------------------------------------------------------------------------
    IF NUM(COMI) THEN
        ACC.ID = COMI
        CALL F.READ(FN.ACCOUNT,COMI,R.ACCOUNT,F.ACCOUNT,AC.ERR)
        IF R.ACCOUNT THEN
            ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
            IF ARR.ID[1,2] NE 'AA' THEN
                ETEXT = 'EB-NOT.AA.AC'
                AF = FT.CREDIT.ACCT.NO
                CALL STORE.END.ERROR
            END
        END
    END ELSE
        ARR.ID = COMI
        CALL F.READ(FN.AA.ARRANGEMENT,COMI,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
        IF AA.ARRANGEMENT.ERR THEN
            ETEXT = "EB-NOT.AA.AC"
            CALL STORE.END.ERROR
            RETURN
        END ELSE
            ACC.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,1>
            R.ACCOUNT = ''; ACC.ERR = ''
            CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        END
    END

    ERR.AA.ACCOUNT.DET = ''; R.AA.ACCOUNT.DETAILS = ''; YARR.STATUS = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.AA.ACCOUNT.DET)
    YARR.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
    Y.SET.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    CHANGE @SM TO @FM IN Y.SET.STATUS ;*R22 AUTO CONVERSION
    CHANGE @VM TO @FM IN Y.SET.STATUS ;*R22 AUTO CONVERSION
    LOCATE 'UNPAID' IN Y.SET.STATUS<1> SETTING POS.DUE THEN
        ETEXT = 'EB-DUES.ARE.THERE'
        AF = FT.CREDIT.ACCT.NO
        CALL STORE.END.ERROR
        RETURN
    END

    IF R.ACCOUNT<AC.LOCAL.REF,POS.L.OD.STATUS> NE 'CUR' THEN
        ETEXT = 'EB-REDO.LOAN.STATUS'
        AF = FT.CREDIT.ACCT.NO
        CALL STORE.END.ERROR
        RETURN
    END
    Y.CUSID = R.ACCOUNT<AC.CUSTOMER>
    R.NEW(FT.ORDERING.CUST) = Y.CUSID
    R.NEW(FT.CREDIT.CURRENCY) = R.ACCOUNT<AC.CURRENCY>
*CALL REDO.V.VAL.DEFAULT.AMT
*R22 MANUAL CONVERSION
    CALL APAP.REDOVER.redoVValDefaultAmt() ;*R22 MANUAL CONVERSION
*CALL APAP.TAM.REDO.CK.PO.NORMAL.REP
*R22 MANUAL CONVERSION
    CALL APAP.TAM.redoCkPoNormalRep();*R22 MANUAL CONVERSION
    PROP.CLASS = 'OVERDUE'; PROPERTY = ''; R.Condition = ''; ERR.MSG = ''; EFF.DATE = ''
*CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
*R22 MANUAL CONVERSION
    CALL APAP.TAM.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG);*R22 MANUAL CONVERSION
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
    CHANGE @SM TO @VM IN LOAN.STATUS ;*R22 AUTO CONVERSION START
    CHANGE @SM TO @FM IN LOAN.COND
    Y.CNT = DCOUNT(LOAN.COND,@FM) ;*R22 AUTO CONVERSION END
    Y.START.VAL =1
    LOOP
    WHILE Y.START.VAL LE Y.CNT
        LOAN.COND1<-1> = LOAN.COND<Y.START.VAL>
        LOAN.COND1 = CHANGE(LOAN.COND1,@FM,@SM) ;*R22 AUTO CONVERSION
        R.NEW(FT.LOCAL.REF)<1,FT.LOAN.COND.POS> = LOAN.COND1
        Y.START.VAL += 1 ;*R22 AUTO CONVERSION
    REPEAT
    R.NEW(FT.LOCAL.REF)<1,FT.LOAN.STATUS.POS> = LOAN.STATUS

    CHANGE @SM TO @VM IN LOAN.STATUS ;*R22 AUTO CONVERSION
    CHANGE @SM TO @VM IN LOAN.COND1 ;*R22 AUTO CONVERSION

    IF ('JudicialCollection' MATCHES LOAN.STATUS) OR ('Write-off' MATCHES LOAN.STATUS) THEN
        ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
        AF = FT.CREDIT.ACCT.NO
        CALL STORE.END.ERROR
        RETURN
    END

    IF ('Legal' MATCHES LOAN.COND1) THEN
        ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
        AF = FT.CREDIT.ACCT.NO
        CALL STORE.END.ERROR
        RETURN
    END

RETURN
END
