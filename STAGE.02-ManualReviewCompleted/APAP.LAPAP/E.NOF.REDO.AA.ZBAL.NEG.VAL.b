$PACKAGE APAP.LAPAP
SUBROUTINE E.NOF.REDO.AA.ZBAL.NEG.VAL(ENQ.DATA)
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*                       Ashokkumar.V.P                  07/09/2015     
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INCLUDE T24.BP TO $INSERT AND <= TO LE AND VAR1+ TO += AND VM TO @VM
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES .
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT


    GOSUB INIT
    GOSUB MAIN.PROCESS
RETURN

INIT:
*****

    YTODAY.DAT = TODAY
    FN.AA.ARR = 'F.AA.ARRANGEMENT'; F.AA.ARR = ''
    CALL OPF(FN.AA.ARR,F.AA.ARR)
    FN.EB.CON.BAL = 'F.EB.CONTRACT.BALANCES'; F.EB.CON.BAL = ''
    CALL OPF(FN.EB.CON.BAL,F.EB.CON.BAL)
    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'; F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)
    AC.LEN = 7      ;* This is length of word 'ACCOUNT'
    PRIN.INT.LEN = 12         ;* This is length of word 'PRINCIPALINT'
    PENL.INT.LEN = 6          ;* PENALT
    PROM.CHG.LEN = 6          ;* PROMORA
RETURN

MAIN.PROCESS:
*************
    SEL.CMD = ''; SEL.LIST = ''; SEL.CNT = ''; ERR.SEL = ''; YFINAL.ARRY = ''
    SEL.CMD = "SSELECT ":FN.AA.ARR:" WITH PRODUCT.LINE EQ 'LENDING'"
    AA.POSN = ''
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.CNT,ERR.SEL)

    LOOP
        REMOVE AA.ID FROM SEL.LIST SETTING AA.POSN
    WHILE AA.ID:AA.POSN
        ERR.AA.ARR = ''; R.AA.ARR = ''; Y.ACCOUNT = ''; Y.LINK.POS = ''
        CALL F.READ(FN.AA.ARR,AA.ID,R.AA.ARR,F.AA.ARR,ERR.AA.ARR)
        Y.MAIN.PROD.GROUP = R.AA.ARR<AA.ARR.PRODUCT.GROUP>
        Y.MAIN.ARR.STATUS = R.AA.ARR<AA.ARR.ARR.STATUS>
        Y.MAIN.ARR.PRCT = R.AA.ARR<AA.ARR.PRODUCT>
        Y.MAIN.STRT.DTE = R.AA.ARR<AA.ARR.START.DATE>
        IF Y.MAIN.STRT.DTE GE YTODAY.DAT THEN
            CONTINUE
        END
        Y.CUSTOMER.ID = R.AA.ARR<AA.ARR.CUSTOMER>
        Y.CURRENCY    = R.AA.ARR<AA.ARR.CURRENCY>
        Y.LINKED.APPL = R.AA.ARR<AA.ARR.LINKED.APPL>
        Y.LINKED.APPL.ID = R.AA.ARR<AA.ARR.LINKED.APPL.ID>
        LOCATE "ACCOUNT" IN Y.LINKED.APPL<1,1> SETTING Y.LINK.POS THEN
            Y.ACCOUNT =Y.LINKED.APPL.ID<Y.LINK.POS>
        END
        GOSUB PROCESS.ECB

    REPEAT

    ENQ.DATA = YFINAL.ARRY
RETURN

PROCESS.ECB:
************
    R.EB.CON.BAL = ''; ERR.EB.CON.BAL = ''; ACCTP.VAL = 0; TACCT.VAL = 0; YUNC.VAL = 0
    MACCT.VAL = 0; CACCT.VAL = 0
    CALL F.READ(FN.EB.CON.BAL,Y.ACCOUNT,R.EB.CON.BAL,F.EB.CON.BAL,EB.CON.BAL.ERR)
    IF NOT(R.EB.CON.BAL) THEN
        RETURN
    END
    Y.CNT.EB.CON = '1'
    Y.CUR.ASSET.TYPE = R.EB.CON.BAL<ECB.CURR.ASSET.TYPE>
    Y.DCNT.CUR.ASS = DCOUNT(Y.CUR.ASSET.TYPE,@VM)
    Y.CNT.CUR.TYPE = '1'
    LOOP
    WHILE Y.CNT.CUR.TYPE LE Y.DCNT.CUR.ASS
        Y.TYPE.SYSDATE = ''; Y.PRIC.POS = ''; SYS.DATE = ''
        Y.ASSET.TYPE = Y.CUR.ASSET.TYPE<1,Y.CNT.CUR.TYPE>
        Y.TYPE.SYSDATE = R.EB.CON.BAL<ECB.TYPE.SYSDATE,Y.CNT.CUR.TYPE>
        YSYSTYPE = FIELD(Y.TYPE.SYSDATE,'-',1)
        SYS.DATE = FIELD(Y.TYPE.SYSDATE,'-',2)
        IF SYS.DATE LE YTODAY.DAT THEN  ;*R22 AUTO CONVERSTION <= TO LE
            GOSUB PRICNI.MVMT.APPL
        END
        Y.CNT.CUR.TYPE += 1
    REPEAT

    IF ACCTP.VAL EQ '0' AND (TACCT.VAL NE '0' OR MACCT.VAL NE '0' OR CACCT.VAL NE '0') THEN
        YFINAL.ARRY<-1> = "Cero Cantidad*":AA.ID:"*":Y.ACCOUNT:"*":Y.MAIN.ARR.STATUS:"*":ACCTP.VAL:"*":TACCT.VAL:"*"CACCT.VAL:"*":MACCT.VAL
        RETURN
    END
    Y.ACCTP.VAL = 0
    Y.ACCTP.VAL = ACCTP.VAL - YUNC.VAL
    IF Y.ACCTP.VAL GT 0 OR (TACCT.VAL GT 0 OR MACCT.VAL GT '0' OR CACCT.VAL GT '0') THEN
        YFINAL.ARRY<-1> = "Saldo Positivo*":AA.ID:"*":Y.ACCOUNT:"*":Y.MAIN.ARR.STATUS:"*":Y.ACCTP.VAL:"*":TACCT.VAL:"*"CACCT.VAL:"*":MACCT.VAL
        RETURN
    END
    IF YUNC.VAL LT 0 THEN
        YFINAL.ARRY<-1> = "Saldo Negativo*":AA.ID:"*":Y.ACCOUNT:"*":Y.MAIN.ARR.STATUS:"*":YUNC.VAL:"***"
        RETURN
    END
    IF (TACCT.VAL NE 0 OR ACCTP.VAL NE 0 OR MACCT.VAL NE 0 OR CACCT.VAL NE 0) AND Y.MAIN.ARR.STATUS EQ 'AUTH' THEN
        YFINAL.ARRY<-1> = "Auth Estado*":AA.ID:"*":Y.ACCOUNT:"*":Y.MAIN.ARR.STATUS:"*":ACCTP.VAL:"*":TACCT.VAL:"*"CACCT.VAL:"*":MACCT.VAL
        RETURN
    END
