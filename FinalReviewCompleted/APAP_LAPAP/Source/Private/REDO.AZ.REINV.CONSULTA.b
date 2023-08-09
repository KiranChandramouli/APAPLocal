* @ValidationCode : MjotMTk4NTQzNjMwNjpDcDEyNTI6MTY5MDE2NzU1NzI3OTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.AZ.REINV.CONSULTA(SEL.ID)
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       $INCLUDE T24.BP to $INSERT
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_REDO.AZ.REINV.CONSULTA.COMMON


    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
******
    ACCT.ERR = ''; R.ACCOUNT = ''; YL.AC.AZ.ACC.REF = ''; YCATEG = ''; YFIN.ARRY = ''
    YOFS.COMPANY = ''; YREINV.VAL = ''; YWORK.BAL = ''; YINT.LIQACCT = ''; ACCT.ID = ''
    YFLD1 = ''; YFLD2 = ''; YFLD3 = ''; YFLD4 = ''; Y.CLOSE.DATE = ''
RETURN

PROCESS:
********
    IF LEN(SEL.ID) NE 10 THEN
        Y.CLOSE.DATE = FIELDS(SEL.ID, '-', 2)
        ACCT.ID = FIELDS(SEL.ID, '-', 1)
        GOSUB SUB.CLPROCESS
    END ELSE
        ACCT.ID = SEL.ID
        GOSUB READ.ACCOUNT
        AZ.ACCT.ID = SEL.ID
        GOSUB READ.AZ.ACCT
        GOSUB SUB.PROCESS
    END
RETURN

SUB.PROCESS:
************
    YWORK.BAL = R.ACCOUNT<AC.WORKING.BALANCE>
    YREINV.VAL = R.ACCOUNT<AC.LOCAL.REF,L.AC.REINVESTED.POS>
    IF YWORK.BAL GT 0 THEN
        RETURN
    END
    YFLD1 = R.AZ.ACCOUNT<AZ.CO.CODE>
    YFLD2 = R.AZ.ACCOUNT<AZ.CREATE.DATE>
    IF YREINV.VAL EQ 'YES' THEN
        YFLD3 = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
    END
    YFLD4 = R.ACCOUNT<AC.ACCOUNT.TITLE.1>
    YFIN.ARRY = YFLD1:',':YFLD2:',':SEL.ID:',':YFLD4:',':YFLD3
    FIL.ID = "ZERO-":ACCT.ID
    GOSUB WRITE.ARRY
RETURN

SUB.CLPROCESS:
**************
    AZ.ACCT.ID = ACCT.ID
    GOSUB READ.AZ.ACCT
    IF R.AZ.ACCOUNT THEN
        RETURN
    END
    GOSUB READ.ACCOUNT
    AZ.ERR = ''; R.AZ.ACCOUNT = ''; YOFS.COMPANY = ''; AZ.ACCT.ID.H = AZ.ACCT.ID
    CALL F.READ.HISTORY(FN.AZ.ACCOUNT.H,AZ.ACCT.ID.H,R.AZ.ACCOUNT,F.AZ.ACCOUNT.H,AZ.ERR)
    YFLD4 = R.ACCOUNT<AC.ACCOUNT.TITLE.1>
    YREINV.VAL = R.ACCOUNT<AC.LOCAL.REF,L.AC.REINVESTED.POS>
    YOFS.COMPANY = R.AZ.ACCOUNT<AZ.CO.CODE>
    R.ACCOUNT.L = R.ACCOUNT
    IF YREINV.VAL EQ 'YES' THEN
        YINT.LIQACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
        GOSUB REINV.ACCT.CHECK
    END
    IF R.ACCOUNT.L OR YINT.LIQACCT NE '' THEN
        YFIN.ARRY = YOFS.COMPANY:',':Y.CLOSE.DATE:',':AZ.ACCT.ID:',':YFLD4:',':YINT.LIQACCT
        FIL.ID = "NZERO-":ACCT.ID
        GOSUB WRITE.ARRY
    END
RETURN

REINV.ACCT.CHECK:
*****************
    ACCT.ID = YINT.LIQACCT
    GOSUB READ.ACCOUNT
    YCATEG = R.ACCOUNT<AC.CATEGORY>; YINT.LIQACCT = ''
    IF (YCATEG GE '6013' AND YCATEG LE '6020') THEN
        YINT.LIQACCT = ACCT.ID
    END
RETURN

WRITE.ARRY:
***********
    CALL F.WRITE(FN.DR.OPER.AZCONSL.WORKFILE,FIL.ID,YFIN.ARRY)
RETURN

READ.AZ.ACCT:
*************
    AZ.ERR = ''; R.AZ.ACCOUNT = ''
    CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
RETURN

READ.ACCOUNT:
*************
    R.ACCOUNT = ''; ACCT.ERR = ''
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
RETURN
END
