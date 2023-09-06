* @ValidationCode : MjotMTMyNDAzNjM4NzpDcDEyNTI6MTY5MzkyMjQ2MDgxOTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Sep 2023 19:31:00
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
SUBROUTINE REDO.B.COMMER.DEBTOR.BAL(Y.AA.CUS.ID)
*--------------------------------------------------------------------------------------------------
*
* Description           : This is the Batch Main Process Routine used to process the all AA Customer Id
*                         and get the Report Related details and Write the details in Temp Bp
*
* Developed On          : 11-NOV-2013
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : DE08
*
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
* PACS00361295           Ashokkumar.V.P                 04/11/2014            Added additonal loans
* PACS00361295           Ashokkumar.V.P                 31/03/2015            Removed the child account details
* PACS00361295           Ashokkumar.V.P                 15/05/2015            Added new fields to show customer loans.
* PACS00464363           Ashokkumar.V.P                 22/06/2015            Changed to avoid ageing problem and mapping changes.
* PACS00466000           Ashokkumar.V.P                 24/06/2015            Mapping changes - Remove L.CU.DEBTOR field

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - INSERT file folder name removed T24.BP, TAM.BP, LAPAP.BP, VM TO @VM, = Y.STA.COUNT + TO +=, = CTR.BAL.TYPE + TO +=, = Y.FIN.ECB.AMT.COM + TO +=, = Y.FIN.ECB.AMT.CONS + TO +=, = Y.FIN.ECB.AMT.HIP + TO +=, SM TO @SM, FM TO @FM, ++ TO += 1
* 05.09.2023       VICTORIA S            R22            Manual Conversion   - Add call routine prefix
*
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------

    $INSERT I_COMMON                               ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_BATCH.FILES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_REDO.B.COMMER.DEBTOR.BAL.COMMON
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON          ;** R22 Auto conversion - END

    GOSUB PROCESS
RETURN

PROCESS:
*------
    R.REDO.CUSTOMER.ARRANGEMENT = ''; CUS.ARR.ERR = ''; Y.CREDIT.TYPE = ''; Y.BRANCH = ''
    Y.AA.OWNER = ''; Y.DCNT.OWNER = 0; AA.ARR.TEMP = ''
    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.AA.CUS.ID,R.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR)
    IF R.REDO.CUSTOMER.ARRANGEMENT THEN
        GOSUB GET.FLD.VALUES
    END
RETURN

GET.FLD.VALUES:
*--------------
    Y.AA.OWNER = R.REDO.CUSTOMER.ARRANGEMENT<CUS.ARR.OWNER>
    IF Y.AA.OWNER THEN
        Y.DCNT.OWNER = DCOUNT(Y.AA.OWNER,@VM)
        Y.STA.COUNT = '1'
        Y.APPROVED.AMT = ''; Y.WRITE.FLG = ''; Y.FIN.ECB.AMT.HIP = 0
        Y.FIN.ECB.AMT.COM = 0; Y.FIN.ECB.AMT.CONS = 0
        GOSUB GET.CHK.AA.ID
        IF NOT(Y.FIN.ECB.AMT.COM) AND NOT(Y.FIN.ECB.AMT.CONS) AND NOT(Y.FIN.ECB.AMT.HIP) THEN
            RETURN
        END
        IF Y.FIN.ECB.AMT.COM LE '0' THEN
            IF Y.FIN.ECB.AMT.CONS LE '0' THEN
                IF Y.FIN.ECB.AMT.HIP LE '0' THEN
                    RETURN
                END
            END
        END

        IF Y.WRITE.FLG EQ '1' THEN
            GOSUB CHK.CUS.DTLS
            GOSUB WRITE.REC.FLE
        END
    END
RETURN

