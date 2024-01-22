* @ValidationCode : MjotMzM0MzI0NzE3OlVURi04OjE3MDU5MTY1NDA0ODY6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2024 15:12:20
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.ACCT.DEP.WDRL.CHNL(Y.FINAL.ARRAY)
*--------------------------------------------------------------------------
* Program Description:
*---------------------
* Subroutine Type   : ENQUIRY ROUTINE
* Attached to       : REDO.E.NOF.ACCT.DEP.WDRL.CHNL
* Attached as       : NOFILE ROUTINE
* Primary Purpose   : To return data to the enquiry

* Incoming:
* ---------
*
* Outgoing:
* ---------
* Y.FINAL.ARRAY - data returned to the enquiry
*--------------------------------------------------------------------------
* Modification History :
*-----------------------
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development BY  : Ramkumar. G  - Contractor@TAM
* DATE            : MARCH 15, 2011
*  DATE             WHO                   REFERENCE
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ , VM to @VM , FM to @FM and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 19.01.2024         Narmadha V            Manual R22 Conversion   Change ID Variable instead of Hardcoding
*------------------------------------------------------------------------
*--------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.EB.SYSTEM.ID
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LOCAL.TABLE
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.CURRENCY
    $INSERT I_F.TRANSACTION
*
    GOSUB INITIALISATION
    GOSUB PROCESS
*
RETURN

*--------------
INITIALISATION:
*--------------
*
    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
*
    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
*
    FN.FUNDS.TRANSFER$HIS = "F.FUNDS.TRANSFER$HIS"
    F.FUNDS.TRANSFER$HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)
*
    FN.FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION"
    F.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)
*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    FN.LOCAL.TABLE = "F.LOCAL.TABLE"
    F.LOCAL.TABLE = ""
    CALL OPF(FN.LOCAL.TABLE,F.LOCAL.TABLE)
*
    FN.CURRENCY = "F.CURRENCY"
    F.CURRENCY = ""
    CALL OPF(FN.CURRENCY,F.CURRENCY)
*
    Y.APPLICATION = "FT.TXN.TYPE.CONDITION"
    Y.FIELD = "L.FTTC.CHANNELS"
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELD,FTTC.LR.POSN)
    L.FTTC.CHANNELS = FTTC.LR.POSN<1,1>
*
    Y.FINAL.ARRAY = ''
*
RETURN

*-------
PROCESS:
*-------
*
    GOSUB GET.DATE.SELECTION
    GOSUB GET.CHANNEL.SELECTION
    GOSUB GET.TRAN.TYPE.SELECTION
    GOSUB GET.CURRENCY.SELECTION
    GOSUB PROCESS.SEL.RECORDS
*
RETURN

*------------------
GET.DATE.SELECTION:
*------------------
*
    Y.TRAN.DATE = ''
    LOCATE "TRANSACTION.DATE" IN D.FIELDS<1> SETTING PROCESSING.DATE.POS THEN
        Y.TRAN.DATE = D.RANGE.AND.VALUE<PROCESSING.DATE.POS>
        Y.OPERATOR = D.LOGICAL.OPERANDS<PROCESSING.DATE.POS>
        IF Y.OPERATOR EQ 2 THEN
            Y.TRANS.FROM.DATE = Y.TRAN.DATE<1,1,1>
            Y.TRANS.TO.DATE = Y.TRAN.DATE<1,1,2>
        END
    END
*
RETURN

*---------------------
GET.CHANNEL.SELECTION:
*---------------------
*
    Y.CHANNEL = ''; Y.CHAN = ''
    LOCATE "CHANNEL" IN D.FIELDS<1> SETTING CHANNEL.POS THEN
        Y.CHANNEL = D.RANGE.AND.VALUE<CHANNEL.POS>
    END
*
    IF Y.CHANNEL THEN
