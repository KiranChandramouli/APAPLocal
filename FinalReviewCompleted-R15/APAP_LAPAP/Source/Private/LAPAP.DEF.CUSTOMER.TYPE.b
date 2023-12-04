* @ValidationCode : MjotNjA2ODIwMDk5OkNwMTI1MjoxNzAxMTA5NDk1NDI2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Nov 2023 23:54:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP


SUBROUTINE LAPAP.DEF.CUSTOMER.TYPE
*--------------------------------------------------------------------------------------------------------------------------------
*   DESCRIPTION :
*
*
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Ganesh R
* PROGRAM NAME : Based on REDO.DEF.CUSTOMER.TYPE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     VM TO @VM,FM TO @FM
*21-04-2023      Mohanraj R          R22 Manual code conversion   Call Method Format Modified
*06/10/2023	VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES      Interface Change by Santiago
*10-11-2023	VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES      Interface Change by Santiago
*16-11-2023	VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES       Fix SQA-11679 Padrones - By Santiago
*27-11-2023	VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES     SQA-11864 & SQA-11869 � By Santiago
*-----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
*
    $INSERT I_F.CUSTOMER
    $INSERT I_F.VERSION
*SJ start	;*Interface Change by Santiago-new lines added-start
    $INSERT I_F.DFE.TRANSFORM
    $INSERT I_F.REDO.PADRON.WS
*SJ end	;*Interface Change by Santiago-end
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.REDO.FXSN.TXN.VERSION
    $INSERT I_REDO.ID.CARD.CHECK.COMMON
    $INSERT JBC.h
    $USING APAP.REDOVER
    $USING APAP.TAM
    $USING APAP.REDOCHNLS

    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.REF.POSITIONS
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB GET.PROOF.AND.PROCESS
    END

RETURN
*
* =========
OPEN.FILES:
* =========
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.FXSN.TXN.VERSION = 'F.REDO.FXSN.TXN.VERSION'
    F.REDO.FXSN.TXN.VERSION = ''
    CALL OPF(FN.REDO.FXSN.TXN.VERSION,F.REDO.FXSN.TXN.VERSION)

    FN.CUS.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUS.RNC = ''
    CALL OPF(FN.CUS.RNC,F.CUS.RNC)

    FN.CUS.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUS.CIDENT = ''
    CALL OPF(FN.CUS.CIDENT,F.CUS.CIDENT)

    FN.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'
    F.CUS.LEGAL.ID = ''
    CALL OPF(FN.CUS.LEGAL.ID,F.CUS.LEGAL.ID)

*SJ start	;*Interface Change by Santiago-new lines added -start
    FN.DFE.TRANSFORM = 'F.DFE.TRANSFORM'
    F.DFE.TRANSFORM = ''
    CALL OPF(FN.DFE.TRANSFORM,F.DFE.TRANSFORM)
*SJ end	;*Interface Change by Santiago-end

    CIDENT.PROVIDED    = ""
    RNC.PROVIDED       = ""
    CUSTOMER.FULL.NAME = ""
    CIDENT.NUMBER      = ""
    RNC.NUMBER         = ""
    VAR.CUS.DETAILS    = ''
    APAP.CUSTOMER      = ''
*
    PROCESS.GOAHEAD = 1
*
RETURN
*
*---------------------------------------------------------------------------------------------------------------------------------------------------
GET.LOCAL.REF.POSITIONS:
*---------------------------------------------------------------------------------------------------------------------------------------------------
*
    APP.NAME      = "CUSTOMER"
    FIELD.ARR     = "L.CU.CIDENT" : @VM : "L.CU.RNC"
    FIELD.POS.ARR = ""
    CALL MULTI.GET.LOC.REF(APP.NAME,FIELD.ARR,FIELD.POS.ARR)
    L.CU.CIDENT.POS = FIELD.POS.ARR<1,1>
    L.CU.RNC.POS    = FIELD.POS.ARR<1,2>
