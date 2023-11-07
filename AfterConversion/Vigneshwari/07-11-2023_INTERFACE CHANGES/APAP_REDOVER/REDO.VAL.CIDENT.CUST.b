* @ValidationCode : Mjo0NjE1NzEwMjI6Q3AxMjUyOjE2OTkzNTE0OTYyNjQ6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Nov 2023 15:34:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
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
*07/10/2023	VIGNESHWARI      ADDED COMMENT FOR INTERFACE CHANGES      Interface Change by Santiago

*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT JBC.h
    $USING APAP.REDOSRTN
*
    $INSERT I_F.CUSTOMER
*
*SJ start	;*Interface Change by Santiago-NEW LINES ADDED-START
    $INSERT I_F.DFE.TRANSFORM
    $INSERT I_F.REDO.PADRON.WS
*SJ end		;*Interface Change by Santiago-END
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_REDO.ID.CARD.CHECK.COMMON
    $USING APAP.REDOCHNLS
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
* ;*Interface Change by Santiago-START-NEW LINES ADDED
INITIALISE:
    PROCESS.GOAHEAD = 1
    CIDENT.CHK.RESULT = ""
    CLIENTE.APAP       = ""
    CUSTOMER.FULL.NAME = ""
    CIDENT.NUMBER = COMI
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    FN.CUS.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUS.CIDENT = ''
RETURN
* ======
OPEN.FILES:
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.CUS.CIDENT,F.CUS.CIDENT)
*SJ start
    FN.DFE.TRANSFORM = 'F.DFE.TRANSFORM'
    F.DFE.TRANSFORM = ''
    CALL OPF(FN.DFE.TRANSFORM,F.DFE.TRANSFORM)
*SJ end
RETURN
* 	;*Interface Change by Santiago-END
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

CHECK.CID.NON.APAP.OLD:	;*Interface Change by Santiago- Changed "CHECK.CID.NON.APAP" to "CHECK.CID.NON.APAP.OLD"
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

ANALIZE.RESULT.OLD:	;*Interface Change by Santiago- Changed "ANALIZE.RESULT" to "ANALIZE.RESULT.OLD"
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
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CODE CONVERSION
        PROCESS.GOAHEAD = ""
    END
*
RETURN


CHECK.NON.CIDENT.OLD:	;*Interface Change by Santiago- Changed "CHECK.NON.CIDENT" to "CHECK.NON.CIDENT.OLD"

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
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)  ;*R22 MANUAL CODE CONVERSION
        AF              = REDO.CUS.PRF.IDENTITY.NUMBER
        ETEXT           = "EB-INCORRECT.CIDENT.NUMBER"
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END
*
RETURN
*
CHECK.CID.NON.APAP:		;*Interface Change by Santiago- new lines added-start
*   Non APAP Customer

*    Cedule = "padrone$":CIDENT.NUMBER
    Cedule = CIDENT.NUMBER
    Y.INTRF.ID = 'REDO.PADRON.FISICO'
    R.PAD.WS<PAD.WS.CEDULA> = Cedule
    Y.RESPONSE = ''
    Y.ID.TEMP = ID.NEW
    ID.NEW = 'REDO.PADRON.FISICO'
    CALL DFE.ONLINE.TRANSACTION(Y.INTRF.ID, R.PAD.WS, Y.RESPONSE)
    ID.NEW = Y.ID.TEMP
    
* values obtained from the web service
*   IDENTI           = Y.RESPONSE<1>
*   NOMBRE           = Y.RESPONSE<2>
*   NOMBRE_COMPLETO  = Y.RESPONSE<3>
*   SEXO             = Y.RESPONSE<4>
*   FECHA_NACIMIENTO = Y.RESPONSE<5>
*   APELLIDOS        = Y.RESPONSE<6>
*   STATUS.CODE      = Y.RESPONSE<7>
*   STATUS.DESC      = Y.RESPONSE<8>
    
    IF Y.RESPONSE EQ 'ERROR' OR Y.RESPONSE EQ '' THEN
        MON.TP = '08'
        DESC = 'El webservices no esta disponible'
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CODE CONVERSION
        PROCESS.GOAHEAD = ""
                    
        ERROR.CODE = 'REDO.VAL.CIDENT.CUST'
        ETEXT= "EB-JAVACOMP":@FM:ERROR.CODE
        CALL STORE.END.ERROR
    END

    GOSUB ANALIZE.RESULT


RETURN

ANALIZE.RESULT:

    IF Y.RESPONSE<7> EQ "SUCCESS" THEN     ;* On successfull CIDENT number
        Y.APELLIDO = Y.RESPONSE<6>
        Y.NOMBRE = Y.RESPONSE<2>
        CUSTOMER.FULL.NAME = Y.NOMBRE:' ':Y.APELLIDO
        CLIENTE.APAP       = "NO CLIENTE APAP"
    END ELSE
        GOSUB CHECK.NON.CIDENT
    END

RETURN


CHECK.NON.CIDENT:

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

    IF Y.RESPONSE<7> EQ "FAILURE" THEN
        R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = ""
*        CIDENT.RESULT                     = Ret
*        CHANGE '::' TO @FM IN CIDENT.RESULT
        MON.TP   = '04'
        REC.CON  = Y.RESPONSE<7>
        DESC     = Y.RESPONSE<8>
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)  ;*R22 MANUAL CODE CONVERSION
        AF              = REDO.CUS.PRF.IDENTITY.NUMBER
        ETEXT           = "EB-INCORRECT.CIDENT.NUMBER"
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END

RETURN
;*Interface Change by Santiago- end
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
RETURN	;*Interface Change by Santiago-lines are removed-start
*
* =========
*INITIALISE:
* =========
*
*    PROCESS.GOAHEAD = 1
*
*    CIDENT.CHK.RESULT = ""
*
 *   CLIENTE.APAP       = ""
  *  CUSTOMER.FULL.NAME = ""

    *CIDENT.NUMBER = COMI
*
   * FN.CUSTOMER = 'F.CUSTOMER'
  *  F.CUSTOMER = ''
*
 *   FN.CUS.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
 *   F.CUS.CIDENT = ''
*
RETURN
*
* =========
*OPEN.FILES:
* =========
*
  *  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  *  CALL OPF(FN.CUS.CIDENT,F.CUS.CIDENT)
*	
*RETURN		;*Interface Change by Santiago-end
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
                APAP.REDOSRTN.redoSCalcCheckDigit(CIDENT.CHK.RESULT)   ;*R22 MANUAL CODE CONVERSION

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
