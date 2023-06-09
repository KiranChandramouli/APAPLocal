SUBROUTINE REDO.VISA.OUT.TC40.GEN
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VI.VISA.CHGBCK
***********************************************************************************
*Description: This is a version routine attached to VERSION REDO.VISA.SETTLEMENT.05TO37,APP.CHGBCK
*             as input routine to update outgoing file for sending chargeback
*****************************************************************************
*linked with: REDO.VISA.STLMT.05TO37
*In parameter: NA
*Out parameter: NA
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*03.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.ISSUE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CURRENCY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.VISA.TC40.OUT.FILE
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.REDO.STLMT.REASON.CODE
    $INSERT I_F.REDO.CARD.BIN


    GOSUB INIT
    GOSUB PROCESS

RETURN

****
INIT:
****


    FN.REDO.STLMT.REASON.CODE = 'F.REDO.STLMT.REASON.CODE'
    F.REDO.STLMT.REASON.CODE = ''
    CALL OPF(FN.REDO.STLMT.REASON.CODE,F.REDO.STLMT.REASON.CODE)

    FN.REDO.CARD.BIN='F.REDO.CARD.BIN'
    F.REDO.CARD.BIN=''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    FN.CARD.ISSUE='F.CARD.ISSUE'
    F.CARD.ISSUE=''
    CALL OPF(FN.CARD.ISSUE,F.CARD.ISSUE)

    FN.ATM.REVERSAL='F.ATM.REVERSAL'
    F.ATM.REVERSAL=''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

RETURN

*******
PROCESS:
*******
    R.REDO.VISA.OUTGOING=''
    Y.ID.NEW=ID.NEW

    Y.REASON.CODE = R.NEW(VISA.OUT.REASON.CODE)
    CALL F.READ(FN.REDO.STLMT.REASON.CODE,Y.REASON.CODE,R.REDO.STLMT.REASON.CODE,F.REDO.STLMT.REASON.CODE,REDO.STLMT.REASON.CODE.ERR)
    FRAUD.FLAG = R.REDO.STLMT.REASON.CODE<STM.RSN.CODE.FRAUD.FLAG>


    Y.REASON.CODE.OLD = R.OLD(VISA.OUT.REASON.CODE)
    CALL F.READ(FN.REDO.STLMT.REASON.CODE,Y.REASON.CODE.OLD,R.REDO.STLMT.REASON.CODE.OLD,F.REDO.STLMT.REASON.CODE,REDO.STLMT.REASON.CODE.ERR)
    FRAUD.FLAG.OLD = R.REDO.STLMT.REASON.CODE.OLD<STM.RSN.CODE.FRAUD.FLAG>

    IF FRAUD.FLAG EQ 'Y' AND FRAUD.FLAG.OLD NE 'Y' THEN
        GOSUB VISA.TC40.UPDATE
    END
    ID.NEW=Y.ID.NEW
RETURN