*
RETURN
*
*---------------------------------------------------------------------------------------------------------------------------------------------------
GET.PROOF.AND.PROCESS:
*---------------------------------------------------------------------------------------------------------------------------------------------------
*
    ID.CARD.NO.CHECK = ""  ; R.CUS.LIST    = ''
    CUS.LIST         = ''  ; CUS.ID        = ''
    CIDENT.NUMBER    = ""  ; CIDENT.LIST   = ''
    RNC.NUMBER       = ""  ; RNC.LIST      = ''
    PASSPORT.NUMBER  = ""  ; PASSPORT.LIST = ''
*
    
    BEGIN CASE
        CASE R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) EQ "CEDULA"
            APAP.REDOVER.redoValCidentCust(Y.APP.VERSION) ;*R22 Manual code conversion
            CUSTOMER.FULL.NAME = System.getVariable("CURRENT.FULL.NAME")	;*Fix SQA-11864 & SQA-11869 � By Santiago-new lines added
            CALL System.setVariable("CURRENT.FULL.NAME",CUSTOMER.FULL.NAME)	;*Fix SQA-11864 & SQA-11869 � By Santiago-new lines added

        CASE R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) EQ "RNC"
            RNC.NUMBER = COMI
            GOSUB RNC.PROOF.CHECK

        CASE R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) EQ "PASAPORTE"
            APAP.TAM.redoValPassportCust(Y.APP.VERSION) ;*R22 Manual Code Conversion-Call Method Format Modified

    END CASE
*

    IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ '' AND COMI NE '' THEN
        R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) = "NO CLIENTE APAP"
        T(REDO.CUS.PRF.CUSTOMER.NAME)<3> = ''
        R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = ''
    END

* Fix for PACS00303910 [CUSTOMER.NAME should be available for i/p when TYPE is NO CLIENTE]

    IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN
        T(REDO.CUS.PRF.CUSTOMER.NAME)<3> = ''
        IF R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) NE "PASAPORTE" THEN
            R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = ''
        END
    END ELSE
        T(REDO.CUS.PRF.CUSTOMER.NAME)<3> = 'NOINPUT'
    END

* End of Fix

*
RETURN
*
*---------------------------------------------------------------------------------------------------------------------------------------------------
RNC.PROOF.CHECK:
*---------------------------------------------------------------------------------------------------------------------------------------------------
*Check RNC Number and update the customer type and name
    GOSUB CHECK.RNC
*PACS00054288 -S
    CALL F.READ(FN.CUS.RNC,RNC.NUMBER,R.CUS.RNC,F.CUS.RNC,CUS.RNC.ERR)
    
    IF R.CUS.RNC THEN
        CUS.ID = FIELD(R.CUS.RNC,"*",2)
        CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
        CUSTOMER.FULL.NAME = R.CUSTOMER<EB.CUS.NAME.1>
        CLIENTE.APAP       = "CLIENTE APAP"
*
        R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) = CLIENTE.APAP
        R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = CUSTOMER.FULL.NAME
*
        VAR.DETAILS = "RNC*":RNC.NUMBER:"*":CUSTOMER.FULL.NAME:"*":CUS.ID

