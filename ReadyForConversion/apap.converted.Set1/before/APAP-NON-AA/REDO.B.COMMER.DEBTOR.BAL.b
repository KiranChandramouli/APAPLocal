*-----------------------------------------------------------------------------
* <Rating>-145</Rating>
*-----------------------------------------------------------------------------
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
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT TAM.BP I_REDO.B.COMMER.DEBTOR.BAL.COMMON
    $INSERT TAM.BP I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT TAM.BP I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_BATCH.FILES
    $INSERT I_F.ACCOUNT

    GOSUB PROCESS
    RETURN

PROCESS:
*------
    R.REDO.CUSTOMER.ARRANGEMENT = ''; CUS.ARR.ERR = ''
    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.AA.CUS.ID,R.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR)
    IF R.REDO.CUSTOMER.ARRANGEMENT THEN
        GOSUB GET.FLD.VALUES
    END ELSE
        GOSUB RAISE.ERR.C.22
    END
    RETURN
GET.FLD.VALUES:
*--------------
    Y.AA.OWNER = R.REDO.CUSTOMER.ARRANGEMENT<CUS.ARR.OWNER>
    IF Y.AA.OWNER THEN
        Y.DCNT.OWNER = DCOUNT(Y.AA.OWNER,VM)
        Y.STA.COUNT = '1'
        Y.APPROVED.AMT = ''; Y.WRITE.FLG = ''; Y.FIN.ECB.AMT.HIP = '0'
        Y.FIN.ECB.AMT.COM = '0'; Y.FIN.ECB.AMT.CONS = '0'
        GOSUB GET.CHK.AA.ID
        IF Y.WRITE.FLG EQ '1' AND Y.FIN.ECB.AMT.COM GT '0' THEN
            GOSUB CHK.CUS.DTLS
            GOSUB WRITE.REC.FLE
        END
    END
    RETURN

