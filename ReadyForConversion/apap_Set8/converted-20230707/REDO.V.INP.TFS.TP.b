SUBROUTINE REDO.V.INP.TFS.TP
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine will update the local field depending upon the value of TRANSACTION.CODE. This routine
* T24.FUND.SERVICES,REDO.THIRDPRTY.PAYMENT

* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who              Reference            Description
* 20-Jan-2010        Prabhu N        ODR-2009-10-0318       Intial Draft
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.LOCKING
    $INSERT I_F.REDO.THIRDPRTY.PAYMENT
    $INSERT I_F.REDO.THIRDPRTY.PARAMETER
    $INSERT I_F.REDO.TRANS.CODE.PARAM
    $INSERT JBC.h

    IF R.NEW(TFS.RECORD.STATUS) NE "INAU" THEN
        RETURN
    END
    GOSUB INTERFACE.UPD
RETURN
*-------------
INTERFACE.UPD:
*-------------
    LOC.REF.FIELDS='L.TT.CMPNY.ID':@VM:'L.TT.CMPNY.NAME':@VM:'L.TT.BILL.TYPE':@VM:'L.TT.BILL.COND':@VM:'L.TT.BILL.NUM':@VM:'L.TT.MSD'
    LOC.REF.APPLICATION=APPLICATION
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    VAR.L.FT.CMPNY.ID=LOC.REF.POS<1,1>
    VAR.L.FT.CMPNY.NAME=LOC.REF.POS<1,2>
    VAR.L.FT.BILL.TYPE=LOC.REF.POS<1,3>
    VAR.L.FT.BILL.COND=LOC.REF.POS<1,4>
    VAR.L.FT.BILL.NUM=LOC.REF.POS<1,5>
    VAR.FT.MSD.POS     =LOC.REF.POS<1,8>
    FN.REDO.TRANS.CODE.PARAM="F.REDO.TRANS.CODE.PARAM"
    CALL CACHE.READ(FN.REDO.TRANS.CODE.PARAM,"SYSTEM",R.REDO.TRANS.CODE.PARAM,REDO.TRANS.CODE.PARAM.ERR)
    Y.ID                = R.NEW(TFS.LOCAL.REF)<1,VAR.L.FT.CMPNY.ID>
    FN.REDO.THIRD.PARAMETER = 'F.REDO.THIRD.PARAMETER'
    CALL CACHE.READ(FN.REDO.THIRD.PARAMETER,Y.ID,R.REDO.THIRD.PARAMETER,REC.ERR)
    Y.INTERFACE.REQ     = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.REQ>
    Y.METHOD.LIST       = R.REDO.THIRD.PARAMETER<REDO.TP.METHOD.DESC>
    Y.METHOD.NAMES      = R.REDO.THIRD.PARAMETER<REDO.TP.METHOD.NAME>
    CHANGE @VM TO @FM IN Y.METHOD.LIST
    CHANGE @VM TO @FM IN Y.METHOD.NAMES
    Y.FT.BILL.NUM.VALUE   = R.NEW(TFS.LOCAL.REF)<1,VAR.L.FT.BILL.NUM>
    Y.INTERFACE.USER.NAME = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.USER>
    Y.INTERFACE.PASS      = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.PASS>
    ACTIVATION.KEY = R.REDO.TRANS.CODE.PARAM<REDO.TS.ACTIVATION.KEY>
    Y.DELIMITER    = R.REDO.TRANS.CODE.PARAM<REDO.TS.DELIMITER>
    IF Y.INTERFACE.REQ EQ "Y" THEN
        LOCATE "ProcessPayment" IN Y.METHOD.LIST SETTING METHOD.POS THEN
            GOSUB EXEC.PROCESS
        END
    END
RETURN
*-------------
EXEC.PROCESS:
*-------------

    Y.METHOD           = Y.METHOD.NAMES<METHOD.POS>
    Y.FT.PAY.AMOUNT=R.NEW(TFS.AMOUNT.LCY)

*------------------------------------------------------------------------------------------
*performing update to third party interfaces
*------------------------------------------------------------------------------------------

    Y.MODE.LIST=R.REDO.THIRD.PARAMETER<REDO.TP.PAY.MODE>
    CHANGE @VM TO @FM IN Y.MODE.LIST
    LOCATE Y.METHOD.PAY IN Y.MODE.LIST SETTING MODE.POS THEN
        Y.METHOD.PAY=R.REDO.THIRD.PARAMETER<REDO.TP.PAY.CODE,MODE.POS>
    END