* Fix for PACS00306447 [CURRENT VARIABLE ISSUE #1]

        R.NEW(REDO.CUS.PRF.VAR.NV.INFO) = VAR.DETAILS
        R.NEW(REDO.CUS.PRF.VAR.CLIENT) = CLIENTE.APAP

*        CALL System.setVariable("CURRENT.VAR.DETAILS",VAR.DETAILS)
*        CALL System.setVariable("CURRENT.CLIENTE.APAP",CLIENTE.APAP)

* End of Fix

    END ELSE
        GOSUB CHECK.APP       ;*PACS00171189 - S/E
        GOSUB CHECK.RNC.NON.APAP
    END
*PACS00054288 - E
RETURN

*---------------------------------------------------------------------------------------------------------------------------------------------------
CHECK.RNC:
*---------------------------------------------------------------------------------------------------------------------------------------------------
*Check the given identity number is valid or not
    RNC.CHK.RESULT = ''
    IF LEN(RNC.NUMBER) EQ 9 THEN
        RNC.CHK.RESULT = RNC.NUMBER
        APAP.TAM.redoRncCheckDigit(RNC.CHK.RESULT) ;*R22 Manual Code Conversion-Call Method Format Modified
    END ELSE
        AF = REDO.CUS.PRF.IDENTITY.NUMBER
        ETEXT = "EB-INCORRECT.CHECK.DIGIT"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
    IF RNC.CHK.RESULT NE "PASS" THEN
        AF = REDO.CUS.PRF.IDENTITY.NUMBER
        ETEXT = "EB-INCORRECT.RNC.NUMBER"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
*
RETURN
*
*-------------------------------------------------------------------------------------------------------------------------------------------------
CHECK.RNC.NON.APAP.OLD:		;*Interface Change by Santiago-changed "CHECK.RNC.NON.APAP" to "CHECK.RNC.NON.APAP.OLD"
*---------------------------------------------------------------------------------------------------------------
* APAP Customer RNC check to get customer name
*
Cedule      = "rnc$":RNC.NUMBER
Param1      = "com.padrone.ws.util.MainClass"
Param2      = "callPadrone"
Param3      = Cedule
Ret         = ""
ACTIVATION  = "APAP_PADRONES_WEBSERVICES"
INPUT_PARAM = Cedule
ERROR.CODE  = CALLJEE(ACTIVATION,INPUT_PARAM)
IF ERROR.CODE THEN
    ETEXT= "EB-JAVACOMP":@FM:ERROR.CODE
    CALL STORE.END.ERROR
END ELSE
    Ret=INPUT_PARAM
END
* Processing if the customer provides RNC for identity
IF Ret NE "" THEN
    RNC.RESULT = Ret
    CHANGE '$' TO '' IN RNC.RESULT
    CHANGE '#' TO @FM IN RNC.RESULT
    RNC.RESULT.ERR = RNC.RESULT<1>
    CHANGE '::' TO @FM IN RNC.RESULT.ERR
    IF RNC.RESULT.ERR<1> EQ "SUCCESS" THEN
        CUSTOMER.FULL.NAME = RNC.RESULT<2>
        CLIENTE.APAP = "NO CLIENTE APAP"

* Fix for PACS00306447 [CURRENT VARIABLE ISSUE #2]

        R.NEW(REDO.CUS.PRF.VAR.CLIENT) = CLIENTE.APAP

*            CALL System.setVariable("CURRENT.CLIENTE.APAP",CLIENTE.APAP)

        R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) = "NO CLIENTE APAP"
        R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = CUSTOMER.FULL.NAME
        RNC.CUST.ID = ""
        GOSUB GET.RNC.CUST.ID       ;* PACS00153528 - S/E
        VAR.DETAILS = "RNC*":RNC.NUMBER:"*":CUSTOMER.FULL.NAME:"*":RNC.CUST.ID

        R.NEW(REDO.CUS.PRF.VAR.NV.INFO) = VAR.DETAILS

*            CALL System.setVariable("CURRENT.VAR.DETAILS",VAR.DETAILS)

* End of Fix

        RETURN
    END
    GOSUB CHECK.NON.RNC
END ELSE
    MON.TP = '08'
    DESC = 'El webservices no esta disponible'
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion-Call Method Format Modified
END
RETURN

;*Interface Change by Santiago-new lines added-start
*-------------------------------------------------------------------------------------------------------------------------------------------------
CHECK.RNC.NON.APAP:
*-------------------------------------------------------------------------------------------------------------------------------------------------
    
    Cedule = TRIM(RNC.NUMBER)		;*Fix SQA-11679 Padrones- By Santiago-New line added
    Y.INTRF.ID = 'REDO.PADRON.JURIDICO'
    R.PAD.WS<PAD.WS.CEDULA> = Cedule
    Y.RESPONSE = ''
    Y.ID.TEMP = ID.NEW
    ID.NEW = Y.INTRF.ID
    CALL DFE.ONLINE.TRANSACTION(Y.INTRF.ID, R.PAD.WS, Y.RESPONSE)
    ID.NEW = Y.ID.TEMP
    
* values obtained from the web service
*   PADRON.FISICO                           PADRON JURIDICO
*   IDENTI           = Y.RESPONSE<1>        IDENTI     = Y.RESPONSE<1>
*   NOMBRE           = Y.RESPONSE<2>        NOMBRE     = Y.RESPONSE<2>
*   NOMBRE_COMPLETO  = Y.RESPONSE<3>        RESERVED.1 = Y.RESPONSE<3>
*   SEXO             = Y.RESPONSE<4>        RESERVED.2 = Y.RESPONSE<4>
*   FECHA_NACIMIENTO = Y.RESPONSE<5>        RESERVED.3 = Y.RESPONSE<5>
*   APELLIDOS        = Y.RESPONSE<6>        RESERVED.4 = Y.RESPONSE<6>
*   STATUS.CODE      = Y.RESPONSE<7>        STATUS.CODE= Y.RESPONSE<7>
*   STATUS.DESC      = Y.RESPONSE<8>        STATUS.DESC= Y.RESPONSE<8>
   
    IF Y.RESPONSE EQ 'ERROR' OR Y.RESPONSE EQ ''  THEN
        MON.TP = '08'
        DESC = 'El webservices no esta disponible'
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion-Call Method Format Modified
        ERROR.CODE = 'LAPAP.DEF.CUSTOMER.TYPE'
        ETEXT= "EB-JAVACOMP":@FM:ERROR.CODE
        CALL STORE.END.ERROR
    END
    
    IF Y.RESPONSE<7> EQ "SUCCESS" THEN	;*Fix SQA-11679 Padrones- By Santiago- changed "RNC.RESULT.ERR" to "TRIM(Y.RESPONSE<7>)"	;*Fix SQA-11864 & SQA-11869 � By Santiago- changed "TRIM(Y.RESPONSE<7>)" to "Y.RESPONSE<7>"
        CUSTOMER.FULL.NAME = Y.RESPONSE<2>
        CLIENTE.APAP = "NO CLIENTE APAP"

        R.NEW(REDO.CUS.PRF.VAR.CLIENT) = CLIENTE.APAP
        R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) = "NO CLIENTE APAP"
        R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = Y.RESPONSE ;*CUSTOMER.FULL.NAME 	;*Fix SQA-11864 & SQA-11869 � By Santiago-changed "CUSTOMER.FULL.NAME" to "Y.RESPONSE"
        RNC.CUST.ID = ""
        GOSUB GET.RNC.CUST.ID       ;* PACS00153528 - S/E
        VAR.DETAILS = "RNC*":RNC.NUMBER:"*":CUSTOMER.FULL.NAME:"*":RNC.CUST.ID

        R.NEW(REDO.CUS.PRF.VAR.NV.INFO) = VAR.DETAILS

        RETURN
    END

    GOSUB CHECK.NON.RNC
    
