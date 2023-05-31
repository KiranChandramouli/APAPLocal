* @ValidationCode : Mjo0NjIzNzkyODA6Q3AxMjUyOjE2ODQyMjI4MzE5NTI6SVRTUzotMTotMTo1Njk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 569
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                   REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           INCLUDE TO INSERT, ++ TO +=
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.E.NOF.GL.EXTRA.PAYMENT(ENQ.DATA)
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.REDO.AA.OVERPAYMENT ;*AUTO R22 CODE CONVERSION - END

 
    GOSUB INIT
    GOSUB SEL.EXTRA.PAY
    GOSUB PROCESS
    GOSUB PROCESS.SORT
RETURN

INIT:
******
    BAL.TYPE1 = "CURACCOUNT"; ENQ.DAT = ''; ENQ.DATA = ''
    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'; F.REDO.AA.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)
    R.EB.CONTRACT.BALANCES = ''; EB.CONTRACT.BALANCES.ERR = ''
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'; F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'; F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)
    Y.TODAY = TODAY
RETURN

SEL.EXTRA.PAY:
**************
    SEL.PCMD = ''; SEL.PLIST =''; SEL.PCNT = ''; SEL.PERR = ''
    SEL.PCMD = "SELECT ":FN.REDO.AA.OVERPAYMENT:" WITH STATUS EQ 'PENDIENTE' OR (STATUS EQ 'APLICADO' AND NEXT.DUE.DATE EQ ":Y.TODAY:") AND CUSTOMER.ID NE '' BY COMP.CODE"
    CALL EB.READLIST(SEL.PCMD,SEL.PLIST,'',SEL.PCNT,SEL.PERR)
RETURN

PROCESS:
********
    LOOP
        REMOVE SEL.ID FROM SEL.PLIST SETTING SEL.POSN
    WHILE SEL.ID:SEL.POSN

        ERR.REDO.AA.OVERPAYMENT = ''; R.REDO.AA.OVERPAYMENT = ''
        YFLD1 = ''; YFLD2 = ''; YFLD3 = ''; YFLD4 = ''; YFLD5 = ''; YFLD6 = ''
        YGL.CODE.TMP = ''; Y.IN.CONSOL.KEY = ''; Y.CONSOL.PART = ''; Y.CONSOL.KEY = ''
        CALL F.READ(FN.REDO.AA.OVERPAYMENT,SEL.ID,R.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT,ERR.REDO.AA.OVERPAYMENT)
        YFLD1 = R.REDO.AA.OVERPAYMENT<REDO.OVER.LOAN.NO>
        YFLD2 = R.REDO.AA.OVERPAYMENT<REDO.OVER.CUSTOMER.ID>
        YFLD3 = R.REDO.AA.OVERPAYMENT<REDO.OVER.PAYMENT.DATE>
        YFLD4 = R.REDO.AA.OVERPAYMENT<REDO.OVER.CURRENCY>
        YFLD5 = R.REDO.AA.OVERPAYMENT<REDO.OVER.COMP.CODE>
        YFLD6 = R.REDO.AA.OVERPAYMENT<REDO.OVER.AMOUNT>
        GOSUB SUB.PROCESS
        ENQ.DAT<-1> = YFLD5:'*':YSAP.ACC.NO:'*':YFLD1:'*':YFLD2:'*':YFLD3:'*':YFLD4:'*':YFLD6:'*':YGL.CODE.TMP
    REPEAT
RETURN

SUB.PROCESS:
************
    R.EB.CONTRACT.BALANCES = ''; EB.CONTRACT.BALANCES.ERR = ''
    CALL F.READ(FN.EB.CONTRACT.BALANCES,YFLD1,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ERR)
    IF NOT(R.EB.CONTRACT.BALANCES) THEN
        RETURN
    END
    Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
    Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
    Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':BAL.TYPE1
    Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''; Y.LINE = ''
    CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
    Y.LINE = Y.RPRTS:'.':Y.LINES
    REP.ERR = ''; R.LINE = ''; YGL.CODE.TMP = ''; YSAP.ACC.NO = ''
    CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
    YGL.CODE.TMP = R.LINE<RE.SRL.DESC,1>
    YSAP.ACC.NO = R.LINE<RE.SRL.DESC,3>
RETURN

PROCESS.SORT:
*************
    ENQ.DAT = SORT(ENQ.DAT)
    REC.ID = ''; YVAL1.LST = ''; YTOT.VAL3 = 0; YVAL2.LST = ''
    LOOP
        REMOVE RECD.ID FROM ENQ.DAT SETTING EQ.POSN
    WHILE RECD.ID:EQ.POSN
        YVAL1 = ''; YVAL2 = ''; YVAL3 = 0
        YVAL1 = FIELD(RECD.ID,'*',1)
        YVAL2 = FIELD(RECD.ID,'*',2)
        YVAL3 = FIELD(RECD.ID,'*',7)
        IF YVAL2 EQ YVAL2.LST OR YVAL2.LST EQ '' THEN
            YTOT.VAL3 += YVAL3 ;*AUTO R22 CODE CONVERSION
            ENQ.DATA<-1> = RECD.ID
        END ELSE
            ENQ.DATA<-1> = YVAL1.LST:'*':YVAL2.LST:"*SAP.Total****":YTOT.VAL3:"*"
            YTOT.VAL3 = 0
            ENQ.DATA<-1> = RECD.ID
        END
        YVAL2.LST = YVAL2
        YVAL1.LST = YVAL1
    REPEAT
RETURN
END
