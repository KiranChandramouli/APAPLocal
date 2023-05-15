* @ValidationCode : MjotMTQ2NjI0NjA0MDpDcDEyNTI6MTY4NDEyOTE4NDEwMDpJVFNTOi0xOi0xOjI1NjE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 May 2023 11:09:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2561
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.PART.PYMT.AUT1
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH
* PROGRAM NAME : REDO.S.PART.PYMT.AUT
*----------------------------------------------------------


* DESCRIPTION : This routine is a validation routine attached
* to ACCOUNT.2 of TELLER,AA.PART.PYMNT & CREDIT.ACCOUNT.NO of FUNDS.TRANSFER,AA.PART.PYMT
* model bank version to do overpayment validations
*------------------------------------------------------------

*    LINKED WITH : TELLER & CREDIT.ACCOUNT.NO AS VALIDATION ROUTINE
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*31.05.2010      GANESH            ODR-2010-08-0017       INITIAL CREATION
*----------------------------------------------------------------------
*Modification history
*Date                Who               Reference                  Description
*11-04-2023      conversion tool     R22 Auto code conversion     VM TO @VM, FM TO @FM
*11-04-2023      Mohanraj R          R22 Manual code conversion   Add call routine prefix
*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.H.TT.CONCAT.FILE
    $INSERT I_F.REDO.H.FT.CONCAT.FILE
    $INSERT I_F.REDO.H.PART.PAY.TT
    $INSERT I_F.REDO.H.PART.PAY.FT
    $INSERT I_F.REDO.H.PART.PAY
    
    $USING APAP.TAM

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*-------------------------------------------------------------
INIT:
*Initialising
*-------------------------------------------------------------
    LOC.REF.APPLICATION='AA.PRD.DES.TERM.AMOUNT':@FM:'TELLER':@FM:'FUNDS.TRANSFER'
    LOC.REF.FIELDS='L.AA.PART.ALLOW':@VM:'L.AA.PART.PCNT':@FM:'L.TT.PART.PCNT':@VM:'L.TT.NUM.PYMT':@VM:'L.TT.BIL.NUM':@VM:'L.TT.TAX.TYPE':@FM:'L.FT.PART.PCNT':@VM:'L.FT.NUM.PYMT':@VM:'L.FT.BILL.NUM':@VM:'L.FT.TAX.TYPE'
    LOC.REF.POS=''
    EFF.DATE=TODAY
    PROP.CLASS='TERM.AMOUNT'
    PROPERTY=''
    R.Condition=''
    ERR.MSG=''
RETURN

*-------------------------------------------------------------
OPENFILES:
*Opening File

    FN.REDO.H.PART.PAY.FT = 'F.REDO.H.PART.PAY.FT'
    F.REDO.H.PART.PAY.FT = ''
    CALL OPF(FN.REDO.H.PART.PAY.FT,F.REDO.H.PART.PAY.FT)

    FN.REDO.H.PART.PAY.TT = 'F.REDO.H.PART.PAY.TT'
    F.REDO.H.PART.PAY.TT = ''
    CALL OPF(FN.REDO.H.PART.PAY.FT,F.REDO.H.PART.PAY.TT)

    FN.REDO.H.TT.CONCAT.FILE = 'F.REDO.H.TT.CONCAT.FILE'
    F.REDO.H.TT.CONCAT.FILE = ''
    CALL OPF(FN.REDO.H.TT.CONCAT.FILE,F.REDO.H.TT.CONCAT.FILE)

    FN.REDO.H.FT.CONCAT.FILE = 'F.REDO.H.FT.CONCAT.FILE'
    F.REDO.H.FT.CONCAT.FILE = ''
    CALL OPF(FN.REDO.H.FT.CONCAT.FILE,F.REDO.H.FT.CONCAT.FILE)

    FN.REDO.H.PART.PAY = 'F.REDO.H.PART.PAY'
    F.REDO.H.PART.PAY = '' ;R.REDO.H.PART.PAY = ''
    CALL OPF(FN.REDO.H.PART.PAY,F.REDO.H.PART.PAY)


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*-------------------------------------------------------------
PROCESS:
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    VAR.LOC.ALLOW.POS = LOC.REF.POS<1,1>
    VAR.LOC.PCNT.POS = LOC.REF.POS<1,2>
    VAR.TT.PART.PCNT = LOC.REF.POS<2,1>
    VAR.TT.NUM.PYMT = LOC.REF.POS<2,2>
    VAR.TT.BILL.NUM = LOC.REF.POS<2,3>
    VAR.TT.TAX.TYPE = LOC.REF.POS<2,4>
    VAR.FT.PART.PCNT = LOC.REF.POS<3,1>
    VAR.FT.NUM.PYMT = LOC.REF.POS<3,2>
    VAR.FT.BILL.NUM = LOC.REF.POS<3,3>
    VAR.FT.TAX.TYPE = LOC.REF.POS<3,4>
    VAR.TXN.ID = ID.NEW


    IF APPLICATION EQ 'TELLER' THEN
        GOSUB TT.PROCESS
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN

        GOSUB FT.PROCESS
    END