RETURN
;*Interface Change by Santiago-end
*------------------------------------------------------------------------------------------------------------------------------------------------
CHECK.NON.RNC:
;*Interface Change by Santiago-new lines added-start
*-------------------------------------------------------------------------------------------------------------------------------------------------
    INT.CODE = 'RNC002'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    MON.TP = ''
    DESC = ''
    REC.CON = ''
    EX.USER = ''
    EX.PC = ''
    IF Y.RESPONSE<7> EQ "FAILURE" THEN	;*Fix SQA-11679 Padrones- By Santiago- changed "Y.RESPONSE<7>" to "TRIM(Y.RESPONSE<7>)"	;*Fix SQA-11864 & SQA-11869 � By Santiago- changed "TRIM(Y.RESPONSE<7>)" to "Y.RESPONSE<7>"
        R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = ""
        MON.TP = '04'
        REC.CON = Y.RESPONSE<7>	;*Fix SQA-11679 Padrones- By Santiago - changed "Y.RESPONSE<7>" to "TRIM(Y.RESPONSE<7>)"	;*Fix SQA-11864 & SQA-11869 � By Santiago- changed "TRIM(Y.RESPONSE<7>)" to "Y.RESPONSE<7>"
        DESC = Y.RESPONSE<8>
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion-Call Method Format Modified
        AF = REDO.CUS.PRF.IDENTITY.NUMBER
        ETEXT = "EB-INCORRECT.RNC.NUMBER"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