GET.CHK.AA.ID:
*-------------
    LOOP
    WHILE Y.STA.COUNT LE Y.DCNT.OWNER
        AA.ARR.ID = ''; AA.POSN = ''; YPOST.RESTRICT = ''
        AA.ARR.ID = Y.AA.OWNER<1,Y.STA.COUNT>
        LOCATE AA.ARR.ID IN AA.ARR.TEMP<1> SETTING AA.POSN THEN
            Y.STA.COUNT += 1                       ;** R22 Auto conversion - = Y.STA.COUNT + TO +=
            CONTINUE
        END
        AA.ARR.TEMP<-1> = AA.ARR.ID
        GOSUB GET.DTLS.AA.ID
        Y.STA.COUNT += 1                            ;** R22 Auto conversion - = Y.STA.COUNT + TO +=
    REPEAT
    C$SPARE(458) = ''; C$SPARE(459) = ''; C$SPARE(460) = ''
    C$SPARE(461) = ''; C$SPARE(462) = ''
    GOSUB GET.ECB.AMT
RETURN

GET.DTLS.AA.ID:
*--------------
    C$SPARE(451) = ''; C$SPARE(452) = ''; C$SPARE(453) = ''
    C$SPARE(454) = ''; C$SPARE(455) = ''; C$SPARE(456) = ''
    C$SPARE(457) = ''; R.ARR.APPL = ''; ARR.ERR = ''
    CALL AA.GET.ARRANGEMENT(AA.ARR.ID,R.ARR.APPL,ARR.ERR)
    IF NOT(R.ARR.APPL) THEN
        RETURN
    END
    Y.MAIN.PRDT.LNE = R.ARR.APPL<AA.ARR.PRODUCT.LINE>
    Y.MAIN.PROD.GROUP = R.ARR.APPL<AA.ARR.PRODUCT.GROUP>
    Y.MAIN.ARR.STATUS = R.ARR.APPL<AA.ARR.ARR.STATUS>
    Y.MAIN.ARR.PRCT = R.ARR.APPL<AA.ARR.PRODUCT>
    Y.MAIN.STRT.DTE = R.ARR.APPL<AA.ARR.START.DATE>

    IF Y.MAIN.PRDT.LNE NE "LENDING" THEN
        RETURN
    END
    IF Y.MAIN.STRT.DTE GT YTODAY.DAT THEN
        RETURN
    END
    IF Y.MAIN.ARR.STATUS NE "CURRENT" AND Y.MAIN.ARR.STATUS NE "EXPIRED" THEN
        RETURN
    END
    GOSUB CHK.CURRENT.EXP
RETURN

GET.ECB.AMT:
*----------
*Always set the MONTO CONTINGENCIA field as ZERO.
    C$SPARE(458) = "0"
    IF Y.FIN.ECB.AMT.COM THEN
        Y.FIN.ECB.AMT.COM = ABS(Y.FIN.ECB.AMT.COM)
    END
    C$SPARE(459) = Y.FIN.ECB.AMT.COM
    IF Y.FIN.ECB.AMT.CONS THEN
        Y.FIN.ECB.AMT.CONS = ABS(Y.FIN.ECB.AMT.CONS)
    END
    C$SPARE(460) = Y.FIN.ECB.AMT.CONS
    C$SPARE(461) = "0"
    IF Y.FIN.ECB.AMT.HIP THEN
        Y.FIN.ECB.AMT.HIP = ABS(Y.FIN.ECB.AMT.HIP)
    END
    C$SPARE(462) = Y.FIN.ECB.AMT.HIP
RETURN
CHK.CURRENT.EXP:
*--------------
    Y.BAL.PRIC = '0'
    YCOM.FLG = 0; YCON.FLG = 0; YHIP.FLG = 0
    IF Y.MAIN.PROD.GROUP EQ "COMERCIAL" THEN
        YCOM.FLG = 1
        GOSUB CHK.LN.STATUS
    END
    IF Y.MAIN.PROD.GROUP EQ "LINEAS.DE.CREDITO" THEN
        FINDSTR "COM" IN Y.MAIN.ARR.PRCT SETTING Y.MAIN.PRCT.POS THEN
            YCOM.FLG = 1
            GOSUB CHK.LN.STATUS
        END
        FINDSTR "CONS" IN Y.MAIN.ARR.PRCT SETTING Y.MAIN.PRCT.POSC THEN
            YCON.FLG = 1
            GOSUB CHK.LN.STATUS
        END
    END
    IF Y.MAIN.PROD.GROUP EQ "CONSUMO" THEN
        YCON.FLG = 1
        GOSUB CHK.LN.STATUS
    END
    IF Y.MAIN.PROD.GROUP EQ "HIPOTECARIO" THEN
        YHIP.FLG = 1
        GOSUB CHK.LN.STATUS
    END
