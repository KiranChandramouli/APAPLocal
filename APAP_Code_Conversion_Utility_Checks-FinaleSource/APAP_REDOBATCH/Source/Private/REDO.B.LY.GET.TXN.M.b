* @ValidationCode : Mjo1NDA0ODYyMTk6Q3AxMjUyOjE2OTM1NzM0MzQ4Mjk6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 01 Sep 2023 18:33:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.GET.TXN.M(ACCT.ENT.TODAY.ID)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is attached as batch job in the batch record BNK/REDO.B.LY.GET.TXN.M
* This routine updates REDO.LY.TXN.BY.MOD file with information such as TRANSACTION ID, ACCOUNT NO
* CURRENCY & AMOUNT of transaction in local currency
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  :
* ACCT.ENT.TODAY.ID - @ID of the file ACCT.ENT.TODAY
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar  ODR-2009-12-0276      Initial Creation
* 30-JUN-2011      RMONDRAGON         PENDING           Fix for PACS00077575
* 30-JUL-2011      VNAVA          ODR-2011-06-0243      Update for C/I Identification
*                  RMONDRAGON
* 09-AUG-2011      VNAVA          ODR-2011-06-0243      Conditions for Including and Excluding Txns
* 16-MAY-2013      RMONDRAGON     ODR-2011-06-0243      Update for general txn identification
* 31-JUN-2013      RMONDRAGON     ODR-2011-06-0243      Update for general txn identification
* 13-NOV-2013      RMONDRAGON     ODR-2011-06-0243      Fix to generate points for programs with same setup
* 31-DEC-2013      RMONDRAGON     ODR-2011-06-0243      Update
* Date                   who                   Reference
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND ++ TO += 1 AND I TO I.VAR
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES

