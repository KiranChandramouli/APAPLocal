$PACKAGE APAP.REDOENQ
SUBROUTINE NOFILE.REDO.INS.PAYMENTS(FT.ARR)
*------------------------------------------------------------------------------------------
*DESCRIPTION : This is a no file enquiry routine for the enquiry NOFILE.REDO.INS.PAYMENTS
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : FT.ARR
* OUT    : FT.ARR
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : HARISH.Y
* PROGRAM NAME : NOFILE.REDO.INS.PAYMENTS
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
* 24.06.2010      HARISH.Y      ODR-2009-10-0340     INITIAL CREATION
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM 
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* -----------------------------------------------------------------------------------------
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.T.AUTH.ARRANGEMENT


    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.CUSTOMER                = 'F.CUSTOMER'
    F.CUSTOMER                 = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    FN.FUNDS.TRANSFER          = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER           = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    FN.REDO.T.AUTH.ARRANGEMENT = 'F.REDO.T.AUTH.ARRANGEMENT'
    F.REDO.T.AUTH.ARRANGEMENT  = ''
    CALL OPF(FN.REDO.T.AUTH.ARRANGEMENT,F.REDO.T.AUTH.ARRANGEMENT)
    LREF.APPL                   = 'FUNDS.TRANSFER'
    LREF.FIELDS                 = 'INS.POLICY.TYPE':@VM:'INS.COMPANY':@VM:'CLOSE.BAL.DATE':@VM:'TOT.CHG.VALUE'
    LREF.POS                    = ''

    CALL MULTI.GET.LOC.REF(LREF.APPL,LREF.FIELDS,LREF.POS)
    INS.POLICY.TYPE.POS   = LREF.POS<1,1>
    INS.COMP.POS          = LREF.POS<1,2>
    CLOSE.BAL.POS         = LREF.POS<1,3>
    TOT.CHG.VAL.POS       = LREF.POS<1,4>

RETURN
*------------
PROCESS:
*------------

    LOCATE "FUNDS.TRANSFER.ID" IN D.FIELDS<1> SETTING FT.ID.POS THEN
        FT.ID              = D.RANGE.AND.VALUE<FT.ID.POS>
    END
    LOCATE "INS.POLICY" IN D.FIELDS<1> SETTING INS.POL.POS THEN
        INS.POL.ID              = D.RANGE.AND.VALUE<INS.POL.POS>
    END
    LOCATE "INS.COMP" IN D.FIELDS<1> SETTING COMP.POS THEN
        INS.COMP.ID  = D.RANGE.AND.VALUE<COMP.POS>
    END

    CALL F.READ(FN.FUNDS.TRANSFER,FT.ID,R.FT,F.FUNDS.TRANSFER,FT.ERR)
    IF R.FT THEN
        INS.POLICY = R.FT<FT.LOCAL.REF><1,INS.POLICY.TYPE.POS>
        INS.COMP  = R.FT<FT.LOCAL.REF><1,INS.COMP.POS>
        CLOSE.BAL.DATE = R.FT<FT.LOCAL.REF><1,CLOSE.BAL.POS>
        TOT.CHG.VAL = R.FT<FT.LOCAL.REF><1,TOT.CHG.VAL.POS>
        CHARGE.AMT = R.FT<FT.CHARGE.AMT>
        CREDIT.CURR = R.FT<FT.CREDIT.CURRENCY>
        CREDIT.VAL.DATE = R.FT<FT.CREDIT.VALUE.DATE>
        CREDIT.ACCT.NO = R.FT<FT.CREDIT.ACCT.NO>
        CREDIT.AMNT.NO = R.FT<FT.CREDIT.AMOUNT>
    END
    SEL.CMD = "SELECT ":FN.REDO.T.AUTH.ARRANGEMENT:" WITH INS.POLICY.TYPE EQ ":INS.POLICY:" AND INS.COMPANY EQ ":INS.COMP
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
    CNT = 1
    LOOP
    WHILE CNT LE NOR
        ARRANGEMENT.ID = SEL.LIST<CNT>
        CALL F.READ(FN.REDO.T.AUTH.ARRANGEMENT,ARRANGEMENT.ID,R.AUTH,F.REDO.T.AUTH.ARRANGEMENT,ARR.ERR)
        IF R.AUTH THEN
            INS.AMT = R.AUTH<REDO.ARR.INS.AMOUNT>
        END

        GOSUB GET.AA.SCHEDULE
*        FT.ARR<-1> = INS.POLICY:"*":INS.COMP:"*":CLOSE.BAL.DATE:"*":FT.CHG.AMT:"*":CREDIT.CURR:"*":CREDIT.VAL.DATE:"*":CREDIT.ACCT.NO:"*":CREDIT.AMNT.NO:"*":ARR.ID:"*":TOT.CHG.PAYM:"*":INS.AMT
        FT.ARR<-1> = INS.POLICY:"*":INS.COMP:"*":CREDIT.CURR:"*":CREDIT.VAL.DATE:"*":CREDIT.AMNT.NO:"*":CREDIT.ACCT.NO:"*":CHARGE.AMT:"*":CLOSE.BAL.DATE:"*":ARRANGEMENT.ID:"*":TOT.CHG.PAYM:"*":INS.AMT
        CNT +=1
    REPEAT
RETURN

*-----------------------------------------------------------------------------
GET.AA.SCHEDULE:
*-----------------------------------------------------------------------------

    FLAG = 0;
    ENQ.SELECTION<2,1> = 'ARRANGEMENT.ID'
    ENQ.SELECTION<3,1> = 'EQ'
    ENQ.SELECTION<4,1> = ARRANGEMENT.ID
    SCHED.ARR = ''
    Y.TOT.INT.PAYMENT = ''
    CALL E.AA.SCHEDULE.PROJECTOR(SCHED.ARR)

    LOOP
    REMOVE Y.SCHED.ID FROM SCHED.ARR SETTING Y.SCH.POS UNTIL Y.SCHED.ID = ''
        Y.SCHD.DATE = FIELD(Y.SCHED.ID,"^",1)
        Y.SCHD.CHRG = FIELD(Y.SCHED.ID,"^",6)
        IF Y.SCHD.DATE LT CLOSE.BAL.DATE AND FLAG EQ 0 THEN
            GOSUB GET.CHARGE
        END
    REPEAT
RETURN
*--------------------------------------------------------------------------------
GET.CHARGE:
*--------------------------------------------------------------------------------

    IF Y.SCHD.DATE GE CREDIT.VAL.DATE THEN
        TOT.CHG.PAYM = Y.SCHD.CHRG
        FLAG = 1
    END

RETURN
END