*--------------------------------------------------------------------------------------------------
*This case is to get the due from the orange company
*--------------------------------------------------------------------------------------------------
    BEGIN CASE
        CASE Y.METHOD EQ "processPaymentOrange"
            EJB_ARGUMENT       = Y.METHOD:Y.DELIMITER:Y.FT.BILL.NUM.VALUE:Y.DELIMITER:Y.FT.PAY.AMOUNT
            Y.RESPONSE         = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            CHANGE Y.DELIMITER TO @FM IN EJB_ARGUMENT
            IF EJB_ARGUMENT<1> NE 'SUCCESS' THEN
                GOSUB HANDLE.FAIL
            END
*----------------------------------------------------------------------------------------------------
*This case is to get the due from CODETEL company
*----------------------------------------------------------------------------------------------------

        CASE Y.METHOD EQ "PROCESS_INVOICE_PAYMENT"
            Y.MSD                 = R.NEW(TFS.LOCAL.REF)<1,VAR.FT.MSD.POS>
            Y.MEANS.CODE          = R.REDO.THIRD.PARAMETER<REDO.TP.CHANNEL.CODE>
            Y.INTERFACE.USER.NAME = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.USER>
            Y.INTERFACE.PASS      = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.PASS>
            EJB_ARGUMENT          = Y.METHOD:Y.DELIMITER:Y.FT.BILL.NUM.VALUE:Y.DELIMITER:Y.MSD:Y.DELIMITER:Y.FT.PAY.AMOUNT:Y.DELIMITER:ID.NEW:Y.DELIMITER:Y.METHOD.PAY:Y.DELIMITER:Y.MEANS.CODE:Y.DELIMITER:Y.INTERFACE.USER.NAME:Y.DELIMITER:Y.INTERFACE.PASS
            Y.RESPONSE            = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            CHANGE Y.DELIMITER TO @FM IN EJB_ARGUMENT
            IF EJB_ARGUMENT<1> NE 'SUCCESS' THEN
                GOSUB HANDLE.FAIL
            END
*----------------------------------------------------------------------------------------------------
*            This is to update the payment using generic interface for future companies
*----------------------------------------------------------------------------------------------------
        CASE Y.METHOD EQ "ProcessPayment"
            Y.COMPANY.CODE     =R.REDO.THIRD.PARAMETER<REDO.TP.COMP.NAME>
            EJB_ARGUMENT       =Y.METHOD:Y.DELIMITER:Y.COMPANY.CODE:Y.DELIMITER:Y.FT.BILL.NUM.VALUE:Y.DELIMITER:Y.METHOD.PAY:Y.DELIMITER:Y.FT.PAY.AMOUNT:Y.DELIMITER:ID.NEW
            Y.RESPONSE         = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            CHANGE Y.DELIMITER TO @FM IN EJB_ARGUMENT
            IF EJB_ARGUMENT<1> NE 'SUCCESS' THEN
                GOSUB HANDLE.FAIL
            END
    END CASE
RETURN
*-----------
HANDLE.FAIL:
*-----------
    IF EJB_ARGUMENT<1> EQ 'FAIL' THEN
        E=EJB_ARGUMENT<2>

    END
    ELSE
        GOSUB CONNECTION.FAIL
    END
RETURN
*---------------
CONNECTION.FAIL:
*---------------
    Y.RESPONSE.MSG =EJB_ARGUMENT[1,4]
    IF Y.RESPONSE.MSG EQ 'FAIL' THEN
        Y.MESSAGE  =EJB_ARGUMENT<1>
        Y.RESP.ERR =FIELDS(Y.MESSAGE,':',2)
        INT.CODE = 'TPI001'
        INT.TYPE = 'ONLINE'
        BAT.NO = ''
        BAT.TOT = ''
        INFO.OR = ''
        INFO.DE = ''
        ID.PROC = ID.NEW
        MON.TP = '03'
        DESC = Y.RESP.ERR
        REC.CON = ''
        EX.USER = ''
        EX.PC = ''
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        E = Y.RESP.ERR
    END
RETURN
END
