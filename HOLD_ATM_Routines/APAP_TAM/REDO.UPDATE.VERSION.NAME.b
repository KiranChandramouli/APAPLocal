* @ValidationCode : MjoxMDM0NTg3ODIzOkNwMTI1MjoxNjgyNjgxOTE5ODIzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Apr 2023 17:08:39
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

SUBROUTINE REDO.UPDATE.VERSION.NAME
*-----------------------------------------------------------------------------
* Modification History
* Date          who                Reference            Description
*
* 07-03-2012    RIYAS              ODR-2012-03-0162     Initial Creation
* 05/03/2013    Vignesh Kumaar R   PACS00245176         TELLER Reversal should go for single auth
* 27/09/2013    Vignesh Kumaar R   PACS00317357         REMOVE THE OVERRIDE - AUTO SUPPRESS
* 28.04.2023    Conversion Tool       R22               Auto Conversion     - No changes
* 28.04.2023    Shanmugapriya M       R22               Manual Conversion   - FM TO @FM, VM TO @VM, SM TO @SM
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.APAP.STO.DUPLICATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.FOREX
    $INSERT I_GTS.COMMON


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    BEGIN CASE

        CASE APPLICATION EQ "TELLER"

            GOSUB PROCESS.TT

        CASE APPLICATION EQ "FUNDS.TRANSFER"

            GOSUB PROCESS.FT

        CASE APPLICATION EQ "T24.FUND.SERVICES"

            Y.REV.MARK = R.NEW(TFS.REVERSAL.MARK)
            IF Y.REV.MARK<1,1> NE 'R' THEN
                R.NEW(TFS.LOCAL.REF)<1,LOC.TFS.VER.POS> = APPLICATION:PGM.VERSION
                R.NEW(TFS.LOCAL.REF)<1,LTFS.INP.USER.ID.POS> = OPERATOR
            END

        CASE APPLICATION EQ "REDO.APAP.STO.DUPLICATE"

            R.NEW(REDO.SO.VERSION.NAME) = APPLICATION:PGM.VERSION
            VAR.ORIGIN.ACCT.NO = R.NEW(REDO.SO.ORIGIN.ACCT.NO)
            CALL F.READ(FN.ACCOUNT,VAR.ORIGIN.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            VAR.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
            R.NEW(REDO.SO.ORIGIN.ACCT.CUST) = VAR.CUSTOMER

        CASE APPLICATION EQ "FOREX"
            Y.VERSION.NAME = APPLICATION:PGM.VERSION
            R.NEW(FX.LOCAL.REF)<1,LOC.FX.VER.POS> = Y.VERSION.NAME

    END CASE

RETURN

PROCESS.FT:
***********
    R.NEW(FT.LOCAL.REF)<1,LOC.FT.VER.POS> = APPLICATION:PGM.VERSION
    IF V$FUNCTION NE 'R' THEN
        R.NEW(FT.LOCAL.REF)<1,LFT.INP.USER.ID.POS> = OPERATOR
    END
    IF V$FUNCTION EQ 'R' AND PGM.VERSION EQ ',REDO.REV.TXN' THEN
        GET.OVERRIDE.INFO = R.NEW(FT.OVERRIDE)
        TEXT = 'REDO.TELLER.SINGLE.AUTH'
        CALL STORE.OVERRIDE('')

        POS.FM.TT = ''
        POS.VM.TT = ''

        GOSUB OVR.FT
    END

    IF V$FUNCTION EQ 'R' THEN
        GOSUB WRITE.TT.TODAY
    END

*FIX FOR PACS00307767 -ISSUE START
    GOSUB CHECK.CASH.ACCT
*FIX FOR PACS00307767 -ISSUE END
RETURN

PROCESS.TT:
************
    R.NEW(TT.TE.LOCAL.REF)<1,LOC.TT.VER.POS> = APPLICATION:PGM.VERSION
    IF V$FUNCTION NE 'R' THEN
        R.NEW(TT.TE.LOCAL.REF)<1,LTT.INP.USER.ID.POS> = OPERATOR
    END

* Fix for PACS00245176 [TELLER Reversal should go for single auth]

    IF V$FUNCTION EQ 'R' THEN

        GET.OVERRIDE.INFO = R.NEW(TT.TE.OVERRIDE)
        TEXT = 'REDO.TELLER.SINGLE.AUTH'
        CALL STORE.OVERRIDE('')

        POS.FM.TT = ''
        POS.VM.TT = ''
        GOSUB WRITE.TT.TODAY
*            GOSUB OVR.TT ;* Fix for PACS00317357 [REMOVE THE OVERRIDE - AUTO SUPPRESS]
    END
* End of Fix
RETURN
*----------------------------------------------------------------------------
*FIX FOR PACS00307767 -ISSUE START
********************
CHECK.CASH.ACCT:
******************
*Cash Accounts are not allowed if the category parameterised in TELLER.PARAMETER
* Also checks the the overdraft of NOSTRO accounts

    Y.DEBIT.ACCT = R.NEW(FT.DEBIT.ACCT.NO)
    Y.CREDIT.ACCT = R.NEW(FT.CREDIT.ACCT.NO)
    VAR.AMOUNT  = R.NEW(FT.DEBIT.AMOUNT)
    IF NOT(VAR.AMOUNT) THEN
        VAR.AMOUNT = R.NEW(FT.CREDIT.AMOUNT)
    END

    IF Y.DEBIT.ACCT NE "" THEN
        R.ACCOUNT = '' ; Y.AC.CATEG = '' ; AC.ERR = '' ; Y.TEL.PARAM.ID = ''
        CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCT,R.ACCOUNT,F.ACCOUNT,AC.ERR)
        IF R.ACCOUNT NE "" THEN