RETURN

PRICNI.MVMT.APPL:
*---------------
    Y.BAL.PRIC = 0; TEMP.FLG = 0
    FINDSTR "PRINCIPALINT" IN Y.ASSET.TYPE SETTING Y.PRIC.POS THEN
        Y.ASSET.TYPE.PRIC = Y.ASSET.TYPE<Y.PRIC.POS>
        GOSUB CREDIT.MVMT.APPL
        TACCT.VAL += Y.BAL.PRIC
        TEMP.FLG = 1
    END
    Y.ACC.POS = ''; Y.ASSET.TYPE.PRIC = ''
    FINDSTR "ACCOUNT" IN Y.ASSET.TYPE SETTING Y.ACC.POS THEN
        Y.ASSET.TYPE.PRIC = Y.ASSET.TYPE<Y.ACC.POS>
        GOSUB CREDIT.MVMT.APPL
        ACCTP.VAL += Y.BAL.PRIC
        TEMP.FLG = 1
    END

    FINDSTR "PENALTINT" IN Y.ASSET.TYPE SETTING Y.ACC.POS THEN
        Y.ASSET.TYPE.PRIC = Y.ASSET.TYPE<Y.ACC.POS>
        GOSUB CREDIT.MVMT.APPL
        CACCT.VAL += Y.BAL.PRIC
        TEMP.FLG = 1
    END

    IF TEMP.FLG EQ 0 THEN
        Y.ASSET.TYPE.PRIC = Y.ASSET.TYPE
        GOSUB CREDIT.MVMT.APPL
        MACCT.VAL += Y.BAL.PRIC
    END

    IF Y.ASSET.TYPE.PRIC EQ 'UNCACCOUNT' THEN
        YUNC.VAL += Y.BAL.PRIC
    END
    Y.BAL.PRIC = ''
RETURN

CREDIT.MVMT.APPL:
*---------------
    LEN.TYPE = LEN(Y.ASSET.TYPE.PRIC)
    REQ.PEN.LEN = Y.ASSET.TYPE.PRIC[((LEN.TYPE-PENL.INT.LEN)+1),PENL.INT.LEN]
    REQ.CHG.LEN = Y.ASSET.TYPE.PRIC[((LEN.TYPE-PROM.CHG.LEN)+1),PROM.CHG.LEN]
    REQ.LEN = Y.ASSET.TYPE.PRIC[((LEN.TYPE-AC.LEN)+1),AC.LEN]
    REQ.INT.LEN = Y.ASSET.TYPE.PRIC[((LEN.TYPE-PRIN.INT.LEN)+1),PRIN.INT.LEN]
    IF (REQ.LEN EQ 'ACCOUNT') OR (REQ.INT.LEN EQ 'PRINCIPALINT') OR (TEMP.FLG EQ 0) OR (REQ.PEN.LEN EQ 'PENALTINT') THEN
        Y.OPEN.BAL = ''; Y.DEBIT.MVMT = ''; Y.CREDIT.MVMT = ''
        Y.OPEN.BAL =  SUM(R.EB.CON.BAL<ECB.OPEN.BALANCE,Y.CNT.CUR.TYPE>)
        Y.DEBIT.MVMT = SUM(R.EB.CON.BAL<ECB.DEBIT.MVMT,Y.CNT.CUR.TYPE>)
        Y.CREDIT.MVMT = SUM(R.EB.CON.BAL<ECB.CREDIT.MVMT,Y.CNT.CUR.TYPE>)
        Y.BAL.PRIC = Y.OPEN.BAL + Y.DEBIT.MVMT + Y.CREDIT.MVMT
    END
RETURN
END
