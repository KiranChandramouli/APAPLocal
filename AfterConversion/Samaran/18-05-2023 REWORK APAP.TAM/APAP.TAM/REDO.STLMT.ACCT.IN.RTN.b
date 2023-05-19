* @ValidationCode : MjotODk4NDEzMTkyOkNwMTI1MjoxNjg0NDEzMDE3MjA1OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 18:00:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.STLMT.ACCT.IN.RTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.STLMT.ACCT.IN.RTN
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is to validate the accounting action need to be
* done and raise accounting entries.for tc05,tc06,tc07


*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.VISA.STLMT.05TO37

*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE           WHO                 REFERENCE           DESCRIPTION
* 03.12.2010     H GANESH            ODR-2010-08-0469    INITIAL CREATION
* 22/01/2019     Vignesh Kumaar R                        BRD003 [UNARED]
** 17-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 17-04-2023 Skanda R22 Manual Conversion - CALL RTN FORMAT MODIFIED
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CARD.ISSUE
    $INSERT I_F.ATM.REVERSAL ;* R22 Auto conversion
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.REDO.VISA.STLMT.05TO37
*   $INSERT I_F.REDO.VISA.OUTGOING ;* R22 Auto conversion
    $INSERT I_F.VISA.TC40.OUT.FILE
    $INSERT I_F.REDO.STLMT.REASON.CODE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON

    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    POS1=''
    MODIFY.RTN=''
    Y.VISA.STLMT.ID=''
    R.VISA.STLMT=''
    R.FUNDS.TRANSFER=''

    Y.TC.CODE.LOCATE=TC.CODE

    IF R.REDO.STLMT.LINE<VISA.SETTLE.CARD.ACCEPTOR.ID>[15,1] EQ 'P' THEN
        Y.TC.CODE.LOCATE=TC.CODE : "P"
    END

    IF ERROR.MESSAGE EQ '' THEN
        GOSUB PROCESS.NEXT
    END
    IF ERROR.MESSAGE NE '' THEN
        BEGIN CASE
            CASE TC.CODE EQ '05'
                TC.CODE.ALTERNATE='15'
            CASE TC.CODE EQ '06'
                TC.CODE.ALTERNATE='16'
            CASE TC.CODE EQ '07'
                TC.CODE.ALTERNATE='17'
        END CASE
        IF ERROR.MESSAGE EQ 'USAGE.CODE' THEN
            GOSUB ACCT.ENTRY
        END
        IF ERROR.MESSAGE NE '' AND ERROR.MESSAGE NE 'USAGE.CODE' THEN
            GOSUB REJECT.ENTRY
            IF AUTO.CHG.BACK EQ 'YES' THEN
                GOSUB AUTO.CHRGBCK
            END
        END
    END

RETURN
*----------------------------------------------------------------------
PROCESS.NEXT:
*----------------------------------------------------------------------

    LOCATE Y.TC.CODE.LOCATE IN R.REDO.APAP.H.PARAMETER<PARAM.TC.CODE,1> SETTING POS1 THEN

        IF R.REDO.STLMT.LINE<VISA.SETTLE.DEST.CCY.CODE> EQ C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE> THEN
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.DR.ACCT,POS1>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.CR.ACCT,POS1>
        END ELSE
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.DR.ACCT,POS1>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.CR.ACCT,POS1>
        END
        MODIFY.RTN=R.REDO.APAP.H.PARAMETER<PARAM.MODIFY.RTN,POS1>

    END