*---------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION

    *$INSERT I_F.ATM.REVERSAL
	$INSERT I_F.ATM.TRANSACTION

    $INSERT I_REDO.B.LY.GET.TXN.M.COMMON

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------
*-------------------------------------------------------------------------------------------
* This section gets all the STMT.ENTRY id from ACCT.ENT.TODAY.ID for the incoming ACCOUNT NO
*  and transfers the control to appropriate section to process and update in file
*-------------------------------------------------------------------------------------------

    R.ACCT.ENT.TODAY = ''
    ACCT.ENT.TODAY.ERR = ''

    CRT 'PROCESSING ACCOUNT NO. ':ACCT.ENT.TODAY.ID:'...'

    CALL F.READ(FN.ACCT.ENT.TODAY,ACCT.ENT.TODAY.ID,R.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY,ACCT.ENT.TODAY.ERR)

    STMT.ENTRY.ID = ''
    STMT.ENTRY.ID.POS = ''

    LOOP
        REMOVE STMT.ENTRY.ID FROM R.ACCT.ENT.TODAY SETTING STMT.ENTRY.ID.POS
    WHILE STMT.ENTRY.ID:STMT.ENTRY.ID
        R.STMT.ENTRY = ''; STMT.ENTRY.ERR = ''
        CALL F.READ(FN.STMT.ENTRY,STMT.ENTRY.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
        TXN.CUS = ''
        GOSUB ASSIGN.VAL
        IF TXN.CUS NE '' THEN
            GOSUB CHECK.MODALITY
        END
    REPEAT

RETURN

*----------
ASSIGN.VAL:
*----------
*-----------------------------------------------------------------------
* This section assigns the value from STMT.ENTRY record to the variables
*-----------------------------------------------------------------------

    TXN.CCY = ''
    TXN.CODE = ''
    TXN.REF = ''
    TXN.ID = ''
    SYS.ID = ''
    TXN.CH = ''
    TXN.AMT = ''
    TXN.FROM.COMP = 0

    TXN.CCY  = R.STMT.ENTRY<AC.STE.CURRENCY>
    TXN.CODE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
    TXN.REF  = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
    TXN.FROM.COMP = DCOUNT(TXN.REF,'\')
    IF TXN.FROM.COMP EQ 2 THEN
        TXN.ID = FIELD(TXN.REF,'\',1)
    END ELSE
        TXN.ID = TXN.REF
    END
    SYS.ID = R.STMT.ENTRY<AC.STE.SYSTEM.ID>
    IF SYS.ID EQ 'FT' THEN
        GOSUB GET.TXN.CHANNEL
        TXN.CH = Y.CHANNEL
    END ELSE
        IF SYS.ID EQ 'TT' THEN
            TXN.CH = 'TT'
        END ELSE
            RETURN
        END
    END
    TXN.AMT = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>

RETURN

***************
CHECK.MODALITY:
***************

    Y.TOT.CCY.MOD = ''
    Y.CCY.MOD = ''
    IND.MOD.APP.LIST = ''
    Y.TOT.MOD.APP.LIST = ''
    Y.MOD.APP = ''
    TXN.REF.APP = ''
    APP.MOD.TXN.CODE = ''
    Y.TOT.APP.MOD.TXN.CODE = ''
    APP.MOD.TXN.CODE.SPEC = ''
    FORM.GEN.MOD = ''
    GEN.FACT.MOD = ''

    FILE.UPDATED = 0
    Y.TOT.CCY.MOD = DCOUNT(MODALITY.CCY.LIST,@FM)
    CCY.POS = 1
    LOOP
    WHILE CCY.POS LE Y.TOT.CCY.MOD
        Y.CCY.MOD = FIELD(MODALITY.CCY.LIST,@FM,CCY.POS)
        IF TXN.CCY EQ Y.CCY.MOD THEN
            IND.MOD.APP.LIST = MODALITY.APP.TXN.LIST<CCY.POS>
            Y.TOT.MOD.APP.LIST = DCOUNT(IND.MOD.APP.LIST,@VM)
            APP.POS = 1
            LOOP
            WHILE APP.POS LE Y.TOT.MOD.APP.LIST
                Y.MOD.APP = FIELD(IND.MOD.APP.LIST,@VM,APP.POS)
                TXN.REF.APP = SYS.ID
                FILE.CONTENT = ''
                REC.ID = ''
                IF TXN.REF.APP EQ Y.MOD.APP THEN
                    APP.MOD.TXN.CODE = MODALITY.TXN.CODE.LIST<CCY.POS,APP.POS>
                    Y.TOT.APP.MOD.TXN.CODE = DCOUNT(APP.MOD.TXN.CODE,@SM)
                    TXN.CODE.POS = 1
                    LOOP
                    WHILE TXN.CODE.POS LE Y.TOT.APP.MOD.TXN.CODE
                        APP.MOD.TXN.CODE.SPEC = FIELD(APP.MOD.TXN.CODE,@SM,TXN.CODE.POS)
                        IF TXN.CODE EQ APP.MOD.TXN.CODE.SPEC THEN
                            FORM.GEN.MOD = MODALITY.FORM.GEN.LIST<CCY.POS>
                            GEN.FACT.MOD = MODALITY.GEN.FACT.LIST<CCY.POS>
                            GOSUB CHK.MOD
                            TXN.CODE.POS = Y.TOT.APP.MOD.TXN.CODE
                        END
                        IF TXN.CODE.POS EQ Y.TOT.APP.MOD.TXN.CODE THEN
                            APP.POS = Y.TOT.MOD.APP.LIST
                        END
                        TXN.CODE.POS += 1
                    REPEAT
                END
                APP.POS += 1
            REPEAT
        END
        CCY.POS += 1
    REPEAT

RETURN

*-------
CHK.MOD:
*-------

    IF FORM.GEN.MOD EQ '2' THEN
        IF TXN.AMT LT 0 THEN
            TXN.AMT.OP = NEG(TXN.AMT)
            GOSUB CHECK.APP.MATCH
            IF FILE.UPDATED EQ 1 THEN
                RETURN
            END
        END
    END ELSE
        GOSUB CHECK.APP.MATCH
        IF FILE.UPDATED EQ 1 THEN
            RETURN
        END
    END

RETURN

*-----------
CHK.PRODUCT:
*-----------

    TXN.PROD = ''
    VAR.PROD.LIST = MODALITY.PROD.LIST<CCY.POS>
    R.ACCOUNT = ''; ACCT.ERR = ''
    CALL F.READ(FN.ACCOUNT,TXN.ACCT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    IF R.ACCOUNT THEN
        TXN.PROD = R.ACCOUNT<AC.CATEGORY>
        CHANGE @VM TO @FM IN VAR.PROD.LIST
        LOCATE TXN.PROD IN VAR.PROD.LIST SETTING PROD.POS ELSE
            FILE.UPD.STOP = 1
        END
    END

RETURN

*----------------
CHECK.EXCINC.COND:
*----------------

    EXCOTYES.MOD = ''
    APPEXC.MOD = ''
    EXCOTYPE.MOD = ''
    INCOTYES.MOD = ''
    APPINC.MD = ''
    INCOTYPE.MOD = ''
    PRODTYPE.MOD = ''

    EXCOTYES.MOD = PROGRAM.EXCCONDTYPE.ESP.LIST<CCY.POS>
    APPEXC.MOD   = PROGRAM.APPEXC.LIST<CCY.POS>
    EXCOTYPE.MOD = PROGRAM.EXCCONDTYPE.LIST<CCY.POS>
    INCOTYES.MOD = PROGRAM.INCCONDTYPE.ESP.LIST<CCY.POS>
    APPINC.MOD   = PROGRAM.APPINC.LIST<CCY.POS>
    INCOTYPE.MOD = PROGRAM.INCCONDTYPE.LIST<CCY.POS>
    PRODTYPE.MOD = MODALITY.PROD.TYPE.LIST<CCY.POS>

    IF PRODTYPE.MOD EQ "T.Debito" THEN

        IF EXCOTYPE.MOD NE '' THEN
            BEGIN CASE
                CASE EXCOTYES.MOD EQ "MCC.TDEBITO"
                    FILE.UPD.STOP = ''
                    GOSUB COMP.MMC.EX
                CASE EXCOTYES.MOD EQ "MERCHANTID.TDEBITO"
                    FILE.UPD.STOP = ''
                    GOSUB COMP.MID.EX
            END CASE
        END ELSE
            FILE.UPD.STOP = 1
        END

        BEGIN CASE
            CASE INCOTYES.MOD EQ "MCC.TDEBITO"
                GOSUB COMP.MMC.IN
            CASE INCOTYES.MOD EQ "MERCHANTID.TDEBITO"
                GOSUB COMP.MID.IN
        END CASE

    END

    IF EXCOTYES.MOD EQ 'ESTADO.CUENTA' THEN
        R.ACCOUNT = ''; ACCT.ERR = ''
        CALL F.READ(FN.ACCOUNT,TXN.ACCT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        IF R.ACCOUNT THEN
            Y.AC.STATUS1 = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.STATUS1>
            Y.AC.STATUS2 = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.STATUS2>
        END

        IF APPEXC.MOD EQ 'ESPECIFICA' THEN
            FILE.UPD.STOP = ''
            GOSUB CHECK.STATUS.FOR.EXC
        END ELSE
            FILE.UPD.STOP = ''
            Y.PROC.INC.COND = 1
        END

        IF Y.PROC.INC.COND EQ '1' THEN
            IF APPINC.MOD EQ 'ESPECIFICA' THEN
                GOSUB CHECK.STATUS.FOR.INC
            END
        END
    END

RETURN

*--------------------
CHECK.STATUS.FOR.EXC:
*--------------------

    LOOP
        REMOVE EXC.EST.ACCT.ID FROM EXCOTYPE.MOD SETTING EXC.EST.ACCT.ID.POS
    WHILE EXC.EST.ACCT.ID:EXC.EST.ACCT.ID.POS
        IF EXC.EST.ACCT.ID EQ Y.AC.STATUS1 OR EXC.EST.ACCT.ID EQ Y.AC.STATUS2 THEN
            Y.PROC.INC.COND = 0
            FILE.UPD.STOP = 1
            RETURN
        END ELSE
            Y.PROC.INC.COND = 1
        END
    REPEAT

RETURN

*--------------------
CHECK.STATUS.FOR.INC:
*--------------------

    CHECK.NEXT.STATUS = 'N'
    LOOP
        REMOVE INC.EST.ACCT.ID FROM INCOTYPE.MOD SETTING INC.EST.ACCT.ID.POS
    WHILE INC.EST.ACCT.ID:INC.EST.ACCT.ID.POS
        IF INC.EST.ACCT.ID NE Y.AC.STATUS1 THEN
            CHECK.NEXT.STATUS = 'Y'
        END
        IF CHECK.NEXT.STATUS EQ 'Y' THEN
            IF INC.EST.ACCT.ID NE Y.AC.STATUS2 THEN
                FILE.UPD.STOP = 1
            END
        END
    REPEAT

RETURN

*-------------
COMP.MMC.EX:
*-------------

    CHANGE @VM TO @FM IN EXCOTYPE.MOD
    LOCATE "MCC.TDEBITO" IN EXCOTYES.MOD SETTING Y.EXCT.POS THEN
        Y.CNT.CONDT = '' ; CNT.EXC = '' ; Y.ATM.MMRCAT = ''
        Y.CNT.CONDT = DCOUNT(EXCOTYPE.MOD,@FM)
        FOR I.VAR=1 TO Y.CNT.CONDT
            Y.MERCH.CAT = ''
            Y.MERCH.CAT = EXCOTYPE.MOD<I.VAR>
            GOSUB GET.ATM.MERCH
            IF Y.ATM.MMRCAT NE "" AND Y.MERCH.CAT EQ Y.ATM.MMRCAT THEN
                CNT.EXC += 1
            END
        NEXT I.VAR
        IF CNT.EXC GT 0 THEN
            FILE.UPD.STOP = 1
        END
    END

RETURN

*-------------
COMP.MID.EX:
*-------------

    CHANGE @VM TO @FM IN EXCOTYPE.MOD
    LOCATE "MERCHANTID.TDEBITO" IN EXCOTYES.MOD SETTING Y.EXCT.POS THEN
        Y.CNT.CONDT = '' ; CNT.EXC = '' ; Y.ATM.MMRID = ''
        Y.CNT.CONDT = DCOUNT(EXCOTYPE.MOD,@FM)
        FOR I.VAR=1 TO Y.CNT.CONDT
            Y.MERCH.ID = ''
            Y.MERCH.ID = EXCOTYPE.MOD<I.VAR>
            GOSUB GET.ATM.MERCH
            IF Y.ATM.MMRID NE "" AND Y.MERCH.ID EQ Y.ATM.MMRID THEN
                CNT.EXC += 1
            END
        NEXT I.VAR
        IF CNT.EXC GT 0 THEN
            FILE.UPD.STOP = 1
        END
    END

RETURN

*-------------
COMP.MMC.IN:
*-------------

    CHANGE @VM TO @FM IN INCOTYPE.MOD
    LOCATE "MCC.TDEBITO" IN INCOTYES.MOD SETTING Y.INCT.POS THEN
        Y.CNT.CONDT = '' ; CNT.INC = '' ; Y.ATM.MMRCAT = ''
        Y.CNT.CONDT = DCOUNT(INCOTYPE.MOD,@FM)
        FOR I.VAR=1 TO Y.CNT.CONDT
            Y.MERCH.CAT = ''
            Y.MERCH.CAT = INCOTYPE.MOD<I.VAR>
            GOSUB GET.ATM.MERCH
            IF Y.ATM.MMRCAT NE "" AND Y.MERCH.CAT EQ Y.ATM.MMRCAT THEN
                CNT.INC += 1
            END
        NEXT I.VAR
        IF CNT.INC LT 1 AND Y.ATM.MMRCAT NE "" THEN
            FILE.UPD.STOP = 1
        END ELSE
            FILE.UPD.STOP = ''
        END
    END

RETURN

*-------------
COMP.MID.IN:
*-------------

    CHANGE @VM TO @FM IN INCOTYPE.MOD
    LOCATE "MERCHANTID.TDEBITO" IN INCOTYES.MOD SETTING Y.INCT.POS THEN
        Y.CNT.CONDT = '' ; CNT.INC = '' ; Y.ATM.MMRID = ''
        Y.CNT.CONDT = DCOUNT(INCOTYPE.MOD,@FM)
        FOR I.VAR=1 TO Y.CNT.CONDT
            Y.MERCH.ID = ''
            Y.MERCH.ID = INCOTYPE.MOD<I.VAR>
            GOSUB GET.ATM.MERCH
            IF Y.ATM.MMRID NE "" AND Y.MERCH.ID EQ Y.ATM.MMRID THEN
                CNT.INC += 1
            END
        NEXT I.VAR
        IF CNT.INC LT 1 AND Y.ATM.MMRID NE "" THEN
            FILE.UPD.STOP = 1
        END ELSE
            FILE.UPD.STOP = ''
        END
    END

RETURN

*-------------
GET.ATM.MERCH:
*-------------
	FN.ATM.TRANSACTION = 'F.ATM.TRANSACTION'
	
    ATM.ID.LIST = '' ; ATM.ID = '' ; ATM.ID.POS = ''
    *SEL.ATM.CMD = "SELECT ":FN.ATM.REVERSAL:" WITH TXN.REF EQ ":TXN.ID
	SEL.ATM.CMD = "SELECT ":FN.ATM.TRANSACTION:" WITH TXN.REF EQ ":TXN.ID
    CALL EB.READLIST(SEL.ATM.CMD,ATM.ID.LIST,'',ID.CNT,'')
    LOOP
        REMOVE ATM.ID FROM ATM.ID.LIST SETTING ATM.ID.POS
    WHILE ATM.ID:ATM.ID.POS
        R.ATM.DETS = '' ; ATM.ERR = ''
        *CALL F.READ(FN.ATM.REVERSAL,ATM.ID,R.ATM.DETS,F.ATM.REVERSAL,ATM.ERR)
		CALL F.READ(FN.ATM.TRANSACTION,ATM.ID,R.ATM.DETS,F.ATM.TRANSACTION,ATM.ERR)
        Y.ATM.TXNR = ''
        Y.ATM.TXNR = R.ATM.DETS<AT.REV.TRANS.REF>
        IF Y.ATM.TXNR EQ TXN.ID THEN
            Y.ATM.MMRID = R.ATM.DETS<AT.REV.MERCHANT.ID>
            Y.ATM.MMRCAT = R.ATM.DETS<AT.REV.MERCHANT.ID>
            RETURN
        END
    REPEAT

RETURN

*---------------
CHECK.APP.MATCH:
*---------------
*-----------------------------------------------------------------------------------------------------------------
* This section checks whether the transaction application and code is specified in REDO.LY.MODALITY record
*  If present then TRANSACTION ID, ACCOUNT NO, CURRENCY & AMOUNT of transaction is updated in F.REDO.LY.TXN.BY.MOD
*   with CUSOMER id as record id
*-----------------------------------------------------------------------------------------------------------------

    FILE.UPD.STOP = ''
    GOSUB CHK.TXN.CHANNEL
    IF FILE.UPD.STOP EQ '1' THEN
        RETURN
    END
    FILE.UPD.STOP = ''
    GOSUB CHK.PRODUCT
    IF FILE.UPD.STOP EQ '1' THEN
        RETURN
    END
    FILE.UPD.STOP = ''
    GOSUB CHECK.EXCINC.COND
    IF FILE.UPD.STOP EQ '1' THEN
        RETURN
    END

    CRT '-> IDENTIFYING TRANSACTION REF. ':TXN.ID
    DELIM = ':'
    TEMP.FILE.CONTENT = TXN.ID:DELIM:TXN.ACCT:DELIM:TXN.PROD:DELIM:TXN.CCY:DELIM:TXN.AMT.OP:DELIM:'T'

    REC.ID = MODALITY.ID.LIST<CCY.POS>:'.':TXN.CUS:'.':TODAY
    READU FILE.CONTENT FROM F.REDO.LY.TXN.BY.MOD,REC.ID THEN

        FILE.CONTENT := @FM:TEMP.FILE.CONTENT
    END ELSE
        FILE.CONTENT = TEMP.FILE.CONTENT
    END

    WRITE FILE.CONTENT TO F.REDO.LY.TXN.BY.MOD,REC.ID


    FILE.UPDATED = 1

RETURN

*---------------
GET.TXN.CHANNEL:
*---------------

    Y.HAS.CUST = ''
    Y.FTTC.REC = ''
    Y.CHANNEL = ''

    TXN.ID.TEMP = TXN.ID:';1'   ;*FOR COB PROCESSING
*    TXN.ID.TEMP = TXN.ID ;*FOR TESTING LIKE SERVICE

    R.FUNDS.TRANSFER = ''; FT.ERR = ''
    CALL F.READ(FN.FUNDS.TRANSFER,TXN.ID.TEMP,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)
    IF R.FUNDS.TRANSFER THEN
        Y.FTTC.REC = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
        TXN.CUS = R.FUNDS.TRANSFER<FT.PROFIT.CENTRE.CUST>
        TXN.ACCT.DB = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
        TXN.ACCT.CR = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
        R.ACCOUNT = ''; ACCT.ERR = ''
        CALL F.READ(FN.ACCOUNT,TXN.ACCT.CR,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        IF R.ACCOUNT THEN
            Y.HAS.CUST = R.ACCOUNT<AC.CUSTOMER>
        END
        IF Y.HAS.CUST NE '' THEN
            TXN.ACCT = TXN.ACCT.CR
        END ELSE
            TXN.ACCT = TXN.ACCT.DB
        END
        R.FTTC = ''; FTTC.ERR = ''
        CALL F.READ(FN.FT.TXN.TYPE.CONDITION,Y.FTTC.REC,R.FTTC,F.FT.TXN.TYPE.CONDITION,FTTC.ERR)
        IF R.FTTC THEN
            Y.CHANNEL = R.FTTC<FT6.LOCAL.REF,POS.L.FTTC.CHANNELS>
        END
    END

RETURN

*---------------
CHK.TXN.CHANNEL:
*---------------

    IF TXN.CH EQ '' THEN
        RETURN
    END

    CHANNEL.MOD = MODALITY.CHANNEL.LIST<CCY.POS>
    Y.CNT.CH = DCOUNT(CHANNEL.MOD,@VM)
    Y.NEXT = 1
    Y.CH.MATCH = 0
    LOOP
    WHILE Y.NEXT LE Y.CNT.CH
        Y.CH.VER = FIELD(CHANNEL.MOD,@VM,Y.NEXT)
*        IF Y.CH.VER EQ 'TT' THEN
*            Y.CH.VER = 'TT'
*        END ELSE
*            Y.CH.VER = 'FT'
*        END
        IF TXN.CH EQ Y.CH.VER THEN
            Y.CH.MATCH += 1
        END
        Y.NEXT += 1
    REPEAT

    IF Y.CH.MATCH EQ 0 THEN
        FILE.UPD.STOP = 1
    END

RETURN

END