*CALL CACHE.READ(FN.LOCAL.TABLE,'578',R.LT.REC,SEL.ERR3)
        IDVAR.1 = '578' ;* Manual R22 Conversion
        CALL CACHE.READ(FN.LOCAL.TABLE,IDVAR.1,R.LT.REC,SEL.ERR3);*Manual R22 Conversion
        Y.CHN.LIST = R.LT.REC<EB.LTA.VETTING.TABLE>
        CHANGE @VM TO @FM IN Y.CHN.LIST
        LOCATE Y.CHANNEL IN Y.CHN.LIST<1> SETTING LT.POS THEN
            Y.CHAN = Y.CHANNEL
        END ELSE
            ENQ.ERROR = "EB-INVALID.CHANNEL.CODE"
            RETURN
        END
    END
*
RETURN

*-----------------------
GET.TRAN.TYPE.SELECTION:
*-----------------------
*
    Y.TRAN.TYPE = ''; K.TRAN.TYPE = ''
    LOCATE "TRANSACTION.TYPE" IN D.FIELDS<1> SETTING SYS.POS THEN
        Y.TRAN.TYPE = D.RANGE.AND.VALUE<SYS.POS>
    END
*
RETURN

*----------------------
GET.CURRENCY.SELECTION:
*----------------------
*
    Y.CURRENCY = ''
    LOCATE "CURRENCY" IN D.FIELDS<1> SETTING CURRENCY.POS THEN
        Y.CURRENCY = D.RANGE.AND.VALUE<CURRENCY.POS>
    END
*
RETURN

*-------------------
PROCESS.SEL.RECORDS:
*-------------------
*
    GOSUB FT.SELECTION
    GOSUB FT.HIS.LOOPING
    GOSUB FT.LOOPING
*
RETURN

*------------
FT.SELECTION:
*------------
*
    SEL.FT = 'SELECT ':FN.FUNDS.TRANSFER:' WITH @ID'
    SEL.FT.HIS = 'SELECT ':FN.FUNDS.TRANSFER$HIS:' WITH @ID SAVING UNIQUE EVAL "@ID[1,12]"'
*
    IF Y.CURRENCY THEN
        SEL.FT := ' AND DEBIT.CURRENCY EQ ':Y.CURRENCY
        SEL.FT.HIS := ' AND DEBIT.CURRENCY EQ ':Y.CURRENCY
    END
*
    IF Y.TRAN.DATE THEN
        IF Y.OPERATOR EQ 2 THEN
            SEL.FT := ' AND AUTH.DATE GE ':Y.TRANS.FROM.DATE:' AND AUTH.DATE LE ':Y.TRANS.TO.DATE
            SEL.FT.HIS := ' AND AUTH.DATE GE ':Y.TRANS.FROM.DATE:' AND AUTH.DATE LE ':Y.TRANS.TO.DATE
        END ELSE
            SEL.FT := ' AND AUTH.DATE EQ ':Y.TRAN.DATE
            SEL.FT.HIS := ' AND AUTH.DATE EQ ':Y.TRAN.DATE
        END
    END ELSE
        Y.DATE = '1M'
        CALL CALENDAR.DAY(TODAY,'-',Y.DATE)
        SEL.FT : = ' AND AUTH.DATE GT ':Y.DATE
        SEL.FT.HIS : = ' AND AUTH.DATE GT ':Y.DATE
    END
*
    IF Y.TRAN.TYPE THEN
        SEL.FT : = ' AND TRANSACTION.TYPE EQ ':Y.TRAN.TYPE
        SEL.FT.HIS : = ' AND TRANSACTION.TYPE EQ ':Y.TRAN.TYPE
    END
*
    CALL EB.READLIST(SEL.FT.HIS,SEL.FT.HIS.LIST,'',NO.OF.FT.HIS,FT.HIS..CODE)
    CALL EB.READLIST(SEL.FT,SEL.FT.LIST,'',NO.OF.FT,FT.CODE)
*
RETURN

*----------
FT.LOOPING:
*----------
*
    LOOP
        REMOVE Y.FT.ID FROM SEL.FT.LIST SETTING Y.FT.POS
    WHILE Y.FT.ID:Y.FT.POS
        CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FT,F.FUNDS.TRANSFER,Y.FT.ERR)
