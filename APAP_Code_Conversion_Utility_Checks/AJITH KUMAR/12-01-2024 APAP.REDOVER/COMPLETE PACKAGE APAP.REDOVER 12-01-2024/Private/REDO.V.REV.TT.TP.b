* @ValidationCode : MjotMTM5MjUxNTk0NDpDcDEyNTI6MTcwNDQ0NDk3Mzc2Mjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2024 14:26:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.REV.TT.TP
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is a input routine which check calls the funtion JEE
*
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
* 12-Oct-2010        Prabhu N    ODR-2009-09-0080       Initial Creation
*------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,F.READ TO CACHE.READ
*12-04-2023              Samaran T                R22 Manual Code conversion                         Call Routine Format Modified
*----------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON
    $INSERT I_F.EB.ERROR
    $INSERT I_F.REDO.THIRDPRTY.PARAMETER
    $INSERT I_F.REDO.TRANS.CODE.PARAM
    $INSERT JBC.h
    $USING APAP.REDOCHNLS

*    IF V$FUNCTION NE 'R' OR R.NEW(TT.TE.RECORD.STATUS) NE 'RNAU' THEN
    Y.TT.REV.STATUS=R.NEW(TT.TE.RECORD.STATUS)
    Y.TT.REV.STATUS=Y.TT.REV.STATUS[1,2]

    IF (V$FUNCTION EQ 'R' OR  (V$FUNCTION EQ 'A' AND Y.TT.REV.STATUS EQ 'RN')) AND OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB INIT
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END ELSE
        RETURN
    END

RETURN

*---*
INIT:
*---*
    LOC.REF.APPLICATION = 'TELLER'
    LOC.REF.FIELDS      = 'L.TT.BILL.NUM':@VM:'L.TT.CMPNY.ID':@VM:'L.TT.MSD':@VM:'L.TT.MET.OF.PAY':@VM:'L.SUNL.SQ.NO'
    LOC.REF.POS         = ''
    Y.INTERFACE.REQ     = ""
RETURN
*---------*
OPEN.FILES:
*---------*
    FN.RTP              = 'F.REDO.THIRDPRTY.PARAMETER'
    FN.REDO.TRANS.CODE.PARAM  = "F.REDO.TRANS.CODE.PARAM"
    FN.EB.ERROR='F.EB.ERROR'
    F.EB.ERROR =''
    CALL OPF(FN.EB.ERROR,F.EB.ERROR)
RETURN
*--------*
PROCESS:
*--------*
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    Y.TT.BILL.NUM.POS   = LOC.REF.POS<1,1>
    Y.TT.CMPNY.ID.POS   = LOC.REF.POS<1,2>
    VAR.TT.MSD.POS      =LOC.REF.POS<1,3>
    VAR.L.TT.MET.OF.PAY=LOC.REF.POS<1,4>
    Y.AUTH.POS         =LOC.REF.POS<1,5>
    Y.ID                = R.NEW(TT.TE.LOCAL.REF)<1,Y.TT.CMPNY.ID.POS>
    CALL CACHE.READ(FN.RTP,Y.ID,R.RTP,REDO.ERR)
*    CALL CACHE.READ(FN.REDO.TRANS.CODE.PARAM,"SYSTEM",R.REDO.TRANS.CODE.PARAM,REDO.TRANS.CODE.PARAM.ERR)
    IDVAR.1 = "SYSTEM" ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.TRANS.CODE.PARAM,IDVAR.1,R.REDO.TRANS.CODE.PARAM,REDO.TRANS.CODE.PARAM.ERR);* R22 UTILITY AUTO CONVERSION
    ACTIVATION.KEY = R.REDO.TRANS.CODE.PARAM<REDO.TS.ACTIVATION.KEY>
    Y.DELIMITER    = R.REDO.TRANS.CODE.PARAM<REDO.TS.DELIMITER>
    Y.INTERFACE.REQ       = R.RTP<REDO.TP.INTERFACE.REQ>
    Y.METHOD.LIST         = R.RTP<REDO.TP.METHOD.DESC>
    Y.METHOD.NAMES        = R.RTP<REDO.TP.METHOD.NAME>
    Y.TT.BILL.NUM.VALUE   = R.NEW(TT.TE.LOCAL.REF)<1,Y.TT.BILL.NUM.POS>
    Y.INTERFACE.USER.NAME = R.RTP<REDO.TP.INTERFACE.USER>
    Y.INTERFACE.PASS      = R.RTP<REDO.TP.INTERFACE.PASS>
    CHANGE @VM TO @FM IN Y.METHOD.LIST
    CHANGE @VM TO @FM IN Y.METHOD.NAMES
    IF Y.INTERFACE.REQ EQ "Y" THEN
        LOCATE "PaymentReverse" IN Y.METHOD.LIST SETTING METHOD.POS THEN
            GOSUB EXEC.PROCESS
        END
    END