RETURN

CHK.LN.STATUS:
*------------
    Y.LOAN.STATUS = ''; Y.CLOSE.LN.FLG = 0
    GOSUB GET.LOAN.STATUS
    IF Y.LOAN.STATUS EQ "Write-off" THEN
        RETURN
    END
    GOSUB GET.CLOSED.LOAN.CHK
    IF Y.CLOSE.LN.FLG EQ 1 THEN
        RETURN
    END
    Y.CUSTOMER.ID = R.ARR.APPL<AA.ARR.CUSTOMER>
    Y.CURRENCY    = R.ARR.APPL<AA.ARR.CURRENCY>
    Y.LINKED.APPL = R.ARR.APPL<AA.ARR.LINKED.APPL>
    Y.LINKED.APPL.ID = R.ARR.APPL<AA.ARR.LINKED.APPL.ID>
    LOCATE "ACCOUNT" IN Y.LINKED.APPL<1,1> SETTING Y.LINK.POS THEN
        Y.ACCOUNT =Y.LINKED.APPL.ID<Y.LINK.POS>
    END
    R.CUSTOMER = ''; CUS.ERR= ''
    CALL F.READ(FN.CUSTOMER,Y.AA.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.WRITE.FLG = '1'
    GOSUB OPEN.BAL.CALC
RETURN

CHK.CUS.DTLS:
*-----------
    OUT.ARR  = ""; Y.L.AA.MMD.PYME = ''; Y.INDUS.CODE = ''
    Y.PRODUCT.GROUP = ''; Y.REL.CODE = '' OUT.ARR = ''; Y.L.CU.DEBTOR = ''
    IF NOT(R.CUSTOMER) THEN
        RETURN
    END
*CALL REDO.S.REG.CUSTOMER.EXTRACT(Y.AA.CUS.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)
    APAP.LAPAP.redoSRegCustomerExtract(Y.AA.CUS.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR);* R22 Manual conversion
    Y.CUST.IDEN    = OUT.ARR<1>
    Y.CUST.TYPE    = OUT.ARR<2>
    Y.CUST.NAME    = OUT.ARR<3>
    Y.CUST.GN.NAME = OUT.ARR<4>
    Y.L.TIP.CLI = OUT.ARR<8>
    Y.L.CU.DEBTOR = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.DEBTOR.POS>
    Y.INDUS.CODE = R.CUSTOMER<EB.CUS.LOCAL.REF,L.APAP.INDUSTRY.POS>
    GOSUB ASSIGN.VALUES
RETURN
ASSIGN.VALUES:
*------------
    C$SPARE(451) = Y.CUST.IDEN
    C$SPARE(452) = Y.CUST.TYPE
    C$SPARE(453) = Y.CUST.NAME
    C$SPARE(454) = Y.CUST.GN.NAME
    C$SPARE(455) = Y.INDUS.CODE
    C$SPARE(457) = Y.L.TIP.CLI
    C$SPARE(456) = Y.L.CU.DEBTOR
RETURN

OPEN.BAL.CALC:
*------------
    IF Y.ACCOUNT EQ '' THEN
        RETURN
    END
    START.DATE = ''
    START.DATE = Y.MAIN.STRT.DTE
    END.DATE = YTODAY.DAT
    REQUEST.TYPE<4>='ECB'; Y.REGULATORY.ACC.NO = ''; SAVE.ACC.AC = ''; ASSET.TYPE.ARRAY = ''; YPOST.RESTRICT = ''
    AC.LEN = 7      ;* This is length of word 'ACCOUNT'
    PRIN.INT.LEN = 12         ;* This is length of word 'PRINCIPALINT'
    YPRINCIP.GRP = 0; YACCT.GRP = 0; YNAB.STATUS = ''; ERR.ACCOUNT = ''; R.ACCOUNT = ''
    TACCT.VAL = 0; EB.CON.BAL.ERR = ''; R.EB.CON.BAL = ''; YNAB.AMT = 0; CNT.BAL.TYPE = 0
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    YNAB.STATUS = R.ACCOUNT<AC.LOCAL.REF,L.OD.STATUS.POS>
    YPOST.RESTRICT = R.ACCOUNT<AC.POSTING.RESTRICT>
    IF YPOST.RESTRICT EQ '75' OR YPOST.RESTRICT EQ '90' THEN
        RETURN
    END
    CALL F.READ(FN.EB.CON.BAL,Y.ACCOUNT,R.EB.CON.BAL,F.EB.CON.BAL,EB.CON.BAL.ERR)
    IF R.EB.CON.BAL THEN
        Y.CONSOL.KEY = R.EB.CON.BAL<ECB.CONSOL.KEY>
        Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.ASSET.TYPE = R.EB.CON.BAL<ECB.CURR.ASSET.TYPE>
        CTR.BAL.TYPE = 1
        CNT.BAL.TYPE = DCOUNT(Y.ASSET.TYPE,@VM)
        LOOP
        WHILE CTR.BAL.TYPE LE CNT.BAL.TYPE
            ACC.POS = ''
            BAL.TYPE1 = Y.ASSET.TYPE<1,CTR.BAL.TYPE>
            IF BAL.TYPE1[1,3] EQ 'UNC' THEN
                CTR.BAL.TYPE += 1                 ;** R22 Auto conversion - = CTR.BAL.TYPE + TO +=
                CONTINUE
            END
            LEN.TYPE = LEN(BAL.TYPE1)
            REQ.LEN = BAL.TYPE1[((LEN.TYPE-AC.LEN)+1),AC.LEN]
            REQ.INT.LEN = BAL.TYPE1[((LEN.TYPE-PRIN.INT.LEN)+1),PRIN.INT.LEN]
            IF (REQ.LEN EQ 'ACCOUNT') OR (REQ.INT.LEN EQ 'PRINCIPALINT') THEN
                Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':BAL.TYPE1         ;*alter the consol key with current balance type in analysis
                Y.VARIABLE = ''
                CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
                Y.LINE = Y.RPRTS:'.':Y.LINES
                CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
                GOSUB REG.ACCOUNT.NO
            END
*
            CTR.BAL.TYPE += 1                       ;** R22 Auto conversion - = CTR.BAL.TYPE + TO +=
        REPEAT
    END
    GOSUB READ.AA.ACCT.DET
    GOSUB ACC.NAB.PROCESS
RETURN

REG.ACCOUNT.NO:
***************
    IF NOT(R.LINE) THEN
        RETURN
    END
    Y.REGULATORY.ACC.NO = R.LINE<RE.SRL.DESC,1>   ;* get accounting account for the current balance type in analysis
    IF Y.REGULATORY.ACC.NO[1,1] EQ '8' THEN
        RETURN
    END
    LOCATE Y.REGULATORY.ACC.NO IN SAVE.ACC.AC<1> SETTING ACC.POS THEN
        GOSUB CHECK.ASSET.TYPE
    END ELSE
        GOSUB SAVE.UNIQUE.AC.ACC
    END

    IF YCOM.FLG EQ 1 AND DAT.BALANCES THEN
        Y.FIN.ECB.AMT.COM += DAT.BALANCES               ;** R22 Auto conversion - = Y.FIN.ECB.AMT.COM + TO +=
    END
    IF YCON.FLG EQ 1 AND DAT.BALANCES THEN
        Y.FIN.ECB.AMT.CONS += DAT.BALANCES              ;** R22 Auto conversion - = Y.FIN.ECB.AMT.CONS + TO +=
    END
    IF YHIP.FLG EQ 1 AND DAT.BALANCES THEN
        Y.FIN.ECB.AMT.HIP += DAT.BALANCES               ;** R22 Auto conversion - = Y.FIN.ECB.AMT.HIP + TO +=
    END
    DAT.BALANCES = ''
RETURN

SAVE.UNIQUE.AC.ACC:
*******************
*
    SAVE.ACC.AC<-1> = Y.REGULATORY.ACC.NO
    CALL AA.GET.PERIOD.BALANCES(Y.ACCOUNT, BAL.TYPE1,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE)
    ASSET.TYPE.ARRAY<-1> = BAL.TYPE1
    DAT.BALANCES = BAL.DETAILS<4>
RETURN
*----------------------------------------------------------------------------
SAVE.EXISTING.AC.ACC:
*********************
*
    CALL AA.GET.PERIOD.BALANCES(Y.ACCOUNT, BAL.TYPE1,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE)
    DAT.BALANCES = BAL.DETAILS<4>
RETURN
*----------------------------------------------------------------------------
CHECK.ASSET.TYPE:
*****************
*
    LOCATE BAL.TYPE1 IN ASSET.TYPE.ARRAY<1> SETTING ASSET.POS THEN
        ASSET.POS = ''
    END ELSE
        ASSET.TYPE.ARRAY<-1> = BAL.TYPE1
        GOSUB SAVE.EXISTING.AC.ACC
    END
RETURN

ACC.NAB.PROCESS:
****************
    R.REDO.CONCAT.ACC.NAB = ''; NAB.ERR = ''; YACC.NABBAL = ''; YNAB.STATUS = ''; REQUEST.TYPE = ''; YNAB.VAL = 0
    YCR.DTE = ''; YCR.AMT = 0; SUSPEND.VAL = ''; SUSPEND.STAT = ''; SUSPEND.DTE = ''
    SUSPEND.VAL = R.AA.ACCT.DET<AA.AD.SUSPENDED>
    SUSPEND.STAT = R.AA.ACCT.DET<AA.AD.SUSP.STATUS,1>
    SUSPEND.DTE = R.AA.ACCT.DET<AA.AD.SUSP.DATE,1>
    IF SUSPEND.STAT EQ 'SUSPEND' AND SUSPEND.DTE GT YTODAY.DAT THEN
        RETURN
    END
    CALL F.READ(FN.REDO.CONCAT.ACC.NAB,Y.ACCOUNT,R.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB,NAB.ERR)
    IF NOT(R.REDO.CONCAT.ACC.NAB) THEN
        RETURN
    END
    Y.ACCT.ID = ''; Y.ACCT.ID = R.REDO.CONCAT.ACC.NAB
    BAL.TYPE1 = "OFFDB";   REQUEST.TYPE<4> = "ECB"
    START.DATE = YTODAY.DAT; END.DATE = YTODAY.DAT; BAL.DETAILS = 0; ERROR.MESSAGE = ''
    CALL AA.GET.PERIOD.BALANCES(Y.ACCT.ID, BAL.TYPE1,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE)
    YCR.AMT = BAL.DETAILS<4>
    YACC.NABBAL = YCR.AMT
    IF YCOM.FLG EQ 1 AND YACC.NABBAL THEN
        Y.FIN.ECB.AMT.COM += YACC.NABBAL                  ;** R22 Auto conversion - = Y.FIN.ECB.AMT.COM + TO +=
    END
    IF YCON.FLG EQ 1 AND YACC.NABBAL THEN
        Y.FIN.ECB.AMT.CONS += YACC.NABBAL                  ;** R22 Auto conversion - = Y.FIN.ECB.AMT.CONS + TO +=
    END
    IF YHIP.FLG EQ 1 AND YACC.NABBAL THEN
        Y.FIN.ECB.AMT.HIP += YACC.NABBAL                  ;** R22 Auto conversion - = Y.FIN.ECB.AMT.HIP + TO +=
    END
    YACC.NABBAL = ''
RETURN

READ.AA.ACCT.DET:
*****************
    ERR.ACCT.DET = ''; R.AA.ACCT.DET = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,AA.ARR.ID,R.AA.ACCT.DET,F.AA.ACCOUNT.DETAILS,ERR.ACCT.DET)