*
        Y.FTTC.ID = R.FT<FT.TRANSACTION.TYPE>
        GOSUB FTTC.CHANNEL.CHECKING
*
        IF Y.CHAN AND Y.CHAN NE Y.FTTC.CHANNEL THEN
            CONTINUE
        END
*
        GOSUB DEBIT.ACCT.CHECKING
*
        IF Y.AC.CUS EQ "" THEN
            CONTINUE
        END
*
        GOSUB CREDIT.ACCT.CHECKING
*
        IF Y.AC.CUS EQ "" THEN
            CONTINUE
        END
*
        GOSUB STMT.ID.BUILDING
        GOSUB STMT.LOOPING
*
    REPEAT
*
RETURN

*---------------------
FTTC.CHANNEL.CHECKING:
*---------------------
    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, Y.FTTC.ID, R.FTTC, Y.FTTC.ERR)    ;*R22 Auto Conversion  - F.READ to CACHE.READ
    Y.FTTC.CHANNEL = R.FTTC<FT6.LOCAL.REF,L.FTTC.CHANNELS>
RETURN

*-------------------
DEBIT.ACCT.CHECKING:
*-------------------
*
    Y.DEBIT.ACCT = R.FT<FT.DEBIT.ACCT.NO>
    CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCT,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
    Y.AC.CUS = R.ACCOUNT<AC.CUSTOMER>
*
RETURN

*--------------------
CREDIT.ACCT.CHECKING:
*--------------------
*
    Y.CREDIT.ACCT = R.FT<FT.CREDIT.ACCT.NO>
    CALL F.READ(FN.ACCOUNT,Y.CREDIT.ACCT,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
    Y.AC.CUS = R.ACCOUNT<AC.CUSTOMER>
*
RETURN

*--------------
FT.HIS.LOOPING:
*--------------
*
    LOOP
        REMOVE Y.FT.HIS.ID FROM SEL.FT.HIS.LIST SETTING Y.FT.HIS.POS
    WHILE Y.FT.HIS.ID:Y.FT.HIS.POS
        LOCATE Y.FT.HIS.ID IN SEL.FT.LIST SETTING Y.FOUND.POS THEN
            CONTINUE
        END
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER$HIS,Y.FT.HIS.ID,R.FT.HIS,Y.FT.HIS.ERR)
*
        Y.FTTC.ID = R.FT.HIS<FT.TRANSACTION.TYPE>
        GOSUB FTTC.CHANNEL.CHECKING
*
        IF Y.CHAN AND Y.CHAN NE Y.FTTC.CHANNEL THEN
            CONTINUE
        END
*
        Y.DEBIT.ACCT = R.FT.HIS<FT.DEBIT.ACCT.NO>
        CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCT,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
        Y.AC.CUS = R.ACCOUNT<AC.CUSTOMER>
        IF Y.AC.CUS EQ "" THEN
            CONTINUE
        END