* Fix for 2795723 [BRD003 UNARED #1]

    IF R.ATM.REVERSAL<AT.REV.WAIVE.FLAG> EQ 'Y' THEN
        R.FUNDS.TRANSFER<FT.CHARGE.CODE> = 'WAIVE'
        R.FUNDS.TRANSFER<FT.COMMISSION.CODE> = 'WAIVE'
    END

* End of Fix

    IF MODIFY.RTN NE '' THEN
        OUT.PARAM<1>=DR.ACCT
        OUT.PARAM<2>=CR.ACCT
        CALL @MODIFY.RTN(OUT.PARAM)
    END

    Y.ACC.NO = R.ATM.REVERSAL<AT.REV.ACCOUNT.NUMBER>
    IF DR.ACCT EQ '' THEN
        DR.ACCT=Y.ACC.NO
        R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>=R.ATM.REVERSAL<AT.REV.FTTC.ID>
    END
    IF CR.ACCT EQ '' THEN
        CR.ACCT=Y.ACC.NO
        R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>=R.ATM.REVERSAL<AT.REV.FTTC.ID>
    END

    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>=DR.ACCT
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>=CR.ACCT

    CALL F.READ(FN.ACCOUNT,DR.ACCT,R.DR.ACC,F.ACCOUNT,ACC.ERR)
    CALL F.READ(FN.ACCOUNT,CR.ACCT,R.CR.ACC,F.ACCOUNT,ACC.ERR)
    Y.DR.CCY=R.DR.ACC<AC.CURRENCY>
    Y.CR.CCY=R.CR.ACC<AC.CURRENCY>

    R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>=Y.DR.CCY  ;* Debit Account
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>=Y.CR.CCY ;* Credit Account

    CR.AMT=R.REDO.STLMT.LINE<VISA.SETTLE.DEST.AMT>

    IF TC.CODE NE 06 THEN
        R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>     = CR.AMT
        R.FUNDS.TRANSFER<FT.CREDIT.VALUE.DATE> = TODAY
*   R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>  =R.ATM.REVERSAL<AT.REV.T24.DATE>
        R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>  = TODAY
    END ELSE
        R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>    =CR.AMT
        R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>=TODAY
    END
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.AT.UNIQUE.ID>=ATM.REVERSAL.ID
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.POS.COND>=R.ATM.REVERSAL<AT.REV.POS.COND>
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.BIN.NO>=CARD.NUMBER[1,6]
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.AT.AUTH.CODE>=R.REDO.STLMT.LINE<VISA.SETTLE.AUTH.CODE>
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.ATM.TERM.ID>=R.REDO.STLMT.LINE<VISA.SETTLE.TERMINAL.ID>
    GOSUB OFS.POST
RETURN
*----------------------------------------------------------------------
OFS.POST:
*----------------------------------------------------------------------

    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.STLMT.ID>=Y.STL.ID
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.STLMT.APPL>='REDO.VISA.STLMT.05TO37'
    APP.NAME = 'FUNDS.TRANSFER'
    OFSFUNCT='I'
    PROCESS  = ''
    OFSVERSION = R.REDO.APAP.H.PARAMETER<PARAM.FT.VERSION,POS1>
    GTSMODE = ''
    TRANSACTION.ID=''
    OFSRECORD = ''
    OFS.MSG.ID =''
    OFS.ERR = ''
    NO.OF.AUTH='0'
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FUNDS.TRANSFER,STR.FT)
    R.FUNDS.TRANSFER=''
    OFS.SRC='REDO.VISA.OUTGOING'

    APP.NAME ='AC.LOCKED.EVENTS'
    OFSFUNCT='R'
    OFSVERSION = R.REDO.APAP.H.PARAMETER<PARAM.AC.LCK.REV.VERSION,POS1>
    TRANSACTION.ID=R.ATM.REVERSAL<AT.REV.TXN.REF>
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,'',STR.ACLK)
    OFS.STRING.FINAL=STR.ACLK:@FM:STR.FT
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)