*IF R.ACCOUNT<AC.LIMIT.REF> EQ 'NOSTRO' THEN ;*Lines commented cos We need to check incase if nostro account goes to positive balance.
*GOSUB NOSTRO.OVERDRAFT
*END
            Y.TEL.PARAM.ID = R.ACCOUNT<AC.CO.CODE>
            Y.AC.CATEG = R.ACCOUNT<AC.CATEGORY>
            AF = FT.DEBIT.ACCT.NO
            GOSUB READ.TFS.PARAM
        END
    END
    IF Y.CREDIT.ACCT EQ "" THEN
        RETURN
    END
    R.ACCOUNT = '' ; Y.AC.CATEG = '' ; AC.ERR = '' ; Y.TEL.PARAM.ID = ''
    CALL F.READ(FN.ACCOUNT,Y.CREDIT.ACCT,R.ACCOUNT,F.ACCOUNT,AC.ERR)
    IF R.ACCOUNT NE "" THEN
        IF R.ACCOUNT<AC.LIMIT.REF> EQ 'NOSTRO' THEN
            GOSUB NOSTRO.OVERDRAFT
        END
        Y.TEL.PARAM.ID = R.ACCOUNT<AC.CO.CODE>
        Y.AC.CATEG = R.ACCOUNT<AC.CATEGORY>
        AF = FT.CREDIT.ACCT.NO
        GOSUB READ.TFS.PARAM
    END
RETURN
*----------------------------------------------------------------------------
NOSTRO.OVERDRAFT:
*----------------------------------------------------------------------------

    Y.AMOUNT    = R.ACCOUNT<AC.LOCAL.REF,POS.AC.AV.BAL> * -1
    ACC.CUR     = R.ACCOUNT<AC.CURRENCY>
    VAR.ACCOUNT = Y.DEBIT.ACCT

    Y.NEW.BALANCE = Y.AMOUNT - VAR.AMOUNT
*IF Y.AMOUNT LT VAR.AMOUNT THEN
*OD.AMOUNT = VAR.AMOUNT - Y.AMOUNT
    IF Y.NEW.BALANCE LT 0 THEN  ;* When nostro acc goes to postive balance then we need to raise override.
        TEXT = "REDO.NOSTRO.OD"
        CALL STORE.OVERRIDE('')
    END