*
        Y.CREDIT.ACCT = R.FT.HIS<FT.CREDIT.ACCT.NO>
        CALL F.READ(FN.ACCOUNT,Y.CREDIT.ACCT,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
        Y.AC.CUS = R.ACCOUNT<AC.CUSTOMER>
        IF Y.AC.CUS EQ "" THEN
            CONTINUE
        END
*
        GOSUB STMT.HIS.ID.BUILDING
        GOSUB STMT.LOOPING
*
    REPEAT
*
RETURN

*----------------
STMT.ID.BUILDING:
*----------------
*
    Y.STMT.ID.BASE = R.FT<FT.STMT.NOS,1>
    Y.TILL = R.FT<FT.STMT.NOS,2>
    Y.FROM = FIELD(Y.TILL,'-',1)
    Y.TO = FIELD(Y.TILL,'-',2)
    Y.CNTR = Y.FROM
*
RETURN

*--------------------
STMT.HIS.ID.BUILDING:
*--------------------
*
    Y.STMT.ID.BASE = R.FT.HIS<FT.STMT.NOS,1>
    Y.TILL = R.FT.HIS<FT.STMT.NOS,2>
    Y.FROM = FIELD(Y.TILL,'-',1)
    Y.TO = FIELD(Y.TILL,'-',2)
    Y.CNTR = Y.FROM
*
RETURN

*------------
STMT.LOOPING:
*------------
*
    LOOP
    WHILE Y.CNTR LE Y.TO
        Y.STMT.ID = Y.STMT.ID.BASE:'000':Y.CNTR
*
        GOSUB STMT.DETAILS.FETCH
*
        IF Y.AMT.OF.TRANS EQ "" THEN
            Y.CNTR += 1
            CONTINUE
        END
*
        IF Y.CURRENCY AND Y.CURRENCY NE Y.CURRENCY.1 THEN
            Y.CNTR += 1
            CONTINUE
        END
*
        GOSUB FINAL.ARRAY
*
        Y.CNTR += 1
    REPEAT
*
RETURN

*------------------
STMT.DETAILS.FETCH:
*------------------
*
    CALL F.READ(FN.STMT.ENTRY,Y.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,Y.SE.ERR)
*
    Y.PROCESSING.DATE = R.STMT.ENTRY<AC.STE.PROCESSING.DATE>
    Y.TRANS.CHANNEL   = Y.FTTC.CHANNEL
    Y.TYPE.OF.ACCT    = R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY>
    Y.ACCT.NUMBER     = R.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>
    Y.CURRENCY.1      = R.STMT.ENTRY<AC.STE.CURRENCY>
    Y.TYPE.OF.TRANS   = Y.FTTC.ID
    Y.TRANS.CODE      = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
    Y.AMT.LCY         = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
    Y.AMT.FCY         = R.STMT.ENTRY<AC.STE.AMOUNT.FCY>
    Y.AGENCY          = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
    Y.ACCT.OFFICER    = R.STMT.ENTRY<AC.STE.ACCOUNT.OFFICER>
    Y.INPUTTER        = R.STMT.ENTRY<AC.STE.INPUTTER>
    Y.AUTHORISER      = R.STMT.ENTRY<AC.STE.AUTHORISER>
    Y.OVERRIDE        = R.STMT.ENTRY<AC.STE.OVERRIDE>
*
    IF Y.CURRENCY.1 EQ LCCY THEN
        Y.AMT.OF.TRANS = Y.AMT.LCY
    END ELSE
        Y.AMT.OF.TRANS = Y.AMT.FCY
    END
*
RETURN

*-----------
FINAL.ARRAY:
*-----------
    IF Y.FINAL.ARRAY THEN
        Y.FINAL.ARRAY<-1> = Y.PROCESSING.DATE:"*":Y.TRANS.CHANNEL:"*":Y.TYPE.OF.ACCT:"*":Y.ACCT.NUMBER:"*":Y.CURRENCY.1:"*":Y.TYPE.OF.TRANS:"*":Y.TRANS.CODE:"*":Y.AMT.OF.TRANS:"*":Y.AGENCY:"*":Y.ACCT.OFFICER:"*":Y.INPUTTER:"*":Y.AUTHORISER:"*":Y.OVERRIDE
*                                 1                     2                   3                 4                5                 6                 7                  8               9              10                11              12              13
    END ELSE
        Y.FINAL.ARRAY = Y.PROCESSING.DATE:"*":Y.TRANS.CHANNEL:"*":Y.TYPE.OF.ACCT:"*":Y.ACCT.NUMBER:"*":Y.CURRENCY.1:"*":Y.TYPE.OF.TRANS:"*":Y.TRANS.CODE:"*":Y.AMT.OF.TRANS:"*":Y.AGENCY:"*":Y.ACCT.OFFICER:"*":Y.INPUTTER:"*":Y.AUTHORISER:"*":Y.OVERRIDE
*                             1                     2                   3                 4                5                 6                 7                  8               9              10                11              12              13
    END
RETURN
END
