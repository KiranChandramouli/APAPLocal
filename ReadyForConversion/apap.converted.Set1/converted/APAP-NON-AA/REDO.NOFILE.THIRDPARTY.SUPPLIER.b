SUBROUTINE REDO.NOFILE.THIRDPARTY.SUPPLIER(THIRD.PARTY.LIST)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name :
*-----------------------------------------------------------------------------
* Description    :  This Nofile routine will get required details of Customer Accts
* Linked with    :
* In Parameter   :
* Out Parameter  :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.REDO.THIRDPRTY.PARAMETER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.EB.ERROR
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER
    $INSERT I_F.REDO.ADD.THIRDPARTY
    $INSERT I_F.REDO.TRANS.CODE.PARAM
    $INSERT JBC.h

*---------*
MAIN.PARA:
*---------*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*----------*
INITIALISE:
*----------*
    FN.REDO.ADD.THIRDPARTY = 'F.REDO.ADD.THIRDPARTY'
    F.REDO.ADD.THIRDPARTY = ''
    FN.RTP              = 'F.REDO.THIRDPRTY.PARAMETER'
    F.RTP               = ''
    FN.REDO.TRANS.CODE.PARAM  = "F.REDO.TRANS.CODE.PARAM"
    FN.EB.ERROR='F.EB.ERROR'
    F.EB.ERROR=''
RETURN
*----------*
OPEN.FILES:
*----------*
    CALL OPF(FN.RTP,F.RTP)
    CALL OPF(FN.EB.ERROR,F.EB.ERROR)
    CALL OPF(FN.REDO.ADD.THIRDPARTY,F.REDO.ADD.THIRDPARTY)
