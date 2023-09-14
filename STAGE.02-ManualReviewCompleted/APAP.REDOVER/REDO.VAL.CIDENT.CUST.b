* @ValidationCode : MjotMTc2NDI5MTEwMzpDcDEyNTI6MTY4MTczODA3NDcxNTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 18:57:54
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
SUBROUTINE REDO.VAL.CIDENT.CUST(Y.APP.VERSION)
*--------------------------------------------------------------------------------------------------------------------------------
*   DESCRIPTION :
*
*   VALIDATES CEDULA ID NUMBER AND GETS CUSTOMER NAME
*
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JOAQUIN COSTA
*
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date             Author                    Reference                     Description
* MAR-30-2012      J COSTA                    GRUPO 7                   Initial creation
*17-04-2023       Conversion Tool        R22 Auto Code conversion          FM TO @FM
*17-04-2023       Samaran T               R22 Manual Code Conversion       CALL ROUTINE FORMAT MODIFIED
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT JBC.h
*
    $INSERT I_F.CUSTOMER
*
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_REDO.ID.CARD.CHECK.COMMON
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
    R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) = CLIENTE.APAP
    R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = CUSTOMER.FULL.NAME
*
    VAR.DETAILS = "CEDULA*" : CIDENT.NUMBER : "*" : CUSTOMER.FULL.NAME : "*" :CUS.ID
*
    CALL System.setVariable("CURRENT.VAR.DETAILS",VAR.DETAILS)
    CALL System.setVariable("CURRENT.CLIENTE.APAP",CLIENTE.APAP)
*
RETURN
*
* =================
CHECK.CID.NON.APAP:
* =================
*
*   Non APAP Customer
*
    Cedule = "padrone$":CIDENT.NUMBER
    Param1 = "com.padrone.ws.util.MainClass"
    Param2 = "callPadrone"
    Param3 = Cedule
    Ret    = ""
*
    ACTIVATION  = "APAP_PADRONES_WEBSERVICES"
    INPUT_PARAM = Cedule
*
    ERROR.CODE  = CALLJEE(ACTIVATION,INPUT_PARAM)
*
    IF ERROR.CODE THEN
        ETEXT           = "EB-JAVACOMP" : @FM : ERROR.CODE
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END ELSE
        Ret = INPUT_PARAM
        GOSUB ANALIZE.RESULT
    END
*
RETURN
*
* =============
ANALIZE.RESULT:
* =============
*
    IF Ret NE "" THEN
        CIDENT.RESULT = Ret
        CHANGE '$' TO '' IN CIDENT.RESULT
        CHANGE '#' TO @FM IN CIDENT.RESULT
        CIDENT.RESULT.ERR = CIDENT.RESULT<1>
        CHANGE '::' TO @FM IN CIDENT.RESULT.ERR
        CHANGE '::' TO @FM IN CIDENT.RESULT
        IF CIDENT.RESULT.ERR<1> EQ "SUCCESS" THEN     ;* On successfull CIDENT number
            Y.APELLIDO = CIDENT.RESULT<2>
            Y.NOMBRE = CIDENT.RESULT<4>
            CUSTOMER.FULL.NAME = Y.NOMBRE:' ':Y.APELLIDO
            CLIENTE.APAP       = "NO CLIENTE APAP"
        END ELSE
            GOSUB CHECK.NON.CIDENT
        END
    END ELSE
        MON.TP = '08'
        DESC = 'El webservices no esta disponible'
        CALL APAP.REDOVER.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)    ;*R22 MANUAL CODE CONVERSION
        PROCESS.GOAHEAD = ""
    END
*
RETURN
*
* ===============
CHECK.NON.CIDENT:
* ===============
*
    INT.CODE = 'CID002'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    MON.TP   = ''
    DESC     = ''
    REC.CON  = ''
    EX.USER  = ''
    EX.PC    = ''
*
    IF CIDENT.RESULT.ERR<1> EQ "FAILURE" THEN
        R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = ""
        CIDENT.RESULT                     = Ret
        CHANGE '::' TO @FM IN CIDENT.RESULT
        MON.TP   = '04'
        REC.CON  = CIDENT.RESULT<2>
        DESC     = CIDENT.RESULT<3>
        CALL APAP.REDOVER.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)    ;*R22 MANUAL CODE CONVERSION
        AF              = REDO.CUS.PRF.IDENTITY.NUMBER
        ETEXT           = "EB-INCORRECT.CIDENT.NUMBER"
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END
*
RETURN
*
* ================
GET.CUSTOMER.INFO:
* ================
*
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    IF R.CUSTOMER THEN
        CUS.SEC = R.CUSTOMER<EB.CUS.SECTOR>
        IF CUS.SEC EQ 9999 THEN
            CLIENTE.APAP       = "NO CLIENTE APAP"
        END ELSE
            CLIENTE.APAP       = "CLIENTE APAP"
        END
        CUSTOMER.FULL.NAME = R.CUSTOMER<EB.CUS.NAME.1>
    END ELSE
        GOSUB NO.CLIENTE.APAP
    END
*
RETURN
*
* ==============
NO.CLIENTE.APAP:
* ==============
*
*    Y.APP.VERSION = FIELD(VAR.VERSION,',',1)
    IF Y.APP.VERSION EQ 'FOREX' THEN
        AF              = REDO.CUS.PRF.IDENTITY.NUMBER
        ETEXT           = "EB-INVALID.IDENTITY"
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END ELSE
        GOSUB CHECK.CID.NON.APAP
    END
*
RETURN
*
* =================
GET.CIDENT.CUST.ID:
* =================
*
*   New section included to default customer id for prospect customer
*
    R.CUS.CIDENT   = ''
    CUS.ID         = ''
*
    CALL F.READ(FN.CUS.CIDENT,CIDENT.NUMBER,R.CUS.CIDENT,F.CUS.CIDENT,CIDENT.ERR)
    IF R.CUS.CIDENT THEN
        CUS.ID = FIELD(R.CUS.CIDENT,"*",2)
        GOSUB GET.CUSTOMER.INFO
    END ELSE
        GOSUB NO.CLIENTE.APAP
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
*
    CIDENT.CHK.RESULT = ""
*
    CLIENTE.APAP       = ""
    CUSTOMER.FULL.NAME = ""

    CIDENT.NUMBER = COMI
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
*
    FN.CUS.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUS.CIDENT = ''
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.CUS.CIDENT,F.CUS.CIDENT)
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF LEN(CIDENT.NUMBER) NE 11 THEN
                    AF = REDO.CUS.PRF.IDENTITY.NUMBER
                    ETEXT = "EB-INCORRECT.CHECK.DIGIT"
                    CALL STORE.END.ERROR
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                CIDENT.CHK.RESULT = CIDENT.NUMBER
                CALL APAP.TAM.REDO.S.CALC.CHECK.DIGIT(CIDENT.CHK.RESULT)   ;*R22 MANUAL CODE CONVERSION

                IF CIDENT.CHK.RESULT NE "PASS" THEN
                    AF = REDO.CUS.PRF.IDENTITY.NUMBER
                    ETEXT = "EB-INCORRECT.CIDENT.NUMBER"
                    CALL STORE.END.ERROR
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                GOSUB GET.CIDENT.CUST.ID

        END CASE
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
END