*--------------------------------------------------------------------
VISA.TC40.UPDATE:
*--------------------------------------------------------------------
    R.VISA.TC40<VISA.TC40.TRANSACTION.CODE>=40
    R.VISA.TC40<VISA.TC40.TRANS.CODE.QUAL>=0
    R.VISA.TC40<VISA.TC40.TRANS.COMP.SEQ.1>=0
    R.VISA.TC40<VISA.TC40.DESTINATION.BIN>=400050
    R.VISA.TC40<VISA.TC40.SOURCE.BIN>=479409
    R.VISA.TC40<VISA.TC40.ACCOUNT.NUMBER>=R.NEW(VISA.OUT.ACCOUNT.NUMBER)
    R.VISA.TC40<VISA.TC40.ACCOUNT.NO.EXTN>=''
    R.VISA.TC40<VISA.TC40.ACQUIRER.REF.NO>=R.NEW(VISA.OUT.ACQR.REF.NUM)
    R.VISA.TC40<VISA.TC40.ACQUIRER.BUS.ID>=R.NEW(VISA.OUT.ACQR.BUS.ID)
    R.VISA.TC40<VISA.TC40.RESPONSE.CODE>=''
    R.VISA.TC40<VISA.TC40.PURCHASE.DATE>=R.NEW(VISA.OUT.PURCHASE.DATE)
    R.VISA.TC40<VISA.TC40.MERCHANT.NAME>=R.NEW(VISA.OUT.MERCHANT.NAME)
    R.VISA.TC40<VISA.TC40.MERCHANT.CITY>=R.NEW(VISA.OUT.MERCHANT.CITY)
    R.VISA.TC40<VISA.TC40.MERCHNT.CTRY.CODE>=R.NEW(VISA.OUT.MERCH.CONTRY.CDE)
    R.VISA.TC40<VISA.TC40.MERCHNT.CATG.CODE>=R.NEW(VISA.OUT.MERCH.CATEG.CDE)
    R.VISA.TC40<VISA.TC40.MRCHNT.ST.PRV.CDE>=''
    R.VISA.TC40<VISA.TC40.FRAUD.AMOUNT>=R.OLD(VISA.OUT.DEST.AMT)
    R.VISA.TC40<VISA.TC40.FRAUD.CCY.CODE>=R.NEW(VISA.OUT.DEST.CCY.CODE)
    R.VISA.TC40<VISA.TC40.STLMT.REF>=Y.ID.NEW

    FILE.DATES=TRIM(R.NEW(VISA.OUT.CENTRL.PROCES.DATE))

    IF FILE.DATES EQ '' THEN
        CARD.NUMBER=R.NEW(VISA.OUT.ACCOUNT.NUMBER)
        CARD.NUM.EXT=R.NEW(VISA.OUT.ACCT.NUM.EXT)

        IF CARD.NUM.EXT EQ 0 THEN
            CARD.NUMBER = R.NEW(VISA.OUT.ACCOUNT.NUMBER)
        END ELSE
            CARD.NUMBER = CARD.NUMBER:FMT(CARD.NUM.EXT,"R0%3")
        END

        ATM.REV.ID=CARD.NUMBER:'.':R.NEW(VISA.OUT.AUTH.CODE)

        CALL F.READ(FN.ATM.REVERSAL,ATM.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.REVERSAL.ERR)

        PURCHASE.DATE=R.ATM.REVERSAL<AT.REV.CAPTURE.DATE>

        JUL.PUR=ICONV(PURCHASE.DATE,"DJ")
        JUL.PUR.D=OCONV(JUL.PUR,"DJ")
        JUL.PUR.D=FMT(JUL.PUR.D,"R%3")
        JUL.PUR.Y=OCONV(JUL.PUR,"DY")
        FILE.DATES=JUL.PUR.Y[4,1]:JUL.PUR.D

    END

    R.VISA.TC40<VISA.TC40.VIC.PSING.DATE>=FILE.DATES
    R.VISA.TC40<VISA.TC40.ISS.GENE.AUTH>='Y'
    R.VISA.TC40<VISA.TC40.NOTI.CODE>='1'
    R.VISA.TC40<VISA.TC40.ACCT.SEQ.NO>=''
    R.VISA.TC40<VISA.TC40.RESERVED.ONE>=''
    R.VISA.TC40<VISA.TC40.FRAUD.TYPE>=''
    GOSUB GET.EXP.DATE
    R.VISA.TC40<VISA.TC40.CARD.EXP.DATE>=Y.EXP.DATE
    R.VISA.TC40<VISA.TC40.MERHNT.POST.CDE>=''
    R.VISA.TC40<VISA.TC40.FRAUD.INV.STA>=''
    R.VISA.TC40<VISA.TC40.REIMB.ATTR>=R.NEW(VISA.SETTLE.REIMBURSMNT.ATTRIB)
    R.VISA.TC40<VISA.TC40.TRANS.COMP.SEQ.2>='2'
    R.VISA.TC40<VISA.TC40.TRANS.ID>=0
    R.VISA.TC40<VISA.TC40.EXC.TRANS.ID.RSN>=''
    R.VISA.TC40<VISA.TC40.MUL.CLR.SEQ.NO>=0
    R.VISA.TC40<VISA.TC40.CARD.ACPR.ID>=R.NEW(VISA.SETTLE.CARD.ACCEPTOR.ID)
    R.VISA.TC40<VISA.TC40.TRML.ID>=R.NEW(VISA.SETTLE.TERMINAL.ID)
    R.VISA.TC40<VISA.TC40.TRV.ACY.ID>=''
    R.VISA.TC40<VISA.TC40.CASH.BCK.IND>=''
    R.VISA.TC40<VISA.TC40.AUTH.CDE>=R.NEW(VISA.SETTLE.AUTH.CODE)
    R.VISA.TC40<VISA.TC40.CRHDR.ID.MT.USD>=R.NEW(VISA.SETTLE.CARD.ID.MTHD)
    R.VISA.TC40<VISA.TC40.POS.ERY.MD>=R.NEW(VISA.SETTLE.POS.ENTRY.MODE)
    R.VISA.TC40<VISA.TC40.POS.TERL.CAP>=R.NEW(VISA.SETTLE.POS.TERM.CAP)
    R.VISA.TC40<VISA.TC40.CRD.CAP>=''
    R.VISA.TC40<VISA.TC40.RESERVED.TWO>=''
    R.VISA.TC40<VISA.TC40.CSH.BCK.AMT>=0
    R.VISA.TC40<VISA.TC40.CRHD.AC.TRL.IND>=''
    R.VISA.TC40<VISA.TC40.MAIL.TEL.EC.IND>=''
    R.VISA.TC40<VISA.TC40.STATUS>='PENDING'
    Y.ID.COMPANY=ID.COMPANY
    CALL LOAD.COMPANY(Y.ID.COMPANY)
    FULL.FNAME = 'F.VISA.TC40.OUT.FILE'
    ID.T  = 'A'
    ID.N ='15'
    ID.CONCATFILE = ''
    COMI = ''
    PGM.TYPE = '.IDA'
    ID.NEW = ''
    V$FUNCTION = 'I'
    ID.NEW.LAST=''
    ID.NEWLAST = ID.NEW.LAST
    CALL GET.NEXT.ID(ID.NEWLAST,'F')
    ID.NEW.LAST=ID.NEWLAST
    Y.ID.40= COMI
    CALL VISA.TC40.WRITE(Y.ID.40,R.VISA.TC40)
