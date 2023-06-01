* @ValidationCode : MjotMTE1MDgyNDI4NTpDcDEyNTI6MTY4NDgzNjA0OTgyOTpJVFNTOi0xOi0xOjEzNzU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1375
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.RETURNED.CHEQUES(Y.OUT.DATA)
*--------------------------------------------------------------------------
* Program Description
* Subroutine Type   : ENQUIRY ROUTINE
* Attached to       : REDO.APAP.NOF.RETURNED.CHEQUES.RPT
* Attached as       : NOFILE ROUTINE
* Primary Purpose   : To return data to the enquiry

* Incoming:  N/A
* ---------
*
* Outgoing:
* ---------
* Y.OUT.DATA - Data returned to the enquiry
*--------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------
* DATE         WHO                REFERENCE              DESCRIPTION
* 08-03-11    SUDHARSANAN S      ODR-2010-03-0083      Initial Creation
* 01-09-14    Egambaram A        PACS00309069          Changes done & Mapping changed as per user advice
* 01-09-14    Egambaram A        PACS00309069          Changes done for the field MOTIVO DE DEVOLUCION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM ,F.READ to CACHE.READ,SM to @SM, ++ to +=
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.COMPANY
    $INSERT I_F.USER
    $INSERT I_F.MNEMONIC.COMPANY
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_F.REDO.OUTWARD.RETURN
    $INSERT I_F.REDO.H.ROUTING.NUMBER
    $INSERT I_F.REDO.REJECT.REASON


    GOSUB INITIALISE
    GOSUB SELECTION
    IF ENQ.ERROR THEN
        RETURN
    END
    GOSUB PROCESS
RETURN
****************
INITIALISE:
****************

    FN.REDO.OTH.BANK.NAME = 'F.REDO.OTH.BANK.NAME'
    F.REDO.OTH.BANK.NAME = ''
    CALL OPF(FN.REDO.OTH.BANK.NAME,F.REDO.OTH.BANK.NAME)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    FN.DEPT.ACCT.OFFICER = "F.DEPT.ACCT.OFFICER"
    F.DEPT.ACCT.OFFICER = ""
    FN.REDO.CLEARING.OUTWARD = "F.REDO.CLEARING.OUTWARD"
    F.REDO.CLEARING.OUTWARD = ""
    FN.REDO.OUTWARD.RETURN = "F.REDO.OUTWARD.RETURN"
    F.REDO.OUTWARD.RETURN = ''
    FN.REDO.H.ROUTING.NUMBER = "F.REDO.H.ROUTING.NUMBER"
    F.REDO.H.ROUTING.NUMBER = ""
    FN.REDO.REJECT.REASON = "F.REDO.REJECT.REASON"
    F.REDO.REJECT.REASON = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
    CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)
    CALL OPF(FN.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN)
    CALL OPF(FN.REDO.H.ROUTING.NUMBER,F.REDO.H.ROUTING.NUMBER)
    CALL OPF(FN.REDO.REJECT.REASON,F.REDO.REJECT.REASON)
RETURN
**************
SELECTION:
**************
*Check the selection values
    Y.FROM.DATE = ''; Y.TO.DATE = ''; Y.AGENCY = ''
    Y.PAY.DEPT = '' ; Y.ACCT.OFF = '' ; Y.DATE =''
    GOSUB DATE.SELECT
    GOSUB AGENCY.SELECT
    GOSUB DAO.SELECT
    GOSUB PAY.DEPT.SELECT
RETURN

DATE.SELECT:
*==========
    LOCATE 'DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
        Y.DATE = D.RANGE.AND.VALUE<Y.DATE.POS>
    END
    IF Y.DATE THEN
        Y.FROM.DATE = FIELD(Y.DATE,@SM,1) ; Y.TO.DATE = FIELD(Y.DATE,@SM,2)
        IF NOT(NUM(Y.FROM.DATE)) OR NOT(NUM(Y.TO.DATE)) THEN
            ENQ.ERROR = "EB-DATE.NOT.VALID"
            RETURN
        END
        IF Y.FROM.DATE AND NOT(Y.TO.DATE) THEN
            ENQ.ERROR = "EB-TO.DATE.MAND"
            RETURN
        END
        IF NOT(Y.FROM.DATE) AND Y.TO.DATE THEN
            ENQ.ERROR = "EB-FROM.DATE.MAND"
            RETURN
        END
        IF Y.FROM.DATE GT Y.TO.DATE THEN
            ENQ.ERROR = "EB-TO.DATE.SHOULD.GT.FROM.DATE"
            RETURN
        END
        SEL.CMD = 'SSELECT ':FN.REDO.OUTWARD.RETURN
        SEL.CMD:= ' WITH DATE GE ':Y.FROM.DATE
        SEL.CMD:= ' AND DATE LE ':Y.TO.DATE