RETURN

WRITE.REC.FLE:
*------------                    1               2                3              4                5            6            7                  8                  9
*    Y.ARR<-1> = Y.CUST.IDEN:"*":Y.CUST.TYPE:"*":Y.CUST.NAME:"*":Y.CUST.GN.NAME:"*":Y.BRANCH:"*":Y.L.AA.MMD.PYME:"*":Y.L.TIP.CLI:"*":Y.APPROVED.AMT:"*":Y.FIN.ECB.AMT.COM:"*":Y.FIN.ECB.AMT.CONS:"*":Y.CREDIT.CARD:"*":Y.FIN.ECB.AMT.HIP
    MAP.FMT = "MAP"
    Y.MAP.ID = "REDO.RCL.DE08"
    Y.RCL.APPL = FN.CUSTOMER
    Y.RCL.AA.ID = Y.AA.CUS.ID
*CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,Y.MAP.ID,Y.RCL.APPL,Y.RCL.AA.ID,R.CUSTOMER,R.RETURN.MSG,ERR.MSG)
    APAP.LAPAP.redoConduitLinearTranslation(MAP.FMT,Y.MAP.ID,Y.RCL.APPL,Y.RCL.AA.ID,R.CUSTOMER,R.RETURN.MSG,ERR.MSG) ;*R22 MANUAL CONVERSION
    CALL F.WRITE(FN.DR.REG.DE08.WORKFILE,AA.ARR.ID,R.RETURN.MSG)