*    Y.VISA.GEN.ID.1=Y.ID.40:'*VISA.TC40.OUT.FILE'
*   CALL F.WRITE(FN.REDO.VISA.GEN.OUT,Y.VISA.GEN.ID.1,R.ARRAY)


RETURN

*---------------------------------------------
GET.EXP.DATE:
*---------------------------------------------
    CARD.BIN=R.NEW(VISA.SETTLE.ACCOUNT.NUMBER)[1,6]
    CALL F.READ(FN.REDO.CARD.BIN,CARD.BIN,R.CARD.BIN,F.REDO.CARD.BIN,BIN.ERR)
    Y.CARD.TYPE=R.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
    Y.CARD.EXT=R.NEW(VISA.SETTLE.ACCT.NUM.EXT)
    IF Y.CARD.EXT EQ 0 THEN
        Y.CARD.EXT=''
    END ELSE
        Y.CARD.EXT=FMT(Y.CARD.EXT,"R0%3")
    END

* changing code to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279
    Y.BREAK.FLAG=1
    LOOP


        REMOVE Y.CRD.TYP FROM Y.CARD.TYPE SETTING CRD.POS


    WHILE Y.CRD.TYP:CRD.POS
        IF Y.BREAK.FLAG THEN
            Y.CARD.ISSUE.ID=Y.CRD.TYP:'.':R.NEW(VISA.SETTLE.ACCOUNT.NUMBER):Y.CARD.EXT

            CALL F.READ(FN.CARD.ISSUE,Y.CARD.ISSUE.ID,R.CARD.ISSUE,F.CARD.ISSUE,CARD.ISS.ERR)
            IF R.CARD.ISSUE THEN
                Y.EXP.DATE=R.CARD.ISSUE<CARD.IS.EXPIRY.DATE>[5,2]:R.CARD.ISSUE<CARD.IS.EXPIRY.DATE>[3,2]
                Y.CARD.TYPE=Y.CRD.TYP
                Y.BREAK.FLAG=0
            END
        END
    REPEAT
*changing end code to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279


RETURN
END
