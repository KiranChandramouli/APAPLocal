* @ValidationCode : MjoxMDM0MzkzNDg6Q3AxMjUyOjE2OTk1MDc4NDQzNjk6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Nov 2023 11:00:44
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.DEF.CUSTOMER.TYPE
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
* PROGRAM NAME : REDO.DEF.CUSTOMER.TYPE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
*   DATE           AUTHOR            REFERENCE       DESCRIPTION
*
*   23-Feb-2011    Ganesh R          HD1048578       Initial creation
*   28-Mar-2011    Sudharsanan S     PACS00034123    Check the cident,rnc and passport value for apap & non apap customers
*   22-Apr-2011    Sudharsanan S     PACS00054288    Remove few lines and modify the coding
*   01-Jun-2011    Sudharsanan S     PACS00062261    Change the Identity type value : CIDENT - CEDULA , PASSPORT - PASAPORTE
*   18-07-2011     Prabhu N          PACS00023966    callj modified to calljee
*   29-07-2011     JEEVA T           PACS00023966    Change Identity type value
*   11-10-2011     Shankar Raju      PACS00142987    Removing C$SPARE & Making CUSTOMER.NAME field as inputable field if
*                                                    Client is Non-APAP & using Passport
*   10-11-2011     Pradeep S         PACS00153528    For NON APAP Customer - Client id is added as part of FXSN reference
*   19-12-2011     Sudharsanan S     PACS00171189    For FOREX Transaction - Raise the error message if customer type is NON APAP CUSTOMER
*   28-02-2012     PRABHU N                          CHANGES MADE TO PICK THE CORRECT NAME
*   30-MAR-2012    JCOSTA            PACS00172912    CHANGES MADE TO USE FULL NAME - USE NEW ROUTINES ACCORDING TO DOCUMENT TYPE
*   08-JUL-2013    Vignesh Kumaar R  PACS00303910    CUSTOMER.NAME should be available for i/p when TYPE is NO CLIENTE
*   09-Sep-2013    Vignesh Kumaar R  PACS00306447    CURRENT VARIABLE ISSUE [UPDATED PACK]
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            FM TO @FM, VM TO @VM
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION          CALL Rtn format modified
*07/10/2023	VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES      Interface Change by Santiago
*-----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
*
    $INSERT I_F.CUSTOMER
    $INSERT I_F.VERSION
*

*SJ start	;*Interface Change by Santiago-NEW LINES ADDED-START
    $INSERT I_F.DFE.TRANSFORM
    $INSERT I_F.REDO.PADRON.WS
*SJ end		;*Interface Change by Santiago
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.REDO.FXSN.TXN.VERSION
    $INSERT I_REDO.ID.CARD.CHECK.COMMON
    $INSERT JBC.h
    $USING APAP.REDOVER
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
    
*SJ start	;*Interface Change by Santiago-NEW LINES ADDED-START
    FN.DFE.TRANSFORM = 'F.DFE.TRANSFORM'
    F.DFE.TRANSFORM = ''
    CALL OPF(FN.DFE.TRANSFORM,F.DFE.TRANSFORM)
*SJ end	;*Interface Change by Santiago-END

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
            
*APAP.REDOVER.REDO.VAL.CIDENT.CUST(Y.APP.VERSION) ;*MANUAL R22 CODE CONVERSION
            APAP.REDOVER.redoValCidentCust(Y.APP.VERSION)
        CASE R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) EQ "RNC"
            RNC.NUMBER = COMI
            GOSUB RNC.PROOF.CHECK
        CASE R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) EQ "PASAPORTE"
* APAP.TAM.REDO.VAL.PASSPORT.CUST(Y.APP.VERSION) ;*MANUAL R22 CODE CONVERSION
            APAP.TAM.redoValPassportCust(Y.APP.VERSION)
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
        R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = ''
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
        GOSUB CHECK.APP ;*PACS00171189 - S/E
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
* APAP.TAM.REDO.RNC.CHECK.DIGIT(RNC.CHK.RESULT) ;*MANUAL R22 CODE CONVERSION
        APAP.TAM.redoRncCheckDigit(RNC.CHK.RESULT)
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
CHECK.RNC.NON.APAP.OLD:	;*Interface Change by Santiago-CHANGED "CHECK.RNC.NON.APAP" TO "CHECK.RNC.NON.APAP.OLD"
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
            GOSUB GET.RNC.CUST.ID   ;* PACS00153528 - S/E
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
*    APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END
RETURN
;*Interface Change by Santiago-START
*-------------------------------------------------------------------------------------------------------------------------------------------------
CHECK.RNC.NON.APAP:
*---------------------------------------------------------------------------------------------------------------
* APAP Customer RNC check to get customer name
*
    Cedule      = RNC.NUMBER
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
   

    IF Y.RESPONSE EQ 'ERROR' OR Y.RESPONSE EQ '' THEN
        MON.TP = '08'
        DESC = 'El webservices no esta disponible'
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        
        ERROR.CODE = 'REDO.DEF.CUSTOMER.TYPE'
        ETEXT= "EB-JAVACOMP":@FM:ERROR.CODE
        CALL STORE.END.ERROR
    END
    
    IF Y.RESPONSE NE "" THEN
        IF Y.RESPONSE<7> EQ "SUCCESS" THEN
            CUSTOMER.FULL.NAME = Y.RESPONSE<3>
            CLIENTE.APAP = "NO CLIENTE APAP"

            R.NEW(REDO.CUS.PRF.VAR.CLIENT) = CLIENTE.APAP
            R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) = "NO CLIENTE APAP"
            R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = CUSTOMER.FULL.NAME
            RNC.CUST.ID = ""
            GOSUB GET.RNC.CUST.ID
            VAR.DETAILS = "RNC*":RNC.NUMBER:"*":CUSTOMER.FULL.NAME:"*":RNC.CUST.ID
            R.NEW(REDO.CUS.PRF.VAR.NV.INFO) = VAR.DETAILS
            RETURN
        END
        GOSUB CHECK.NON.RNC
    END
RETURN
;*Interface Change by Santiago-END
*------------------------------------------------------------------------------------------------------------------------------------------------
CHECK.NON.RNC:
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
    IF Y.RESPONSE<7> EQ "FAILURE" THEN	;*Interface Change by Santiago-CHANGED "RNC.RESULT.ERR<1>" TO "Y.RESPONSE<7>"
        RNC.RESULT = Ret
*        CHANGE '::' TO @FM IN RNC.RESULT	;*Interface Change by Santiago-THIS LINE IS REMOVED
        R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = ""
        MON.TP = '04'
        REC.CON = Y.INTRF.ID	;*Interface Change by Santiago-CHANGED "RNC.RESULT<2>" TO "Y.INTRF.ID"
        DESC = Y.INTRF.ID	;*Interface Change by Santiago-CHANGED "RNC.RESULT<3>" TO "Y.INTRF.ID"
* APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
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