RETURN
*-------------
EXEC.PROCESS:
*-------------
    Y.METHOD=Y.METHOD.NAMES<METHOD.POS>
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT' THEN
        Y.TT.PAY.AMOUNT=R.NEW(TT.TE.AMOUNT.LOCAL.1)
    END
    ELSE
        Y.TT.PAY.AMOUNT=R.NEW(TT.TE.AMOUNT.LOCAL.2)
    END
    Y.METHOD.PAY= R.NEW(TT.TE.LOCAL.REF)<1,VAR.L.TT.MET.OF.PAY>
    Y.MODE.LIST =R.RTP<REDO.TP.PAY.MODE>
    LOCATE Y.METHOD.PAY IN Y.MODE.LIST SETTING MODE.POS THEN
        Y.METHOD.PAY=R.RTP<REDO.TP.PAY.CODE,MODE.POS>
    END
    BEGIN CASE
        CASE Y.METHOD EQ "INVOICES_PAYMENT_REVERSE"
*------------------------------
*Reverse Codetel payemnt part
*------------------------------
            Y.MSD                 = R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.MSD.POS>
            Y.MEANS.CODE=R.RTP<REDO.TP.CHANNEL.CODE>
            Y.INTERFACE.USER.NAME = R.RTP<REDO.TP.INTERFACE.USER>
            Y.INTERFACE.PASS      = R.RTP<REDO.TP.INTERFACE.PASS>
            Y.TXN.DATE            =R.NEW(TT.TE.DATE.TIME)
            Y.TXN.DATE            ='20':Y.TXN.DATE[1,6]
            Y.TXN.NO              =R.NEW(TT.TE.LOCAL.REF)<1,Y.AUTH.POS>
            EJB_ARGUMENT          = Y.METHOD:Y.DELIMITER:Y.TT.BILL.NUM.VALUE:Y.DELIMITER:Y.MSD:Y.DELIMITER:Y.TT.PAY.AMOUNT:Y.DELIMITER:Y.METHOD.PAY:Y.DELIMITER:Y.TXN.DATE:Y.DELIMITER:Y.TXN.NO:Y.DELIMITER:Y.MEANS.CODE:Y.DELIMITER:Y.INTERFACE.USER.NAME:Y.DELIMITER:Y.INTERFACE.PASS
            Y.RESPONSE            = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            IF EJB_ARGUMENT<1> NE 'SUCCESS' THEN
                GOSUB HANDLE.FAIL
            END
*-------------------
*reversal for future
*--------------------
        CASE Y.METHOD EQ "ReversePayment"
            Y.COMPANY.CODE     =R.RTP<REDO.TP.COMP.NAME>
            EJB_ARGUMENT       = Y.METHOD:Y.DELIMITER:Y.ID:Y.DELIMITER:Y.TT.BILL.NUM.VALUE:Y.DELIMITER:ID.NEW:Y.DELIMITER:Y.TT.PAY.AMOUNT
            Y.RESPONSE         = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            IF EJB_ARGUMENT<1> NE 'SUCCESS' THEN
                GOSUB HANDLE.FAIL
            END
    END CASE
RETURN
*------------
HANDLE.FAIL:
*------------
    IF EJB_ARGUMENT<1> EQ 'FAIL' THEN
        ETEXT="EB-INVALID.DATA"
        CALL STORE.END.ERROR
    END
    ELSE
        Y.RESPONSE.MSG = EJB_ARGUMENT[1,4]
        IF Y.RESPONSE.MSG EQ 'FAIL' OR Y.RESPONSE THEN
            Y.MESSAGE=EJB_ARGUMENT<1>
            IF Y.RESPONSE THEN
                CALL CACHE.READ(FN.EB.ERROR, "EB-TP.CON.FAIL.CODE", R.EB.ERROR, ERR)     ;*R22 AUTO CODE CONVERSION
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
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)   ;*R22 MANUAL CODE CONVERSION
            ETEXT = "EB-TP.CONNECT.FAIL"
            CALL STORE.END.ERROR
        END
    END
RETURN
END