* Ega - S
*SEL.CMD:= ' AND DATE LE ':Y.TO.DATE:' AND CURRENCY EQ ':LCCY
* Ega - E
        Y.FROM.DATE1=ICONV(Y.FROM.DATE,"D4")
        Y.FROM.DATE1=OCONV(Y.FROM.DATE1,"D4")
        Y.TO.DATE1=ICONV(Y.TO.DATE,"D4")
        Y.TO.DATE1=OCONV(Y.TO.DATE1,"D4")
        Y.SEL.DISP = "FECHA :":Y.FROM.DATE1:" - ":Y.TO.DATE1
    END
RETURN
AGENCY.SELECT:
*============
    Y.AGENCY = ""
    LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGENCY.POS>
        SEL.CMD:= ' AND CO.CODE EQ ':Y.AGENCY
        Y.SEL.DISP:= ", AGENCIA :":Y.AGENCY
    END
RETURN

DAO.SELECT:
*=========
    Y.ACCT.EXECUTIVE = "" ; Y.ACCT.OFF = ''
    LOCATE 'ACCOUNT.OFFICER' IN D.FIELDS<1> SETTING Y.ACCT.EXE.POS THEN
        Y.ACCT.OFF = D.RANGE.AND.VALUE<Y.ACCT.EXE.POS>
        Y.ACCT.OFF.FLAG = 1
        Y.SEL.DISP:= ", OFICIAL DE CUENTA : ":Y.ACCT.OFF
    END
RETURN

PAY.DEPT.SELECT:
*==============
    Y.PAY.DEPT = ''
    LOCATE "PAYMENT.DEPT" IN D.FIELDS<1> SETTING PAY.DEPT.POS THEN
        Y.PAY.DEPT = D.RANGE.AND.VALUE<PAY.DEPT.POS>
        CALL F.READ(FN.ACCOUNT,Y.PAY.DEPT,R.ACC.PAY,F.ACCOUNT,ACC.PAY.ERR)
        PAY.ACC.CUS = R.ACC.PAY<AC.CUSTOMER>
        IF NOT(PAY.ACC.CUS) THEN
            SEL.CMD:= ' AND ACCOUNT EQ ':Y.PAY.DEPT
*           Y.SEL.DISP:= ", ADM. DE PAGOS : ":Y.PAY.DEPT
            Y.SEL.DISP:= ", CTAS INTERNAS-PAGOS : ":Y.PAY.DEPT
        END ELSE
            ENQ.ERROR = "EB-NOT.VALID.PAYMENT.ACCOUNT"
            RETURN
        END
    END
RETURN
************
PROCESS:
************
*Select the REDO.OUTWARD.RETURN based on selection condition

    SEL.CMD:=' BY DATE'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,REC.CODE)

    IF NO.OF.RECS THEN
        IF Y.ACCT.OFF.FLAG THEN
*To sort out the final array if account.officer selection field is selected
            CNT = 1
            LOOP
            WHILE CNT LE NO.OF.RECS
                VAR.OUTWARD.RETURN.ID = SEL.LIST<CNT>
                Y.DUPP.ID = FIELD(VAR.OUTWARD.RETURN.ID,"-",1)
                IF NUM(Y.DUPP.ID) THEN
                    CALL F.READ(FN.REDO.OUTWARD.RETURN,VAR.OUTWARD.RETURN.ID,R.REDO.OUT.RETURN,F.REDO.OUTWARD.RETURN,ROR.ERR)
                    Y.ACCOUNT.NO = R.REDO.OUT.RETURN<CLEAR.RETURN.ACCOUNT>
                    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
                    VAR.ACCT.OFF = R.ACCOUNT<AC.ACCOUNT.OFFICER>
                    IF Y.ACCT.OFF EQ VAR.ACCT.OFF THEN
                        VAR.ARRAY<-1> = VAR.OUTWARD.RETURN.ID
                    END
                END
                CNT += 1 ;*R22 AUTO CODE CONVERSION
            REPEAT
        END ELSE
            VAR.ARRAY = SEL.LIST
        END
        GOSUB GET.FIELD.VALUES
    END ELSE
        RETURN
    END
