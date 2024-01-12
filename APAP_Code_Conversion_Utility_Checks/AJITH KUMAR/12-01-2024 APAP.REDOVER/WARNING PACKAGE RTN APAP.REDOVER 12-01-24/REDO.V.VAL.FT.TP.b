* @ValidationCode : MjoxNDkxMjQxOTExOkNwMTI1MjoxNjgyNjkxNTIxNjU4OklUU1M6LTE6LTE6MTQ0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Apr 2023 19:48:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 144
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.FT.TP
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
*   Date               who              Reference            Description
* 12-Oct-2010        Naveenkumar        ODR2009100480        Initial Creation
* 26-Oct-2010        Chandra Prakash T  ODR-2009-09-0080     Modification - C.19 Interface
*26 JUL 2011         Prabhu              ARC issue           C22 added
*------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,F.READ TO CACHE.READ,IF CONDITION ADDED
*17-04-2023              Samaran T                R22 Manual Code conversion                         CALL ROUTINE FORMAT MODIFIED
*----------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.EB.ERROR
    $INSERT I_F.REDO.THIRDPRTY.PARAMETER
    $INSERT I_F.REDO.TRANS.CODE.PARAM
    $INSERT I_System
    $INSERT JBC.h
    $USING APAP.REDOCHNLS


    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*---*
INIT:
*---*
    LOC.REF.APPLICATION = APPLICATION
    LOC.REF.FIELDS      = 'L.FT.CMPNY.ID':@VM:'L.FT.MSD'
    LOC.REF.POS         = ''
    Y.INTERFACE.REQ     = ""
RETURN
*---------*
OPEN.FILES:
*---------*
    FN.RTP              = 'F.REDO.THIRDPRTY.PARAMETER'
    F.RTP               = ''
    CALL OPF(FN.RTP,F.RTP)
    FN.REDO.TRANS.CODE.PARAM  = "F.REDO.TRANS.CODE.PARAM"
    FN.EB.ERROR='F.EB.ERROR'
    F.EB.ERROR=''
    CALL OPF(FN.EB.ERROR,F.EB.ERROR)
RETURN
*--------*
PROCESS:
*--------*

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    Y.FT.CMPNY.ID.POS   = LOC.REF.POS<1,1>
    Y.FT.MSD.POS        = LOC.REF.POS<1,2>
    R.REDO.TRANS.CODE.PARAM = ''
    REDO.TRANS.CODE.PARAM.ERR = ''
*    CALL CACHE.READ(FN.REDO.TRANS.CODE.PARAM,"SYSTEM",R.REDO.TRANS.CODE.PARAM,REDO.TRANS.CODE.PARAM.ERR)
IDVAR.1 = "SYSTEM" ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.TRANS.CODE.PARAM,IDVAR.1,R.REDO.TRANS.CODE.PARAM,REDO.TRANS.CODE.PARAM.ERR);* R22 UTILITY AUTO CONVERSION
    ACTIVATION.KEY = R.REDO.TRANS.CODE.PARAM<REDO.TS.ACTIVATION.KEY>
    Y.DELIMITER    = R.REDO.TRANS.CODE.PARAM<REDO.TS.DELIMITER>

    Y.ID            = R.NEW(FT.LOCAL.REF)<1,Y.FT.CMPNY.ID.POS>
    CALL CACHE.READ(FN.RTP,Y.ID,R.RTP,REDO.ERR)
    Y.COMP.ID       = R.RTP<REDO.TP.COMP.NAME>
    Y.INTERFACE.REQ = R.RTP<REDO.TP.INTERFACE.REQ>
    Y.METHOD.LIST   = R.RTP<REDO.TP.METHOD.DESC>
    Y.METHOD.NAMES  = R.RTP<REDO.TP.METHOD.NAME>
    Y.FT.BILL.NUM.VALUE=System.getVariable('CURRENT.CONTRACT.NO')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN    ;*R22 AUTO CODE CONVERSION.START
        Y.FT.BILL.NUM.VALUE = ""    ;*R22 AUTO CODE CONVERSION
    END    ;*R22 AUTO CODE CONVERSION.END
    CHANGE @VM TO @FM IN Y.METHOD.LIST
    CHANGE @VM TO @FM IN Y.METHOD.NAMES
    IF Y.INTERFACE.REQ EQ "Y" THEN
        LOCATE "getBalanceByNumber" IN Y.METHOD.LIST SETTING METHOD.POS THEN
            GOSUB PROCESS.EXEC
        END
    END
RETURN
*------------
PROCESS.EXEC:
*------------

    Y.METHOD=Y.METHOD.NAMES<METHOD.POS>
    BEGIN CASE
*--------------------------------------------------------------------------------------------------
*This case is to get the due from the orange company
*--------------------------------------------------------------------------------------------------
        CASE Y.METHOD EQ "getBalanceByNumber"
            EJB_ARGUMENT             = Y.METHOD:Y.DELIMITER:Y.FT.BILL.NUM.VALUE
            Y.RESPONSE               = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            GOSUB HANDLE.PROCESS
*----------------------------------------------------------------------------------------------------
*This case is to get the due from CODETEL company
*----------------------------------------------------------------------------------------------------

        CASE Y.METHOD EQ  "ENQUIRY_CLIENT_POST_PAYMENT"

            Y.STATUS              = R.RTP<REDO.TP.PHONE.STATUS>
            Y.INTERFACE.USER.NAME = R.RTP<REDO.TP.INTERFACE.USER>
            Y.INTERFACE.PASS      = R.RTP<REDO.TP.INTERFACE.PASS>
            EJB_ARGUMENT=Y.METHOD:Y.DELIMITER:Y.STATUS:Y.DELIMITER:Y.FT.BILL.NUM.VALUE:Y.DELIMITER:Y.INTERFACE.USER.NAME:Y.DELIMITER:Y.INTERFACE.PASS
            Y.RESPONSE  = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)

            CHANGE Y.DELIMITER TO @FM IN EJB_ARGUMENT
            IF EJB_ARGUMENT<1> EQ 'SUCCESS' THEN
                R.NEW(FT.LOCAL.REF)<1,Y.FT.MSD.POS>=EJB_ARGUMENT<3>
            END

*---------------------------------------------------------------------------------------------------
*This is to get the due from generic interface
*--------------------------------------------------------------------------------------------------
        CASE Y.METHOD EQ "GetBalance"

            EJB_ARGUMENT=Y.METHOD:Y.DELIMITER:Y.COMP.ID:Y.DELIMITER:Y.FT.BILL.NUM.VALUE
            Y.RESPONSE         = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            GOSUB HANDLE.PROCESS
    END CASE
RETURN
*--------------
HANDLE.PROCESS:
*--------------
    CHANGE Y.DELIMITER TO @FM IN EJB_ARGUMENT
    IF EJB_ARGUMENT<1> EQ 'SUCCESS' THEN
        R.NEW(FT.CREDIT.AMOUNT)=EJB_ARGUMENT<3>
    END
    ELSE
        GOSUB HANDLE.FAIL
    END
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
                CALL CACHE.READ(FN.EB.ERROR, "EB-TP.CON.FAIL.CODE", R.EB.ERROR, ERR)      ;*R22 AUTO CODE CONVERSION
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
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)  ;*R22 MANUAL CODE CONVERSION
            ETEXT = "EB-TP.CONNECT.FAIL"
            CALL STORE.END.ERROR
        END
    END
RETURN
END
