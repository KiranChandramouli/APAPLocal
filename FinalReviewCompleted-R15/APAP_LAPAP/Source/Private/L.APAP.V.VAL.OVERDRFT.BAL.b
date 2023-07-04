* @ValidationCode : MjoxODYwNDIwNzkwOkNwMTI1MjoxNjgyMzM1OTQ0NDY3OklUU1M6LTE6LTE6MTg1OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 185
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 VM TO @VM, FM TO @FM, BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.V.VAL.OVERDRFT.BAL
*

    $INSERT I_COMMON ;* AUTO CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ENQUIRY
    $INSERT I_ENQUIRY.COMMON ;* AUTO CODE CONVERSION END

    GOSUB READ.ACCOUNT
    GOSUB FT.PROCESS
RETURN

FT.PROCESS:
***********
    YTRAN.AMT = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TRANS.AMT>

    IF YTRAN.AMT EQ '' THEN


        YTRAN.AMT = YDEBIT.AMT

    END

***todo
    IF YTRAN.AMT GT Y.USABLE.BAL OR Y.BALANCE LT 0 OR Y.LOCK GT Y.BALANCE   THEN
        AF = FT.DEBIT.ACCT.NO
        ETEXT  = 'EB-REDO.ACCT.UNAUTH.OD'
        CALL STORE.END.ERROR
    END

RETURN

READ.ACCOUNT:
**************
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    ERR.ACCOUNT = ''; R.ACCOUNT = ''; Y.ACCOUNT.BALANCE = 0
    Y.TRANSIT.AMOUNT = ''; Y.L.AC.AVL.BAL = ''; YVAL.POSN = ''
    YACTUAL.AMT = 0; YTRAN.AMT = ''

    YFILE.NAME = 'ACCOUNT':@FM:'FUNDS.TRANSFER'
    YFIELD.NME = 'L.AC.AV.BAL':@VM:'L.AC.TRAN.AVAIL':@FM:'L.TT.TRANS.AMT'
    CALL MULTI.GET.LOC.REF(YFILE.NAME,YFIELD.NME,YVAL.POSN)
    POS.AVL.BAL = YVAL.POSN<1,1>
    POS.TRANS.AMT = YVAL.POSN<1,2>
    POS.L.TT.TRANS.AMT = YVAL.POSN<2,1>

    YDEBIT.ACCT = ''
    YDEBIT.ACCT = R.NEW(FT.DEBIT.ACCT.NO)

    YDEBIT.AMT = R.NEW(FT.DEBIT.AMOUNT)

    IF NOT(YDEBIT.AMT) THEN

        YDEBIT.AMT = R.NEW(FT.CREDIT.AMOUNT)

    END

    CALL F.READ(FN.ACCOUNT,YDEBIT.ACCT,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
*Y.TRANSIT.AMOUNT  = R.ACCOUNT<AC.LOCAL.REF,POS.TRANS.AMT>
*Y.L.AC.AVL.BAL    = R.ACCOUNT<AC.LOCAL.REF,POS.AVL.BAL>

    O.DATA = YDEBIT.ACCT
    CALL E.TOTAL.LOCK.AMT
    Y.LOCK = O.DATA
    Y.BALANCE = R.ACCOUNT<AC.WORKING.BALANCE>
    Y.USABLE.BAL  = Y.BALANCE + YDEBIT.AMT - Y.LOCK

RETURN

END