RETURN
*------------------------
GET.FIELD.VALUES:
*----------------------------

    CNT.ARRAY = DCOUNT(VAR.ARRAY,@FM)
    Y.COUNT = '1'
    LOOP
    WHILE Y.COUNT LE CNT.ARRAY
        VAR.AGENCY = ''; VAR.PAY.DEPT = ''; VAR.ACCT.OFFICER = ''; VAR.ACCOUNT.NO = ''
        VAR.TRAN.DATE=''; VAR.TRAN.TYPE='' ;
        VAR.ALT.ACCT= '' ; VAR.CUS.NO = ''
        VAR.CURRENCY = '' ; VAR.CHEQUE.NO = '' ; VAR.AMOUNT = '' ; VAR.DRAW.BANK = ''
        VAR.CHQ.DRAWER = ''; VAR.REJECT.REASON = '' ; VAR.USR.INP= '' ; VAR.USR.AUT= ''
        VAR.OUTWARD.ID = VAR.ARRAY<Y.COUNT>
        Y.DUP.ID = FIELD(VAR.OUTWARD.ID,'-',1)
        IF NUM(Y.DUP.ID) THEN
            GOSUB ANOTHER.PROCESS
        END
        Y.COUNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
RETURN
*------------------------------------------------------------------------------------
ANOTHER.PROCESS:
****************
    CALL F.READ(FN.REDO.OUTWARD.RETURN,VAR.OUTWARD.ID,R.ROR.REC,F.REDO.OUTWARD.RETURN,ROR.ERR)
    VAR.DATE = R.ROR.REC<CLEAR.RETURN.DATE>
    VAR.ACCOUNT.NO = R.ROR.REC<CLEAR.RETURN.ACCOUNT>
    VAR.AGENCY = R.ROR.REC<CLEAR.RETURN.CO.CODE>
    VAR.CURRENCY = LCCY
*VAR.CURRENCY = R.ROR.REC<CLEAR.RETURN.CURRENCY>
    VAR.CHEQUE.NO = R.ROR.REC<CLEAR.RETURN.CHEQUE.NO>
    VAR.AMOUNT = R.ROR.REC<CLEAR.RETURN.AMOUNT>
    VAR.ROUTE.NO = R.ROR.REC<CLEAR.RETURN.ROUTE.NO>
    VAR.ROUTE.NO = TRIM(VAR.ROUTE.NO,"0",L)
    VAR.REJ.CODE = R.ROR.REC<CLEAR.RETURN.REJECT.REASON>
    VAR.USR.INP = FIELD(R.ROR.REC<CLEAR.RETURN.INPUTTER>,'_',2)
    VAR.USR.AUT = FIELD(R.ROR.REC<CLEAR.RETURN.AUTHORISER>,'_',2)
    GOSUB GET.ACCOUNT.DETAILS
    GOSUB GET.DAO.DETAILS
    GOSUB GET.RTE.BANK.NAME
    GOSUB GET.REJECT.REASON
    GOSUB GET.CLRNG.OUTWRD.DETAILS
    GOSUB GET.OUTPUT.DATA
RETURN
GET.ACCOUNT.DETAILS:
*==================
    R.ACT.REC = ''
    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT.NO,R.ACT.REC,F.ACCOUNT,ACCT.ERR)
    VAR.ALT.ACCT = R.ACT.REC<AC.ALT.ACCT.ID>
    VAR.CUS.NO = R.ACT.REC<AC.CUSTOMER>
    VAR.ACCOUNT.OFF = R.ACT.REC<AC.ACCOUNT.OFFICER>
RETURN
GET.DAO.DETAILS:
*==============
    R.DAO.REC = ''
    CALL CACHE.READ(FN.DEPT.ACCT.OFFICER, VAR.ACCOUNT.OFF, R.DAO.REC, DAO.ERR) ;*R22 AUTO CODE CONVERSION
    VAR.ACCT.OFFICER = R.DAO.REC<EB.DAO.NAME>
RETURN
GET.RTE.BANK.NAME:
*================
    R.RHRN.REC= ''
* Ega - S
*   CALL F.READ(FN.REDO.H.ROUTING.NUMBER,VAR.ROUTE.NO,R.RHRN.REC,F.REDO.H.ROUTING.NUMBER,RHRN.ERR)
*   CALL F.READ(FN.REDO.OTH.BANK.NAME,VAR.ROUTE.NO,R.RHRN.REC,F.REDO.OTH.BANK.NAME,RHRN.ERR)
*   VAR.DRAW.BANK = R.RHRN.REC<REDO.ROUT.BANK.NAME>
*   VAR.DRAW.BANK = FIELD(R.RHRN.REC,'*',1)

    VAR.DRAW.BANK = VAR.ROUTE.NO