RETURN
*----------------------------------------------------------------------------
*==============
READ.TFS.PARAM:
*==============
    R.TELLER.PARAMETER = '' ; TEL.ERR= ''
    CALL F.READ(FN.TELLER.PARAMETER,Y.TEL.PARAM.ID,R.TELLER.PARAMETER,F.TELLER.PARAMETER,TEL.ERR)
    Y.TEL.PARAM.CATEG = R.TELLER.PARAMETER<TT.PAR.TRAN.CATEGORY>
    LOCATE Y.AC.CATEG IN Y.TEL.PARAM.CATEG<1,1> SETTING CATEG.POS THEN
        ETEXT = "EB-CASH.ACCT.NOT.ALLOW"
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------------------------------------
*FIX FOR PACS00307767 -ISSUE END
**********
OVR.FT:
*********
    Y.STORED.OVERRIDES = R.NEW(FT.OVERRIDE)
    FINDSTR 'REDO.TELLER.SINGLE.AUTH' IN Y.STORED.OVERRIDES SETTING POS.FM.TT,POS.VM.TT THEN
        GET.OFS.MSG.VAL = FIELD(Y.STORED.OVERRIDES,@VM,POS.VM.TT)
        GET.OFS.MSG = FIELD(FIELD(GET.OFS.MSG.VAL,'}',2),@SM,1)

        FINDSTR GET.OFS.MSG IN OFS$OVERRIDES<1> SETTING POS.FM.OVR,POS.VM.OVR THEN
            OFS$OVERRIDES<2,POS.VM.OVR> = "YES"
        END
    END

RETURN
*----------------------------------------------------------------------------
**************
OVR.TT:
************

    Y.STORED.OVERRIDES = R.NEW(TT.TE.OVERRIDE)
    FINDSTR 'REDO.TELLER.SINGLE.AUTH' IN Y.STORED.OVERRIDES SETTING POS.FM.TT,POS.VM.TT THEN
        GET.OFS.MSG.VAL = FIELD(Y.STORED.OVERRIDES,@VM,POS.VM.TT)
        GET.OFS.MSG = FIELD(FIELD(GET.OFS.MSG.VAL,'}',2),@SM,1)

        FINDSTR GET.OFS.MSG IN OFS$OVERRIDES<1> SETTING POS.FM.OVR,POS.VM.OVR THEN
            OFS$OVERRIDES<2,POS.VM.OVR> = "YES"
        END
    END
RETURN

WRITE.TT.TODAY:
***************
    VAR.TXN.ID = ID.NEW
    RTRT.ERR = ''; R.REDO.TT.REVE.TODAY = ''
    CALL F.READ(FN.REDO.TT.REVE.TODAY,TODAY,R.REDO.TT.REVE.TODAY,F.REDO.TT.REVE.TODAY,RTRT.ERR)
    IF R.REDO.TT.REVE.TODAY THEN
        R.REDO.TT.REVE.TODAY<-1> = VAR.TXN.ID
    END ELSE
        R.REDO.TT.REVE.TODAY = VAR.TXN.ID
    END
    CALL F.WRITE(FN.REDO.TT.REVE.TODAY,TODAY,R.REDO.TT.REVE.TODAY)
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    LREF.APP = 'FUNDS.TRANSFER':@FM:'TELLER':@FM:'T24.FUND.SERVICES':@FM:'ACCOUNT':@FM:'FOREX'
    LREF.FIELDS = 'L.ACTUAL.VERSIO':@VM:'L.INP.USER.ID':@FM:'L.ACTUAL.VERSIO':@VM:'L.INP.USER.ID':@FM:'L.T24FS.TRA.DAY':@VM:'L.INP.USER.ID':@FM:'L.AC.AV.BAL':@FM:'L.ACTUAL.VERSIO'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    LOC.FT.VER.POS  = LREF.POS<1,1>
    LFT.INP.USER.ID.POS = LREF.POS<1,2>
    LOC.TT.VER.POS  = LREF.POS<2,1>
    LTT.INP.USER.ID.POS = LREF.POS<2,2>
    LOC.TFS.VER.POS = LREF.POS<3,1>
    LTFS.INP.USER.ID.POS = LREF.POS<3,2>
    POS.AC.AV.BAL   = LREF.POS<4,1>
    LOC.FX.VER.POS  = LREF.POS<5,1>
RETURN

*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    F.TELLER.PARAMETER = ''
    CALL OPF(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

    FN.REDO.TT.REVE.TODAY = 'F.REDO.TT.REVE.TODAY'
    F.REDO.TT.REVE.TODAY = ''
    CALL OPF(FN.REDO.TT.REVE.TODAY,F.REDO.TT.REVE.TODAY)
RETURN
*-----------------------------------------------------------------------------

END