RETURN
*----------------------------------------------------------------------
ACCT.ENTRY:
*----------------------------------------------------------------------
* In this part, FT has been raised for USAGE.CODE 2


    Y.TC.CODE.REP=TC.CODE:'2'
    LOCATE Y.TC.CODE.REP IN R.REDO.APAP.H.PARAMETER<PARAM.TC.CODE,1> SETTING POS2 THEN
        IF R.REDO.STLMT.LINE<VISA.SETTLE.DEST.CCY.CODE> EQ C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE> THEN
            CR.ACCT.1=R.REDO.APAP.H.PARAMETER<PARAM.CR.ACCT,POS2>
            DR.ACCT.1=R.REDO.APAP.H.PARAMETER<PARAM.DR.ACCT,POS2>
        END ELSE
            CR.ACCT.1=R.REDO.APAP.H.PARAMETER<PARAM.FOR.CR.ACCT,POS2>
            DR.ACCT.1=R.REDO.APAP.H.PARAMETER<PARAM.FOR.DR.ACCT,POS2>
        END

        Y.FT.VERSION.1=R.REDO.APAP.H.PARAMETER<PARAM.FT.VERSION,POS2>

    END

    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>=DR.ACCT.1
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>=CR.ACCT.1
    CALL F.READ(FN.ACCOUNT,CR.ACCT.1,R.CR.ACC.1,F.ACCOUNT,ACCT.ERR)
    CALL F.READ(FN.ACCOUNT,DR.ACCT.1,R.DR.ACC.1,F.ACCOUNT,ACCT.ERR)

    R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY> = R.DR.ACC.1<AC.CURRENCY>
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY> = R.CR.ACC.1<AC.CURRENCY>

    CR.AMT = R.REDO.STLMT.LINE<VISA.SETTLE.DEST.AMT>

    IF TC.CODE EQ 06 THEN
        R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>=CR.AMT
        R.FUNDS.TRANSFER<FT.CREDIT.VALUE.DATE>=TODAY
    END ELSE
        R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>=CR.AMT
        R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>=TODAY
    END

    ATM.REVERSAL.ID =CARD.NUMBER:'.':R.REDO.STLMT.LINE<VISA.SETTLE.AUTH.CODE>
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.AT.UNIQUE.ID>=ATM.REVERSAL.ID
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.STLMT.ID>=Y.STL.ID
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.STLMT.APPL>='REDO.VISA.STLMT.05TO37'

    APP.NAME = 'FUNDS.TRANSFER'
    OFSFUNCT = 'I'
    PROCESS = ''
    OFSVERSION =Y.FT.VERSION.1
    GTSMODE  = ''
    TRANSACTION.ID  =''
    OFSRECORD  =''
    OFS.MSG.ID = ''
    OFS.ERR  = ''
    OFS.SOURCE.ID = 'REDO.VISA.OUTGOING'
    NO.OF.AUTH = '0'
    OFS.STRING  =''
    OFS.ERR =''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FUNDS.TRANSFER,OFS.STRING)
    R.FUNDS.TRANSFER=''
    CALL OFS.POST.MESSAGE(OFS.STRING,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

    CALL F.READ(FN.ATM.REVERSAL,ATM.REVERSAL.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERR)
    IF R.ATM.REVERSAL EQ '' THEN
        SEL.CMD='SELECT ':FN.REDO.VISA.OUTGOING:' WITH @ID EQ ...':R.REDO.STLMT.LINE<VISA.SETTLE.CHARGEBACK.REF.NO>:' AND ACCOUNT.NUMBER EQ ':R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>:' AND PURCHASE.DATE EQ ':R.REDO.STLMT.LINE<VISA.SETTLE.PURCHASE.DATE>
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
        Y.VISA.OUT.ID=SEL.LIST<1>
    END ELSE
        Y.VISA.OUT.ID=R.ATM.REVERSAL<AT.REV.VISA.CHGBCK.REF>
        Y.VISA.STLMT.ID=R.ATM.REVERSAL<AT.REV.VISA.STLMT.REF>
    END
    CALL F.READ(FN.REDO.VISA.OUTGOING,Y.VISA.OUT.ID,R.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING,OUT.ERR)

    R.REDO.VISA.OUTGOING<VISA.OUT.FINAL.STATUS>='REPRESENTMENT'
    R.REDO.VISA.OUTGOING<VISA.OUT.STLMT.REF>=Y.STL.ID
    CALL F.WRITE(FN.REDO.VISA.OUTGOING,Y.VISA.OUT.ID,R.REDO.VISA.OUTGOING)
    IF Y.VISA.STLMT.ID NE '' THEN
        CALL F.READ(FN.REDO.VISA.STLMT.05TO37,Y.VISA.STLMT.ID,R.VISA.STLMT,F.REDO.VISA.STLMT.05TO37,STMT.ERR)
        IF R.VISA.STLMT NE '' THEN
            R.VISA.STLMT<VISA.SETTLE.FINAL.STATUS>='SETTLED'
            CALL F.WRITE(FN.REDO.VISA.STLMT.05TO37,Y.VISA.STLMT.ID,R.VISA.STLMT)
        END
    END

RETURN
*-------------------------------------------------------------------
AUTO.CHRGBCK:
*-------------------------------------------------------------------

    LOCATE TC.CODE.ALT IN R.REDO.APAP.H.PARAMETER<PARAM.TC.CODE,1> SETTING ALT.POS THEN
        IF R.REDO.STLMT.LINE<VISA.SETTLE.DEST.CCY.CODE> EQ C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE> THEN
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.DR.ACCT,ALT.POS>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.CR.ACCT,ALT.POS>
        END ELSE
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.DR.ACCT,ALT.POS>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.CR.ACCT,ALT.POS>
        END
    END



    CALL F.READ(FN.ACCOUNT,CR.ACCT,R.CR.ACC,F.ACCOUNT,ACCT.ERR)
    CALL F.READ(FN.ACCOUNT,DR.ACCT,R.DR.ACC,F.ACCOUNT,ACCT.ERR)

    CR.AMT = R.REDO.STLMT.LINE<VISA.SETTLE.DEST.AMT>

    ATM.REVERSAL.ID =CARD.NUMBER:'.':R.REDO.STLMT.LINE<VISA.SETTLE.AUTH.CODE>
    CALL F.READ(FN.ATM.REVERSAL,ATM.REVERSAL.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERR)


    R.ARRAY=''
    CALL F.WRITE(FN.REDO.VISA.CHGBCK.LOG,Y.OUT.ID,R.ARRAY)
    Y.VISA.GEN.ID=Y.OUT.ID:'*':'REDO.VISA.OUTGOING'
    CALL F.WRITE(FN.REDO.VISA.GEN.OUT,Y.VISA.GEN.ID,R.ARRAY)

    Y.REASON.CODE = R.REDO.STLMT.LINE<VISA.SETTLE.REASON.CODE>
    CALL F.READ(FN.REDO.STLMT.REASON.CODE,Y.REASON.CODE,R.REDO.STLMT.REASON.CODE,F.REDO.STLMT.REASON.CODE,REDO.STLMT.REASON.CODE.ERR)
    FRAUD.FLAG = R.REDO.STLMT.REASON.CODE<STM.RSN.CODE.FRAUD.FLAG>

    IF FRAUD.FLAG EQ 'Y' THEN
        GOSUB VISA.TC40.UPDATE
    END

RETURN
*---------------------------------------------------------------
VISA.TC40.UPDATE:
*---------------------------------------------------------------
    R.VISA.TC40=''
    R.VISA.TC40<VISA.TC40.TRANSACTION.CODE>=40
    R.VISA.TC40<VISA.TC40.TRANS.CODE.QUAL>=0
    R.VISA.TC40<VISA.TC40.TRANS.COMP.SEQ.1>=0
    R.VISA.TC40<VISA.TC40.DESTINATION.BIN>=400050
    R.VISA.TC40<VISA.TC40.SOURCE.BIN>=479409
    R.VISA.TC40<VISA.TC40.ACCOUNT.NUMBER>=R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>
    R.VISA.TC40<VISA.TC40.ACCOUNT.NO.EXTN>=''
    R.VISA.TC40<VISA.TC40.ACQUIRER.REF.NO>=R.REDO.STLMT.LINE<VISA.SETTLE.ACQR.REF.NUM>
    R.VISA.TC40<VISA.TC40.ACQUIRER.BUS.ID>=R.REDO.STLMT.LINE<VISA.SETTLE.ACQR.BUS.ID>
    R.VISA.TC40<VISA.TC40.RESPONSE.CODE>=''
    R.VISA.TC40<VISA.TC40.PURCHASE.DATE>=R.REDO.STLMT.LINE<VISA.SETTLE.PURCHASE.DATE>
    R.VISA.TC40<VISA.TC40.MERCHANT.NAME>=R.REDO.STLMT.LINE<VISA.SETTLE.MERCHANT.NAME>
    R.VISA.TC40<VISA.TC40.MERCHANT.CITY>=R.REDO.STLMT.LINE<VISA.SETTLE.MERCHANT.CITY>
    R.VISA.TC40<VISA.TC40.MERCHNT.CTRY.CODE>=R.REDO.STLMT.LINE<VISA.SETTLE.MERCH.CONTRY.CDE>
    R.VISA.TC40<VISA.TC40.MERCHNT.CATG.CODE>=R.REDO.STLMT.LINE<VISA.SETTLE.MERCH.CATEG.CDE>
    R.VISA.TC40<VISA.TC40.MRCHNT.ST.PRV.CDE>=''
    R.VISA.TC40<VISA.TC40.FRAUD.AMOUNT>=''
    R.VISA.TC40<VISA.TC40.FRAUD.CCY.CODE>='840'
    R.VISA.TC40<VISA.TC40.VIC.PSING.DATE>=''
    R.VISA.TC40<VISA.TC40.ISS.GENE.AUTH>='Y'
    R.VISA.TC40<VISA.TC40.NOTI.CODE>='1'
    R.VISA.TC40<VISA.TC40.ACCT.SEQ.NO>=''
    R.VISA.TC40<VISA.TC40.RESERVED.ONE>=''
    R.VISA.TC40<VISA.TC40.FRAUD.TYPE>=''
    GOSUB GET.EXP.DATE
    R.VISA.TC40<VISA.TC40.CARD.EXP.DATE>=Y.EXP.DATE
    R.VISA.TC40<VISA.TC40.MERHNT.POST.CDE>=''
    R.VISA.TC40<VISA.TC40.FRAUD.INV.STA>=''
    R.VISA.TC40<VISA.TC40.REIMB.ATTR>=R.REDO.STLMT.LINE<VISA.SETTLE.REIMBURSMNT.ATTRIB>
    R.VISA.TC40<VISA.TC40.TRANS.COMP.SEQ.2>='2'
    R.VISA.TC40<VISA.TC40.TRANS.ID>=0
    R.VISA.TC40<VISA.TC40.EXC.TRANS.ID.RSN>=''
    R.VISA.TC40<VISA.TC40.MUL.CLR.SEQ.NO>=0
    R.VISA.TC40<VISA.TC40.CARD.ACPR.ID>=R.REDO.STLMT.LINE<VISA.SETTLE.CARD.ACCEPTOR.ID>
    R.VISA.TC40<VISA.TC40.TRML.ID>=R.REDO.STLMT.LINE<VISA.SETTLE.TERMINAL.ID>
    R.VISA.TC40<VISA.TC40.TRV.ACY.ID>=''
    R.VISA.TC40<VISA.TC40.CASH.BCK.IND>=''
    R.VISA.TC40<VISA.TC40.AUTH.CDE>=R.REDO.STLMT.LINE<VISA.SETTLE.AUTH.CODE>
    R.VISA.TC40<VISA.TC40.CRHDR.ID.MT.USD>=R.REDO.STLMT.LINE<VISA.SETTLE.CARD.ID.MTHD>
    R.VISA.TC40<VISA.TC40.POS.ERY.MD>=R.REDO.STLMT.LINE<VISA.SETTLE.POS.ENTRY.MODE>
    R.VISA.TC40<VISA.TC40.POS.TERL.CAP>=R.REDO.STLMT.LINE<VISA.SETTLE.POS.TERM.CAP>
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
*CALL VISA.TC40.WRITE(Y.ID.40,R.VISA.TC40) ;*R22 MANUAL CODE CONVERSION
    CALL APAP.TAM.visaTc40Write(Y.ID.40,R.VISA.TC40) ;*R22 MANUAL CODE CONVERSION
    Y.VISA.GEN.ID.1=Y.ID.40:'*VISA.TC40.OUT.FILE'
    CALL F.WRITE(FN.REDO.VISA.GEN.OUT,Y.VISA.GEN.ID.1,R.ARRAY)
RETURN

*---------------------------------------------
GET.EXP.DATE:
*---------------------------------------------
    CARD.BIN=R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>[1,6]
    CALL F.READ(FN.REDO.CARD.BIN,CARD.BIN,R.CARD.BIN,F.REDO.CARD.BIN,BIN.ERR)
    Y.CARD.TYPE=R.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
    Y.CARD.EXT=R.REDO.STLMT.LINE<VISA.SETTLE.ACCT.NUM.EXT>
    IF Y.CARD.EXT EQ 0 THEN
        Y.CARD.EXT=''
    END ELSE
        Y.CARD.EXT=FMT(Y.CARD.EXT,"R0%3")
    END

    Y.BREAK.FLAG=1
    LOOP

        REMOVE Y.CRD.TYP FROM Y.CARD.TYPE SETTING POS.CRD

    WHILE Y.CRD.TYP:POS.CRD
        IF Y.BREAK.FLAG THEN
            Y.CARD.ISSUE.ID=Y.CRD.TYP:'.':R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>:Y.CARD.EXT
            CALL F.READ(FN.CARD.ISSUE,Y.CARD.ISSUE.ID,R.CARD.ISSUE,F.CARD.ISSUE,CARD.ISS.ERR)
            IF R.CARD.ISSUE THEN

                Y.EXP.DATE=R.CARD.ISSUE<CARD.IS.EXPIRY.DATE>[5,2]:R.CARD.ISSUE<CARD.IS.EXPIRY.DATE>[3,2]
                Y.CARD.TYPE=Y.CRD.TYP
                Y.BREAK.FLAG=0


            END
        END
    REPEAT


RETURN

*---------------------------------------------
REJECT.ENTRY:
*---------------------------------------------
* This part Raises an Entry In case of any Rejection

    LOCATE TC.CODE.ALTERNATE IN R.REDO.APAP.H.PARAMETER<PARAM.TC.CODE,1> SETTING POS2 THEN
        IF R.REDO.STLMT.LINE<VISA.SETTLE.DEST.CCY.CODE> EQ C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE> THEN
            DR.ACCT.1=R.REDO.APAP.H.PARAMETER<PARAM.DR.ACCT,POS2>     ;* Interchanged debit and credit acc
            CR.ACCT.1=R.REDO.APAP.H.PARAMETER<PARAM.CR.ACCT,POS2>     ;* Interchanged debit and credit acc
        END ELSE
            DR.ACCT.1=R.REDO.APAP.H.PARAMETER<PARAM.FOR.DR.ACCT,POS2>
            CR.ACCT.1=R.REDO.APAP.H.PARAMETER<PARAM.FOR.CR.ACCT,POS2>
        END
        MODIFY.RTN.1=R.REDO.APAP.H.PARAMETER<PARAM.MODIFY.RTN,POS2>
        Y.FT.VERSION.1=R.REDO.APAP.H.PARAMETER<PARAM.FT.VERSION,POS2>

    END
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>=DR.ACCT.1
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>=CR.ACCT.1
    CALL F.READ(FN.ACCOUNT,CR.ACCT.1,R.CR.ACC.1,F.ACCOUNT,ACCT.ERR)
    CALL F.READ(FN.ACCOUNT,DR.ACCT.1,R.DR.ACC.1,F.ACCOUNT,ACCT.ERR)

    R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY> = R.DR.ACC.1<AC.CURRENCY>
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY> = R.CR.ACC.1<AC.CURRENCY>

    CR.AMT = R.REDO.STLMT.LINE<VISA.SETTLE.DEST.AMT>

    IF TC.CODE EQ 06 THEN
        R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>=CR.AMT
        R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>=TODAY
    END ELSE
        R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>=CR.AMT
        R.FUNDS.TRANSFER<FT.CREDIT.VALUE.DATE>=TODAY
    END
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.AT.UNIQUE.ID>=ATM.REVERSAL.ID
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.STLMT.ID>=Y.STL.ID
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.STLMT.APPL>='REDO.VISA.STLMT.05TO37'

    APP.NAME = 'FUNDS.TRANSFER'
    OFSFUNCT = 'I'
    PROCESS = ''
    OFSVERSION =Y.FT.VERSION.1
    GTSMODE  = ''
    TRANSACTION.ID  =''
    OFSRECORD  =''
    OFS.MSG.ID = ''
    OFS.ERR  = ''
    OFS.SOURCE.ID = 'REDO.VISA.OUTGOING'
    NO.OF.AUTH = '0'
    OFS.STRING  =''
    OFS.ERR =''
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FUNDS.TRANSFER,OFS.STRING)
    R.FUNDS.TRANSFER=''
    CALL OFS.POST.MESSAGE(OFS.STRING,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN


END