* Ega - E
RETURN
GET.REJECT.REASON:
*================
    Y.SPANISH = R.USER<EB.USE.LANGUAGE>
    R.REJ.REC = ''
    VAR.REJECT.CODE = FMT(VAR.REJ.CODE,"R%2")
    CALL F.READ(FN.REDO.REJECT.REASON,VAR.REJECT.CODE,R.REJ.REC,F.REDO.REJECT.REASON,REJECT.ERR)
* Ega - S
*VAR.REJECT.REASON = R.REJ.REC<REDO.REJ.DESC,LNGG>
    VAR.REJECT.REASON = R.REJ.REC<REDO.REJ.DESC,Y.SPANISH>
* Ega - E
    IF VAR.REJECT.REASON EQ '' THEN
        VAR.REJECT.REASON = R.REJ.REC<REDO.REJ.DESC,1>
    END
RETURN
GET.CLRNG.OUTWRD.DETAILS:
*=======================
*To select the REDO.OCLEARING.OUTWARD record from REDO.OUTWARD.RETURN when CHQ.STATUS = RETURNED
    SEL.LIST1 = '' ; NOR1=''
* Ega - S
*SEL.CMD1 = 'SSELECT ':FN.REDO.CLEARING.OUTWARD:' WITH CHQ.STATUS EQ RETURNED AND ACCOUNT EQ ':VAR.ACCOUNT.NO:' AND @ID LIKE ...':VAR.CHEQUE.NO
    SEL.CMD1 = 'SSELECT ':FN.REDO.CLEARING.OUTWARD:' WITH CHQ.STATUS EQ RETURNED AND @ID LIKE ...':VAR.CHEQUE.NO:' AND CHEQUE.NO EQ ':VAR.CHEQUE.NO
* Ega - E
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NOR1,OUT.ERR)

    Y.RCO.ID = SEL.LIST1<NOR1>
    CALL F.READ(FN.REDO.CLEARING.OUTWARD,Y.RCO.ID,R.RCO.REC,F.REDO.CLEARING.OUTWARD,RCO.ERR)

    Y.TRAN.DATE.TIME = R.RCO.REC<CLEAR.OUT.DATE.TIME>
* EGA - S
    IF Y.TRAN.DATE.TIME THEN
        VAR.YEAR = TODAY
        VAR.YEAR = VAR.YEAR[1,2]
        VAR.TRAN.DATE = VAR.YEAR:Y.TRAN.DATE.TIME[1,6]
    END
* EGA - E
    Y.RCO.ACCT = R.RCO.REC<CLEAR.OUT.ACCOUNT>
    IF NOT(VAR.CUS.NO) THEN
*       VAR.TRAN.TYPE = "PAYMENT"
        VAR.TRAN.TYPE = "PAGO"
    END ELSE
*       VAR.TRAN.TYPE = "DEPOSIT"
        VAR.TRAN.TYPE = "DEPOSITO"
    END
    VAR.CHQ.DRAWER = R.RCO.REC<CLEAR.OUT.DRAWER.ACCT>
RETURN
GET.OUTPUT.DATA:
*==============
*Form the array with the values fetch from table for each Returned cheques
    Y.OUT.DATA1 = ''
    Y.OUT.DATA1 = VAR.DATE:"*":VAR.TRAN.DATE:"*":VAR.TRAN.TYPE:"*"
    Y.OUT.DATA1:= VAR.ACCOUNT.NO:"*":VAR.ALT.ACCT:"*":VAR.CUS.NO:"*"
    Y.OUT.DATA1:= VAR.AGENCY:"*":VAR.CURRENCY:"*":VAR.CHEQUE.NO:"*"
    Y.OUT.DATA1:= VAR.AMOUNT:"*":VAR.DRAW.BANK:"*":VAR.CHQ.DRAWER:"*"
    Y.OUT.DATA1:= VAR.REJECT.REASON:"*":VAR.ACCT.OFFICER:"*":VAR.USR.INP:"*":VAR.USR.AUT:"*":Y.SEL.DISP
    Y.OUT.DATA<-1> = Y.OUT.DATA1
RETURN
*------------------------------------------------------------------------------
END
