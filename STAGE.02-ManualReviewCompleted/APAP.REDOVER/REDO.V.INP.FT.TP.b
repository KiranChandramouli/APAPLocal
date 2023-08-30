* @ValidationCode : MjotOTY1MzkzNjIzOkNwMTI1MjoxNjgxMjg4MzYzNjc2OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 14:02:43
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.FT.TP
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine will update the local field depending upon the value of TRANSACTION.CODE. This routine
* TELLER,REDO.THIRDPRTY.PAYMENT

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
*   Date               who           Reference            Description
* 11-Jan-2010        Ganesh R        ODR2009100480       Initial Creation
* 26-oct-2010        Prabhu N        ODR-2009-09-0080    Modification done-INTERFACE.UPD added
*------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,F.READ TO CACHE.READ,IF CONDITION ADDED
*12-04-2023              Samaran T                R22 Manual Code conversion                        CALL ROUTINE FORMAT MODIFIED
*---------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.LOCKING
    $INSERT I_F.EB.ERROR
    $INSERT I_F.REDO.THIRDPRTY.PAYMENT
    $INSERT I_F.REDO.THIRDPRTY.PARAMETER
    $INSERT I_System
    $INSERT I_F.REDO.TRANS.CODE.PARAM
    $INSERT JBC.h

*    IF R.NEW(FT.RECORD.STATUS) NE "INAU" THEN
*        RETURN
*    END
    GOSUB INTERFACE.UPD
RETURN
*-------------
INTERFACE.UPD:
*-------------

    LOC.REF.FIELDS='L.FT.CMPNY.ID':@VM:'L.FT.CMPNY.NAME':@VM:'L.FT.BILL.TYPE':@VM:'L.FT.BILL.COND':@VM:'L.FT.BILL.NUM':@VM:'L.FT.MSD'
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
    Y.ID                = R.NEW(FT.LOCAL.REF)<1,VAR.L.FT.CMPNY.ID>
    FN.REDO.THIRD.PARAMETER = 'F.REDO.THIRDPRTY.PARAMETER'
    CALL CACHE.READ(FN.REDO.THIRD.PARAMETER,Y.ID,R.REDO.THIRD.PARAMETER,REC.ERR)
    FN.EB.ERROR='F.EB.ERROR'
    F.EB.ERROR=''
    CALL OPF(FN.EB.ERROR,F.EB.ERROR)
    Y.INTERFACE.REQ     = R.REDO.THIRD.PARAMETER<REDO.TP.INTERFACE.REQ>
    Y.METHOD.LIST       = R.REDO.THIRD.PARAMETER<REDO.TP.METHOD.DESC>
    Y.METHOD.NAMES      = R.REDO.THIRD.PARAMETER<REDO.TP.METHOD.NAME>
    CHANGE @VM TO @FM IN Y.METHOD.LIST
    CHANGE @VM TO @FM IN Y.METHOD.NAMES
*    Y.FT.BILL.NUM.VALUE   = R.NEW(FT.LOCAL.REF)<1,VAR.L.FT.BILL.NUM>
    Y.FT.BILL.NUM.VALUE   = System.getVariable('CURRENT.CONTRACT.NO')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION.START
        Y.FT.BILL.NUM.VALUE = ""    ;*R22 AUTO CODE CONVERSION
    END   ;*R22 AUTO CODE CONVERSION.END

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
    Y.FT.PAY.AMOUNT=R.NEW(FT.CREDIT.AMOUNT)

*------------------------------------------------------------------------------------------
*performing update to third party interfaces
*------------------------------------------------------------------------------------------

    Y.MODE.LIST=R.REDO.THIRD.PARAMETER<REDO.TP.PAY.MODE>
    CHANGE @VM TO @FM IN Y.MODE.LIST
    Y.METHOD.PAY='EFECTIVO'
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
            Y.MSD                 = R.NEW(FT.LOCAL.REF)<1,VAR.FT.MSD.POS>
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
    AF=FT.CREDIT.AMOUNT
    IF EJB_ARGUMENT<1> EQ 'FAIL' THEN
        ETEXT="EB-INVALID.DATA"
        CALL STORE.END.ERROR
    END
    ELSE
        GOSUB CONNECTION.FAIL
    END
RETURN
*---------------
CONNECTION.FAIL:
*---------------
    Y.RESPONSE.MSG =EJB_ARGUMENT[1,4]
    IF Y.RESPONSE.MSG EQ 'FAIL' OR Y.RESPONSE THEN
        Y.MESSAGE  =EJB_ARGUMENT<1>
        IF Y.RESPONSE THEN
            CALL CACHE.READ(FN.EB.ERROR, "EB-TP.CON.FAIL.CODE", R.EB.ERROR, ERR)  ;*R22 AUTO CODE CONVERSION
            Y.RESP.ERR=R.EB.ERROR<EB.ERR.ERROR.MSG>:' ':Y.RESPONSE
        END
        ELSE
            Y.RESP.ERR =FIELDS(Y.MESSAGE,':',2)
        END
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
        CALL APAP.REDOVER.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)  ;*R22 MANUAL CODE CONVERSION
        ETEXT = "EB-TP.CONNECT.FAIL"
        CALL STORE.END.ERROR
    END
RETURN
END