RETURN

*------------------------------------------------------------------------------------------------------------------------------------------------
CHECK.NON.RNC.OLD:	;*Interface Change by Santiago-end
*-------------------------------------------------------------------------------------------------------------------------------------------------
INT.CODE = 'RNC002'
INT.TYPE = 'ONLINE'
BAT.NO = ''
BAT.TOT = ''
INFO.OR = ''
INFO.DE = ''
ID.PROC = ''
MON.TP = ''
DESC = ''
REC.CON = ''
EX.USER = ''
EX.PC = ''
IF RNC.RESULT.ERR<1> EQ "FAILURE" THEN
    RNC.RESULT = Ret
    CHANGE '::' TO @FM IN RNC.RESULT
    R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = ""
    MON.TP = '04'
    REC.CON = RNC.RESULT<2>
    DESC = RNC.RESULT<3>
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion-Call Method Format Modified
    AF = REDO.CUS.PRF.IDENTITY.NUMBER
    ETEXT = "EB-INCORRECT.RNC.NUMBER"
    CALL STORE.END.ERROR
    GOSUB PGM.END
END
RETURN

*------------------------------------------------------------------------------------------------------------------------------------------------
GET.RNC.CUST.ID:
*------------------------------------------------------------------------------------------------------------------------------------------------
*New section included to default customer id for prospect customer
    R.CUS.RNC = ''
    Y.VALUE = COMI
    CALL F.READ(FN.CUS.RNC,Y.VALUE,R.CUS.RNC,F.CUS.RNC,RNC.ERR)
    IF R.CUS.RNC THEN
        RNC.CUST.ID = FIELD(R.CUS.RNC,"*",2)
    END
RETURN
*
*----------------------------------------------------------------------------------------------------------------------------------------------------
CHECK.APP:
*----------------------------------------------------------------------------------------------------------------------------------------------------
*
    IF Y.APP.VERSION EQ 'FOREX' THEN
        R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) = "NO CLIENTE APAP"
        AF = REDO.CUS.PRF.IDENTITY.NUMBER
        ETEXT = "EB-INVALID.IDENTITY"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF MESSAGE EQ 'VAL' THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                GOSUB CHECK.T24.VERSION
        END CASE
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*-----------------------
CHECK.T24.VERSION:
*-----------------------

    TXN.TYPE.NAME = R.NEW(REDO.CUS.PRF.T24.MODULE)
    CALL CACHE.READ(FN.REDO.FXSN.TXN.VERSION,"SYSTEM",R.REDO.FXSN.TXN.VERSION,REDO.FXSN.TXN.VERSION.ERR)
    TXN.DESCS = R.REDO.FXSN.TXN.VERSION<REDO.TXN.VER.T24.TXN.DESC>
    CHANGE @VM TO @FM IN TXN.DESCS
    LOCATE TXN.TYPE.NAME IN TXN.DESCS SETTING VERSION.POS THEN
        VAR.VERSION   = R.REDO.FXSN.TXN.VERSION<REDO.TXN.VER.VERSION.NAME,VERSION.POS>
        Y.APP.VERSION = FIELD(VAR.VERSION,',',1)
        R.NEW(REDO.CUS.PRF.T24.VERSION) = VAR.VERSION
    END ELSE
        R.NEW(REDO.CUS.PRF.T24.VERSION) = ""
        ETEXT           = "EB-INVALID.TXN.TYPE"
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------
*
*---------
PGM.END:
*---------
*
RETURN
*
END
