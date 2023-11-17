* @ValidationCode : MjoyMDgwMzQ2MjY6Q3AxMjUyOjE2OTk1MDY2MjA5Nzk6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Nov 2023 10:40:20
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.RBHP.NAME(Y.OUT)    
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : john chrisptopher
* Program Name :
*-----------------------------------------------------------------------------
* Description :Enquiry routine to retreive image of padrones
* Linked with :
* In Parameter :
* Out Parameter :
*
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 06/10/2023	   VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES-Interface Change by Santiago
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_System
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT JBC.h
;*Interface Change by Santiago-START-NEW LINES ADDED
*SJ start
    $INSERT I_F.DFE.TRANSFORM
    $INSERT I_F.REDO.PADRON.WS
*SJ end
;*Interface Change by Santiago-END
    GOSUB INIT
    GOSUB PROCESS
RETURN

*******
INIT:
*******
    Y.OUT=''

    FN.CUS.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUS.RNC = ''
    CALL OPF(FN.CUS.RNC,F.CUS.RNC)

    FN.CUS.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUS.CIDENT = ''
    CALL OPF(FN.CUS.CIDENT,F.CUS.CIDENT)

    FN.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'
    F.CUS.LEGAL.ID = ''
    CALL OPF(FN.CUS.LEGAL.ID,F.CUS.LEGAL.ID)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
;*Interface Change by Santiago-NEW LINES ADDED-START
*SJ start
    FN.DFE.TRANSFORM = 'F.DFE.TRANSFORM'
    F.DFE.TRANSFORM = ''
    CALL OPF(FN.DFE.TRANSFORM,F.DFE.TRANSFORM)
*SJ end
;*Interface Change by Santiago-END

RETURN
********
PROCESS:
********
    BEGIN CASE
        CASE R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) EQ "CEDULA"
            CIDENT.NUMBER = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
            GOSUB CIDENT.PROOF.CHECK
        CASE R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) EQ "RNC"
            RNC.NUMBER = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
            GOSUB RNC.PROOF.CHECK
        CASE R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) EQ "PASAPORTE"
            PASSPORT.NUMBER = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
            GOSUB PASSPORT.PROOF.CHECK
    END CASE
RETURN
********************
CIDENT.PROOF.CHECK:
********************
    CALL F.READ(FN.CUS.CIDENT,CIDENT.NUMBER,R.CUS.CIDENT,F.CUS.CIDENT,CUS.ERR)
    IF R.CUS.CIDENT THEN
        CUS.ID = FIELD(R.CUS.CIDENT,"*",2)
        CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
        IF NOT(CUSTOMER.ERR) THEN
            Y.OUT = R.CUSTOMER<EB.CUS.NAME.1>
        END
    END ELSE
        GOSUB FETCH.PADRONE.CIDENT
    END
RETURN
*****************
RNC.PROOF.CHECK:
******************
    CALL F.READ(FN.CUS.RNC,RNC.NUMBER,R.CUS.RNC,F.CUS.RNC,CUS.RNC.ERR)
    IF R.CUS.RNC THEN
        CUS.ID = FIELD(R.CUS.RNC,"*",2)
        CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
        IF NOT(CUSTOMER.ERR) THEN
            Y.OUT = R.CUSTOMER<EB.CUS.NAME.1>
        END
    END ELSE
        GOSUB FETCH.PADRONE.RNC
    END
RETURN
***********************
PASSPORT.PROOF.CHECK:
************************
    CALL F.READ(FN.CUS.LEGAL.ID,PASSPORT.NUMBER,R.CUS.LEGAL.ID,F.CUS.LEGAL.ID,CUS.LEGAL.ERR)
    IF R.CUS.LEGAL.ID THEN
        CUS.ID = FIELD(R.CUS.LEGAL.ID,"*",2)
        CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
        Y.OUT = R.CUSTOMER<EB.CUS.NAME.1>
    END
RETURN
**********************
FETCH.PADRONE.CIDENT.OLD: ;*Interface Change by Santiago-CHANGED "FETCH.PADRONE.CIDENT" TO "FETCH.PADRONE.CIDENT.OLD"
**********************
    Cedule = "padrone$":CIDENT.NUMBER
    Param1 = "com.padrone.ws.util.MainClass"
    Param2 = "callPadrone"
    Param3 = Cedule
    Ret = ""
    ACTIVATION = "APAP_PADRONES_WEBSERVICES"
    INPUT_PARAM=Cedule
    ERROR.CODE = CALLJEE(ACTIVATION,INPUT_PARAM)
    IF ERROR.CODE THEN
        E= "EB-JAVACOMP":@FM:ERROR.CODE
    END ELSE
        Ret=INPUT_PARAM
    END
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

            Y.OUT = CUSTOMER.FULL.NAME
        END
    END
RETURN
*********************
FETCH.PADRONE.RNC.OLD:	;*Interface Change by Santiago-CHANGED "FETCH.PADRONE.RNC" TO "FETCH.PADRONE.RNC.OLD"
***********************
    Cedule = "rnc$":RNC.NUMBER
    Param1 = "com.padrone.ws.util.MainClass"
    Param2 = "callPadrone"
    Param3 = Cedule
    Ret = ""
    ACTIVATION = "APAP_PADRONES_WEBSERVICES"
    INPUT_PARAM=Cedule
    ERROR.CODE = CALLJEE(ACTIVATION,INPUT_PARAM)
    IF ERROR.CODE THEN
        E= "EB-JAVACOMP":@FM:ERROR.CODE
    END ELSE
        Ret=INPUT_PARAM
    END

    IF Ret NE "" THEN
        RNC.RESULT = Ret
        CHANGE '$' TO '' IN RNC.RESULT
        CHANGE '#' TO @FM IN RNC.RESULT
        RNC.RESULT.ERR = RNC.RESULT<1>
        CHANGE '::' TO @FM IN RNC.RESULT.ERR
        IF RNC.RESULT.ERR<1> EQ "SUCCESS" THEN
            CUSTOMER.FULL.NAME = RNC.RESULT<2>
            Y.OUT = CUSTOMER.FULL.NAME
        END
    END
RETURN
*****************************************************************
;*Interface Change by Santiago-START-NEW LINES ADDED
**********************
FETCH.PADRONE.CIDENT:
**********************
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

    IF Y.RESPONSE EQ 'ERROR' OR Y.RESPONSE EQ '' THEN
        ERROR.CODE = 'REDO.NOFILE.RBJP.NAME-cedula'
        E= "EB-JAVACOMP":@FM:ERROR.CODE
    END ELSE
        IF CIDENT.RESULT.ERR<1> EQ "SUCCESS" THEN     ;* On successfull CIDENT number
            Y.APELLIDO = Y.RESPONSE<6>
            Y.NOMBRE = Y.RESPONSE<2>
            CUSTOMER.FULL.NAME = Y.NOMBRE:' ':Y.APELLIDO
            Y.OUT = CUSTOMER.FULL.NAME
        END
    END
RETURN
*********************
FETCH.PADRONE.RNC:
***********************
*    Cedule = "rnc$":RNC.NUMBER
    Cedule = RNC.NUMBER
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
        ERROR.CODE = 'REDO.NOFILE.RBJP.NAME-rnc'
        E= "EB-JAVACOMP":@FM:ERROR.CODE
    END ELSE
        IF Y.RESPONSE<7> EQ "SUCCESS" THEN
            CUSTOMER.FULL.NAME = Y.RESPONSE<3>
            Y.OUT = CUSTOMER.FULL.NAME
        END
    END
RETURN
;*Interface Change by Santiago-END
END