RETURN

*--------------
TT.PROCESS:

*Teller Process for checking the bills

    ACCT.ID = R.NEW(TT.TE.ACCOUNT.2)
    VAR.REC.STATUS = R.NEW(TT.TE.RECORD.STATUS)
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    VAR.ACCT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
*CALL REDO.CRR.GET.CONDITIONS(VAR.ACCT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    CALL APAP.TAM.redoCrrGetConditions(VAR.ACCT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG);* R22 Manual conversion
    VAL.PART.ALLOW = R.Condition<AA.AMT.LOCAL.REF><1,VAR.LOC.ALLOW.POS>
    VAL.PART.PCNT = R.Condition<AA.AMT.LOCAL.REF><1,VAR.LOC.PCNT.POS>
    VAR.TT.UPDT.ID = VAR.ACCT.ID:'.':VAR.TXN.ID
    IF VAR.REC.STATUS EQ 'RNAU' THEN
        CALL F.READ(FN.REDO.H.TT.CONCAT.FILE,VAR.TT.UPDT.ID,R.REDO.H.TT.CONCAT.FILE,F.REDO.H.TT.CONCAT.FILE,CONCAT.ERR)
        R.REDO.H.TT.CONCAT.FILE<TT.CON.NO.OF.PAYMENTS> = R.REDO.H.TT.CONCAT.FILE<TT.CON.NO.OF.PAYMENTS> - 1
        VAR.NO.OF.PAYMENTS = R.REDO.H.TT.CONCAT.FILE<TT.CON.NO.OF.PAYMENTS>
        CALL F.WRITE(FN.REDO.H.TT.CONCAT.FILE,VAR.ACCT.ID,R.REDO.H.TT.CONCAT.FILE)
        VAR.TT.UPDT.ID = VAR.ACCT.ID:'.':VAR.TXN.ID
        CALL F.DELETE(FN.REDO.H.PART.PAY.TT,VAR.TT.UPDT.ID)
    END
    ELSE
        CALL F.READ(FN.REDO.H.FT.CONCAT.FILE,VAR.ACCT.ID,R.REDO.H.FT.CONCAT.FILE,F.REDO.H.FT.CONCAT.FILE,CONCAT.FT.ERR)
        CALL F.READ(FN.REDO.H.TT.CONCAT.FILE,VAR.ACCT.ID,R.REDO.H.TT.CONCAT.FILE,F.REDO.H.TT.CONCAT.FILE,CONCAT.TT.ERR)
        IF R.REDO.H.TT.CONCAT.FILE EQ '' THEN
            R.REDO.H.TT.CONCAT.FILE<TT.CON.NO.OF.PAYMENTS> = 1
        END
        ELSE
            VAR.NO.OF.PAYMENTS = R.REDO.H.TT.CONCAT.FILE<TT.CON.NO.OF.PAYMENTS> + 1
            R.REDO.H.TT.CONCAT.FILE<TT.CON.NO.OF.PAYMENTS> = VAR.NO.OF.PAYMENTS
        END
        CALL F.WRITE(FN.REDO.H.TT.CONCAT.FILE,VAR.ACCT.ID,R.REDO.H.TT.CONCAT.FILE)
        VAR.TT.UPDT.ID = VAR.ACCT.ID:'.':VAR.TXN.ID
        CALL F.READ(FN.REDO.H.PART.PAY.TT,VAR.TT.UPDT.ID,R.REDO.H.PART.PAY.TT,F.REDO.H.PART.PAY.TT,TT.PART.ERR)

        VAR.BILL.NUM = R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.BILL.NUM>
        VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
        VAR.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
        VAR.VALUE.DATE = R.NEW(TT.TE.VALUE.DATE.2)

        R.REDO.H.PART.PAY.TT<PART.PAY.NUMBER.OF.PYMTS> = VAR.NO.OF.PAYMENTS
        R.REDO.H.PART.PAY.TT<PART.PAY.ARRANGEMENT.ID> = VAR.ACCT.ID
        R.REDO.H.PART.PAY.TT<PART.PAY.BILL.NUMBER> =  VAR.BILL.NUM
        R.REDO.H.PART.PAY.TT<PART.PAY.PARTL.PYMT.PCNT> = VAL.PART.PCNT
        R.REDO.H.PART.PAY.TT<PART.PAY.AMOUNT> = VAR.AMOUNT
        R.REDO.H.PART.PAY.TT<PART.PAY.CURRENCY> =  VAR.CURRENCY
        R.REDO.H.PART.PAY.TT<PART.PAY.VALUE.DATE> = VAR.VALUE.DATE
        CALL F.WRITE(FN.REDO.H.PART.PAY.TT,VAR.ACCT.ID,R.REDO.H.PART.PAY.TT)



        R.REDO.H.PART.PAY<PART.PAY.NUMBER.OF.PYMTS> = R.REDO.H.TT.CONCAT.FILE<TT.CON.NO.OF.PAYMENTS> +  R.REDO.H.FT.CONCAT.FILE<FT.CON.NO.OF.PAYMENTS>
        R.REDO.H.PART.PAY<PART.PAY.ARRANGEMENT.ID> = VAR.ACCT.ID
        R.REDO.H.PART.PAY<PART.PAY.BILL.NUMBER> =  VAR.BILL.NUM
        R.REDO.H.PART.PAY<PART.PAY.PARTL.PYMT.PCNT> = VAL.PART.PCNT
        R.REDO.H.PART.PAY<PART.PAY.AMOUNT> = VAR.AMOUNT
        R.REDO.H.PART.PAY<PART.PAY.CURRENCY> =  VAR.CURRENCY
        R.REDO.H.PART.PAY<PART.PAY.VALUE.DATE> = VAR.VALUE.DATE
        CALL F.WRITE(FN.REDO.H.PART.PAY,VAR.ACCT.ID,R.REDO.H.PART.PAY)


    END
RETURN

*-------------
FT.PROCESS:

*FT process for Checking the bills
    VAR.REC.STATUS = R.NEW(FT.RECORD.STATUS)
    ACCT.ID = R.NEW(FT.CREDIT.ACCT.NO)
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    VAR.ACCT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
*CALL REDO.CRR.GET.CONDITIONS(VAR.ACCT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    CALL APAP.TAM.redoCrrGetConditions(VAR.ACCT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG);* R22 Manual conversion
    VAL.PART.ALLOW = R.Condition<AA.AMT.LOCAL.REF><1,VAR.LOC.ALLOW.POS>
    VAL.PART.PCNT = R.Condition<AA.AMT.LOCAL.REF><1,VAR.LOC.PCNT.POS>
    VAR.FT.UPDT.ID = VAR.ACCT.ID:'.':VAR.TXN.ID
    IF VAR.REC.STATUS EQ 'RNAU' THEN
        CALL F.READ(FN.REDO.H.FT.CONCAT.FILE,VAR.ACCT.ID,R.REDO.H.FT.CONCAT.FILE,F.REDO.H.FT.CONCAT.FILE,CONCAT.ERR)
        R.REDO.H.FT.CONCAT.FILE<FT.CON.NO.OF.PAYMENTS> = R.REDO.H.FT.CONCAT.FILE<FT.CON.NO.OF.PAYMENTS> - 1
        VAR.NO.OF.PAYMENTS = R.REDO.H.FT.CONCAT.FILE<FT.CON.NO.OF.PAYMENTS>
        CALL F.WRITE(FN.REDO.H.FT.CONCAT.FILE,VAR.ACCT.ID,R.REDO.H.FT.CONCAT.FILE)
        CALL F.DELETE(FN.REDO.H.PART.PAY.FT,VAR.FT.UPDT.ID)
    END
    ELSE

        CALL F.READ(FN.REDO.H.TT.CONCAT.FILE,VAR.ACCT.ID,R.REDO.H.TT.CONCAT.FILE,F.REDO.H.TT.CONCAT.FILE,CONCAT.FT.ERR)
        CALL F.READ(FN.REDO.H.FT.CONCAT.FILE,VAR.ACCT.ID,R.REDO.H.FT.CONCAT.FILE,F.REDO.H.FT.CONCAT.FILE,CONCAT.TT.ERR)
        IF R.REDO.H.FT.CONCAT.FILE EQ '' THEN
            R.REDO.H.FT.CONCAT.FILE<FT.CON.NO.OF.PAYMENTS> = 1
            VAR.NO.OF.PAYMENTS = R.REDO.H.FT.CONCAT.FILE<FT.CON.NO.OF.PAYMENTS>
        END
        ELSE
            VAR.NO.OF.PAYMENTS = R.REDO.H.FT.CONCAT.FILE<FT.CON.NO.OF.PAYMENTS> + 1
            R.REDO.H.FT.CONCAT.FILE<FT.CON.NO.OF.PAYMENTS> = VAR.NO.OF.PAYMENTS
        END
        CALL F.WRITE(FN.REDO.H.FT.CONCAT.FILE,VAR.ACCT.ID,R.REDO.H.FT.CONCAT.FILE)
        CALL F.READ(FN.REDO.H.PART.PAY.FT,VAR.FT.UPDT.ID,R.REDO.H.PART.PAY.FT,F.REDO.H.PART.PAY.FT,FT.PART.ERR)

        VAR.BILL.NUM = R.NEW(FT.LOCAL.REF)<1,VAR.FT.BILL.NUM>
        VAR.AMOUNT = R.NEW(FT.CREDIT.AMOUNT)
        VAR.CURRENCY = R.NEW(FT.CREDIT.CURRENCY)
        VAR.VALUE.DATE = R.NEW(FT.CREDIT.VALUE.DATE)

        R.REDO.H.PART.PAY.FT<PART.PAY.ARRANGEMENT.ID> = VAR.ACCT.ID
        R.REDO.H.PART.PAY.FT<PART.PAY.BILL.NUMBER> = VAR.BILL.NUM
        R.REDO.H.PART.PAY.FT<PART.PAY.PARTL.PYMT.PCNT> = VAL.PART.PCNT
        R.REDO.H.PART.PAY.FT<PART.PAY.NUMBER.OF.PYMTS> = VAR.NO.OF.PAYMENTS
        R.REDO.H.PART.PAY.FT<PART.PAY.AMOUNT> = VAR.AMOUNT
        R.REDO.H.PART.PAY.FT<PART.PAY.CURRENCY> = VAR.CURRENCY
        R.REDO.H.PART.PAY.FT<PART.PAY.VALUE.DATE> = VAR.VALUE.DATE
        CALL F.WRITE(FN.REDO.H.PART.PAY.FT,VAR.FT.UPDT.ID,R.REDO.H.PART.PAY.FT)


        R.REDO.H.PART.PAY<PART.PAY.ARRANGEMENT.ID> = VAR.ACCT.ID
        R.REDO.H.PART.PAY<PART.PAY.BILL.NUMBER> = VAR.BILL.NUM
        R.REDO.H.PART.PAY<PART.PAY.PARTL.PYMT.PCNT> = VAL.PART.PCNT
        R.REDO.H.PART.PAY<PART.PAY.NUMBER.OF.PYMTS> = R.REDO.H.TT.CONCAT.FILE<TT.CON.NO.OF.PAYMENTS> +  R.REDO.H.FT.CONCAT.FILE<FT.CON.NO.OF.PAYMENTS>
        R.REDO.H.PART.PAY<PART.PAY.AMOUNT> = VAR.AMOUNT
        R.REDO.H.PART.PAY<PART.PAY.CURRENCY> = VAR.CURRENCY
        R.REDO.H.PART.PAY<PART.PAY.VALUE.DATE> = VAR.VALUE.DATE
        CALL F.WRITE(FN.REDO.H.PART.PAY,VAR.ACCT.ID,R.REDO.H.PART.PAY)

    END
RETURN
END