RETURN

GET.LOAN.STATUS:
*--------------*
    ArrangementID = AA.ARR.ID
    idPropertyClass = 'OVERDUE'; Y.LOAN.STATUS = ''
    idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''; effectiveDate = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.OVERDUE = RAISE(returnConditions)
    Y.LOAN.STATUS = R.AA.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.STATUS.1.POS>
RETURN

GET.CLOSED.LOAN.CHK:
********************
    REQD.MODE = ''; EFF.DATE = Y.MAIN.STRT.DTE; R.AA.ACTIVITY.HISTORY = ''
    CALL AA.READ.ACTIVITY.HISTORY(REC.ID, REQD.MODE, EFF.DATE, R.AA.ACTIVITY.HISTORY)
    Y.CLOSE.LN.FLG = 0; YACT.IS.STAT = ''; YACT.ID.ARR = ''
    IF R.AA.ACTIVITY.HISTORY THEN
        YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
        YACT.IS.STAT = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS>
        CHANGE @VM TO @FM IN YACT.ID.ARR
        CHANGE @SM TO @FM IN YACT.ID.ARR
        CHANGE @VM TO @FM IN YACT.IS.STAT
        CHANGE @SM TO @FM IN YACT.IS.STAT
    END
    ERR.REDO.APAP.PROPERTY.PARAM = ''; R.REDO.APAP.PROPERTY.PARAM = ''; YPAYOFF.ACT = ''; YPAY.CNT = 0
    CALL F.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.MAIN.PROD.GROUP,R.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM,ERR.REDO.APAP.PROPERTY.PARAM)
    IF R.REDO.APAP.PROPERTY.PARAM THEN
        YPAYOFF.ACT = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY>
        YPAY.CNT = DCOUNT(YPAYOFF.ACT,@VM)
    END

    YCNT = 1
    LOOP
    WHILE YCNT LE YPAY.CNT
        YPAYOFF.ACT.1 = ''
        YPAYOFF.ACT.1 = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY,YCNT>
        LOCATE YPAYOFF.ACT.1 IN YACT.ID.ARR<1> SETTING CHG.POSN.1 THEN
            YARR.STAT = YACT.IS.STAT<CHG.POSN.1>
            IF YARR.STAT EQ 'AUTH' THEN
                Y.CLOSE.LN.FLG = 1
                YCNT = YPAY.CNT + 1
                CONTINUE
            END
        END
        YCNT += 1                    ;** R22 Auto conversion - ++ TO += 1
    REPEAT
RETURN
END