RETURN
*--------*
PROCESS:
*--------*

    R.REDO.TRANS.CODE.PARAM = ''
    REDO.TRANS.CODE.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.TRANS.CODE.PARAM,"SYSTEM",R.REDO.TRANS.CODE.PARAM,REDO.TRANS.CODE.PARAM.ERR)
    ACTIVATION.KEY = R.REDO.TRANS.CODE.PARAM<REDO.TS.ACTIVATION.KEY>
    Y.DELIMITER    = R.REDO.TRANS.CODE.PARAM<REDO.TS.DELIMITER>

    CUST.ID = System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CUST.ID = ""
    END

    SEL.CMD.RCO = "SELECT ":FN.REDO.ADD.THIRDPARTY:" WITH OWN.CUSTOMER EQ " :CUST.ID
    CALL EB.READLIST(SEL.CMD.RCO,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    LOOP
        REMOVE TP.ID FROM SEL.LIST SETTING SEL.TP.POS
    WHILE TP.ID:SEL.TP.POS
        Y.SUCCESS.FLAG = ''
        CALL F.READ(FN.REDO.ADD.THIRDPARTY,TP.ID,R.REDO.ADD.THIRDPARTY,F.REDO.ADD.THIRDPARTY,REDO.ADD.THIRDPARTY.ERR)
        IF R.REDO.ADD.THIRDPARTY THEN
            Y.COMP.SERV.NAME = R.REDO.ADD.THIRDPARTY<ARC.TP.COMP.SERV.NAME>
            Y.CONTRACT.NO = R.REDO.ADD.THIRDPARTY<ARC.TP.CONTRACT.NO>
            Y.ALIAS.NAME  = R.REDO.ADD.THIRDPARTY<ARC.TP.CUSTOMER.NAME>
            Y.TYPE.OF.SERVICE = R.REDO.ADD.THIRDPARTY<ARC.TP.TYPE.OF.SERVICE>
            GOSUB MAIN.PROCESS
        END

    REPEAT

RETURN
*---------------------------------------------------------------------------
MAIN.PROCESS:
*-------------------------------------------------------------------------------

    SEL.RTP.CMD = "SELECT ":FN.RTP:" WITH COMP.NAME EQ ":Y.COMP.SERV.NAME
    CALL EB.READLIST(SEL.RTP.CMD,SEL.RTP.LIST,'',NO.OF.RTP.REC,SEL.RTP.ERR)
    Y.ID = SEL.RTP.LIST<1>
    IF Y.ID THEN

        CALL F.READ(FN.RTP,Y.ID,R.RTP,F.RTP,REDO.ERR)
        Y.COMP.ID       = R.RTP<REDO.TP.COMP.NAME>
        Y.INTERFACE.REQ = R.RTP<REDO.TP.INTERFACE.REQ>
        Y.METHOD.LIST   = R.RTP<REDO.TP.METHOD.DESC>
        Y.METHOD.NAMES  = R.RTP<REDO.TP.METHOD.NAME>

        Y.FT.BILL.NUM.VALUE =Y.CONTRACT.NO
        CHANGE @VM TO @FM IN Y.METHOD.LIST
        CHANGE @VM TO @FM IN Y.METHOD.NAMES
        IF Y.INTERFACE.REQ EQ "Y" THEN
            LOCATE "getBalanceByNumber" IN Y.METHOD.LIST SETTING METHOD.POS THEN
                GOSUB PROCESS.EXEC
            END
        END

        IF Y.INTERFACE.REQ EQ "N" THEN
            Y.SUCCESS.FLAG = 1
            Y.MONTO = ''
        END


        IF Y.SUCCESS.FLAG THEN
            THIRD.PARTY.LIST<-1> = Y.COMP.SERV.NAME:'*':Y.CONTRACT.NO:'*':Y.ALIAS.NAME:'*':Y.TYPE.OF.SERVICE:'*':Y.MONTO:'*':Y.MSD
        END
    END
RETURN
*------------------------------------------------------------------------------
PROCESS.EXEC:
*------------------------------------------------------------------------------
    Y.METHOD=Y.METHOD.NAMES<METHOD.POS>
    BEGIN CASE
*--------------------------------------------------------------------------------------------------
*This case is to get the due from the orange company
*--------------------------------------------------------------------------------------------------
        CASE Y.METHOD EQ "getBalanceByNumber"
            EJB_ARGUMENT             = Y.METHOD:Y.DELIMITER:Y.FT.BILL.NUM.VALUE
            Y.RESPONSE               = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            Y.AMT.POS                = 3
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
            Y.MONTO.1 = EJB_ARGUMENT<5>
            Y.MONTO.2 = EJB_ARGUMENT<6>

            IF EJB_ARGUMENT<1> EQ 'SUCCESS' THEN
                Y.MONTO = Y.MONTO.1 + Y.MONTO.2
                Y.MSD   = EJB_ARGUMENT<3>
                Y.SUCCESS.FLAG = 1
            END ELSE
                GOSUB HANDLE.FAIL
            END

*---------------------------------------------------------------------------------------------------
*This is to get the due from generic interface
*--------------------------------------------------------------------------------------------------
        CASE Y.METHOD EQ "GetBalance"

            EJB_ARGUMENT=Y.METHOD:Y.DELIMITER:Y.COMP.ID:Y.DELIMITER:Y.FT.BILL.NUM.VALUE
            Y.RESPONSE         = CALLJEE(ACTIVATION.KEY,EJB_ARGUMENT)
            Y.AMT.POS                = 3
            GOSUB HANDLE.PROCESS
    END CASE
RETURN
*--------------
HANDLE.PROCESS:
*--------------
    CHANGE Y.DELIMITER TO @FM IN EJB_ARGUMENT
    IF EJB_ARGUMENT<1> EQ 'SUCCESS' THEN
        Y.MONTO = EJB_ARGUMENT<Y.AMT.POS>
        Y.SUCCESS.FLAG = 1
    END ELSE
        GOSUB HANDLE.FAIL
    END
RETURN
*------------
HANDLE.FAIL:
*------------
    IF EJB_ARGUMENT<1> EQ 'FAIL' THEN
        ENQ.ERROR = "EB-INVALID.DATA"
    END
    ELSE
        Y.RESPONSE.MSG = EJB_ARGUMENT[1,4]
        IF Y.RESPONSE.MSG EQ 'FAIL' OR Y.RESPONSE THEN
            Y.MESSAGE=EJB_ARGUMENT<1>
            IF Y.RESPONSE THEN
                CALL CACHE.READ(FN.EB.ERROR, "EB-TP.CON.FAIL.CODE", R.EB.ERROR, ERR)
                Y.RESP.ERR=R.EB.ERROR<EB.ERR.ERROR.MSG>:' ':Y.RESPONSE
            END
            ELSE
                Y.RESP.ERR =FIELDS(Y.MESSAGE,':',2)
            END
            RE.INT.CODE = 'TPI001'
            RE.INT.TYPE = 'ONLINE'
            RE.BAT.NO = ''
            RE.BAT.TOT = ''
            RE.INFO.OR = ''
            RE.INFO.DE = ''
            RE.ID.PROC = ID.NEW
            RE.MON.TP = '03'
            RE.DESC = Y.RESP.ERR
            RE.REC.CON = ''
            RE.EX.USER = ''
            RE.EX.PC = ''
            CALL REDO.INTERFACE.REC.ACT(RE.INT.CODE,RE.INT.TYPE,RE.BAT.NO,RE.BAT.TOT,RE.INFO.OR,RE.INFO.DE,RE.ID.PROC,RE.MON.TP,RE.DESC,RE.REC.CON,RE.EX.USER,RE.EX.PC)
            ENQ.ERROR = "EB-TP.CONNECT.FAIL"
        END
    END
RETURN
*---------------------------------------------------------------------
END