GET.CHK.AA.ID:
*-------------
    LOOP
    WHILE Y.STA.COUNT LE Y.DCNT.OWNER
        AA.ARR.ID = Y.AA.OWNER<1,Y.STA.COUNT>
        GOSUB GET.DTLS.AA.ID
        Y.STA.COUNT += 1
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
        GOSUB RAISE.ERR.C.22
    END
    Y.MAIN.PRDT.LNE = R.ARR.APPL<AA.ARR.PRODUCT.LINE>
    Y.MAIN.PROD.GROUP = R.ARR.APPL<AA.ARR.PRODUCT.GROUP>
    Y.MAIN.ARR.STATUS = R.ARR.APPL<AA.ARR.ARR.STATUS>
    Y.MAIN.ARR.PRCT = R.ARR.APPL<AA.ARR.PRODUCT>
    Y.MAIN.STRT.DTE = R.ARR.APPL<AA.ARR.START.DATE>

    IF Y.MAIN.PRDT.LNE NE "LENDING" THEN
        RETURN
    END
    IF Y.MAIN.STRT.DTE GE YTODAY.DAT THEN
        RETURN
    END
    IF Y.MAIN.ARR.STATUS EQ "CURRENT" OR Y.MAIN.ARR.STATUS EQ "EXPIRED" ELSE
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
    IF Y.FIN.ECB.AMT.COM GT 0 AND Y.FIN.ECB.AMT.CONS THEN
        Y.FIN.ECB.AMT.CONS = ABS(Y.FIN.ECB.AMT.CONS)
    END
    C$SPARE(460) = Y.FIN.ECB.AMT.CONS
    C$SPARE(461) = "0"
    IF Y.FIN.ECB.AMT.COM GT 0 AND Y.FIN.ECB.AMT.HIP THEN
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
    ARRAY.VAL = ''; Y.LOAN.STATUS = ''; Y.CLOSE.LN.FLG = 0
    CALL REDO.RPT.CLSE.WRITE.LOANS(AA.ARR.ID,R.ARR.APPL,ARRAY.VAL)
    Y.LOAN.STATUS = ARRAY.VAL<1>
    Y.CLOSE.LN.FLG = ARRAY.VAL<2>
    IF Y.LOAN.STATUS EQ "Write-off" THEN
        RETURN
    END
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
    CALL F.READ(FN.CUSTOMER,Y.AA.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.WRITE.FLG = '1'
    GOSUB OPEN.BAL.CALC
    RETURN
CHK.CUS.DTLS:
*-----------
    OUT.ARR  = ""; Y.L.AA.MMD.PYME = ''; Y.INDUS.CODE = ''
    IF R.CUSTOMER THEN
        CALL REDO.S.REP.CUSTOMER.EXTRACT(Y.AA.CUS.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)
        Y.CUST.IDEN    = OUT.ARR<1>
        Y.CUST.TYPE    = OUT.ARR<2>
        Y.CUST.NAME    = OUT.ARR<3>
        Y.CUST.GN.NAME = OUT.ARR<4>
        Y.L.TIP.CLI = OUT.ARR<8>
        Y.L.AA.MMD.PYME = R.CUSTOMER<EB.CUS.LOCAL.REF,L.AA.MMD.PYME.POS>
        IF Y.L.AA.MMD.PYME[1,2] EQ '1B' OR Y.L.AA.MMD.PYME[1,2] EQ '1C' THEN
            Y.L.CU.DEBTOR = 'M'
        END
        IF Y.L.AA.MMD.PYME[1,2] EQ '1A' THEN
            Y.L.CU.DEBTOR = 'C'
        END
        Y.INDUS.CODE = R.CUSTOMER<EB.CUS.LOCAL.REF,L.APAP.INDUSTRY.POS>
        GOSUB ASSIGN.VALUES
    END
    RETURN
ASSIGN.VALUES:
*------------
    C$SPARE(451) = Y.CUST.IDEN
    C$SPARE(452) = Y.CUST.TYPE
    C$SPARE(453) = Y.CUST.NAME
    C$SPARE(454) = Y.CUST.GN.NAME
    C$SPARE(455) = Y.INDUS.CODE
    C$SPARE(457) = Y.L.AA.MMD.PYME
    C$SPARE(456) = Y.L.TIP.CLI
    RETURN

OPEN.BAL.CALC:
*------------
    AC.LEN = 7      ;* This is length of word 'ACCOUNT'
    PRIN.INT.LEN = 12         ;* This is length of word 'PRINCIPALINT'
    CALL F.READ(FN.EB.CON.BAL,Y.ACCOUNT,R.EB.CON.BAL,F.EB.CON.BAL,EB.CON.BAL.ERR)
    IF R.EB.CON.BAL THEN
        Y.CNT.EB.CON = '1'
        Y.CUR.ASSET.TYPE = R.EB.CON.BAL<ECB.CURR.ASSET.TYPE>
        Y.DCNT.CUR.ASS = DCOUNT(Y.CUR.ASSET.TYPE,VM)
        Y.CNT.CUR.TYPE = '1'
        LOOP
        WHILE Y.CNT.CUR.TYPE LE Y.DCNT.CUR.ASS
            Y.TYPE.SYSDATE = ''; Y.PRIC.POS = ''; SYS.DATE = ''
            Y.ASSET.TYPE = Y.CUR.ASSET.TYPE<1,Y.CNT.CUR.TYPE>
            Y.TYPE.SYSDATE = R.EB.CON.BAL<ECB.TYPE.SYSDATE,Y.CNT.CUR.TYPE>
            YSYSTYPE = FIELD(Y.TYPE.SYSDATE,'-',1)
            SYS.DATE = FIELD(Y.TYPE.SYSDATE,'-',2)
            IF SYS.DATE < YTODAY.DAT THEN
                GOSUB PRICNI.MVMT.APPL
            END
            Y.CNT.CUR.TYPE += 1
        REPEAT
    END
    RETURN

PRICNI.MVMT.APPL:
*---------------
    Y.BAL.PRIC = 0
    FINDSTR "PRINCIPALINT" IN Y.ASSET.TYPE SETTING Y.PRIC.POS THEN
        Y.ASSET.TYPE.PRIC = Y.ASSET.TYPE<Y.PRIC.POS>
        GOSUB CREDIT.MVMT.APPL
    END
    Y.ACC.POS = ''; Y.ASSET.TYPE.PRIC = ''
    FINDSTR "ACCOUNT" IN Y.ASSET.TYPE SETTING Y.ACC.POS THEN
        Y.ASSET.TYPE.PRIC = Y.ASSET.TYPE<Y.ACC.POS>
        GOSUB CREDIT.MVMT.APPL
    END

    IF YCOM.FLG EQ 1 AND Y.BAL.PRIC THEN
        Y.FIN.ECB.AMT.COM += Y.BAL.PRIC
        Y.BAL.PRIC = ''
    END
    IF YCON.FLG EQ 1 AND Y.BAL.PRIC THEN
        Y.FIN.ECB.AMT.CONS += Y.BAL.PRIC
        Y.BAL.PRIC = ''
    END
    IF YHIP.FLG EQ 1 AND Y.BAL.PRIC THEN
        Y.FIN.ECB.AMT.HIP += Y.BAL.PRIC
        Y.BAL.PRIC = ''
    END
    RETURN

CREDIT.MVMT.APPL:
*---------------
    IF Y.ASSET.TYPE.PRIC EQ 'UNCACCOUNT' THEN
        RETURN
    END
    LEN.TYPE = LEN(Y.ASSET.TYPE.PRIC)
    CHK.SP = ''
    CHK.SP = RIGHT(Y.ASSET.TYPE.PRIC,2)
    IF CHK.SP EQ 'SP' THEN
        LEN.TYPE = LEN.TYPE - 2
    END
    REQ.LEN = Y.ASSET.TYPE.PRIC[((LEN.TYPE-AC.LEN)+1),AC.LEN]
    REQ.INT.LEN = Y.ASSET.TYPE.PRIC[((LEN.TYPE-PRIN.INT.LEN)+1),PRIN.INT.LEN]
    IF (REQ.LEN EQ 'ACCOUNT') OR (REQ.INT.LEN EQ 'PRINCIPALINT') THEN
        Y.OPEN.BAL = ''; Y.DEBIT.MVMT = ''; Y.CREDIT.MVMT = ''
        Y.OPEN.BAL =  SUM(R.EB.CON.BAL<ECB.OPEN.BALANCE,Y.CNT.CUR.TYPE>)
        Y.DEBIT.MVMT = SUM(R.EB.CON.BAL<ECB.DEBIT.MVMT,Y.CNT.CUR.TYPE>)
        Y.CREDIT.MVMT = SUM(R.EB.CON.BAL<ECB.CREDIT.MVMT,Y.CNT.CUR.TYPE>)
        Y.BAL.PRIC = Y.OPEN.BAL + Y.DEBIT.MVMT + Y.CREDIT.MVMT
    END
    RETURN

WRITE.REC.FLE:
*------------
*                    1               2                3              4                5            6            7                  8                  9
*    Y.ARR<-1> = Y.CUST.IDEN:"*":Y.CUST.TYPE:"*":Y.CUST.NAME:"*":Y.CUST.GN.NAME:"*":Y.BRANCH:"*":Y.L.AA.MMD.PYME:"*":Y.L.TIP.CLI:"*":Y.APPROVED.AMT:"*":Y.FIN.ECB.AMT.COM:"*":Y.FIN.ECB.AMT.CONS:"*":Y.CREDIT.CARD:"*":Y.FIN.ECB.AMT.HIP
    MAP.FMT = "MAP"
    Y.MAP.ID = "REDO.RCL.DE08"
    Y.RCL.APPL = FN.CUSTOMER
    Y.RCL.AA.ID = Y.AA.CUS.ID
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,Y.MAP.ID,Y.RCL.APPL,Y.RCL.AA.ID,R.CUSTOMER,R.RETURN.MSG,ERR.MSG)
    CALL F.WRITE(FN.DR.REG.DE08.WORKFILE,AA.ARR.ID,R.RETURN.MSG)
    RETURN
RAISE.ERR.C.22:
*-------------
    MON.TP = "DE08"
    Y.ERR.MSG = "Record not found"
    REC.CON = "DE08-":Y.AA.CUS.ID:Y.ERR.MSG
    DESC = "DE08-":Y.AA.CUS.ID:Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    RETURN
END
