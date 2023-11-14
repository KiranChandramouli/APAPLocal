* @ValidationCode : MjoxNTA2OTE5NDMzOkNwMTI1MjoxNjk5OTYwODA3OTI2OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Nov 2023 16:50:07
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
$PACKAGE APAP.TAM

*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
*10-11-2023	VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES      Interface Change by Santiago
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.V.VAL.RNC
******************************************************************************************************************
*Company Name : Asociaciopular de Ahorros y Pramos Bank
*Developed By : NARESH.CHAVADAPU(nareshc@temenos.com)
*Date : 28-10-2009
*Program Name : REDO.V.VAL.RNC
*-----------------------------------------------------------------------------------------------------------------
*Description : This routine serves as a field level validation for the field l.cu.rnc***
*Linked With : REDO.V.VAL.RNC
*In Parameter : NA
*Out Parameter : NA
*-----------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date Name Reference Version
* ------- ---- ---------- --------
* 29/10/2009 R.Ganesh ODR-2009-10-0807 Initial Version
* 13/01/2011 J.Riyas Ahamad Basha HD1052460 MODIFY (LINE: 1)
*26 JUN 2011 Prabhu PACS00077651 added APELLIDOS.1
*09-07-2011 Sudharsanan S B.70 Issue Restricted in validation and commit level
* 21-11-2011 Sudharsanan S PACS00157018 If padrone interface is down then remove the error message and raise the override message in INPUT routine
*------------------------------------------------------------------------------------------------------------- *****
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.V.VAL.CED.IDENT.COMMON
    $INSERT JBC.h
*SJ start	;*Interface Change by Santiago-start
    $INSERT I_F.DFE.TRANSFORM
    $INSERT I_F.REDO.PADRON.WS
*SJ end	;*Interface Change by Santiago-end
    $USING APAP.REDOCHNLS
    GOSUB OPEN.FILES
    GOSUB CHECK.RNC.FORMAT
    IF NOT(OFS$BROWSER) THEN
        GOSUB PROCESS
    END ELSE
        IF OFS.VAL.ONLY EQ 1 AND MESSAGE EQ '' AND OFS$OPERATION EQ 'BUILD' THEN
            GOSUB PROCESS
        END
    END
RETURN
*-----------------------------------------------------------------------------
* The field value is present in the variable comi and collect the value in a
* temporary variable and calculate the length of it
*----------------------------------------------------
*----------
OPEN.FILES:
*----------
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*SJ start	;*Interface Change by Santiago-start
    FN.DFE.TRANSFORM = 'F.DFE.TRANSFORM'
    F.DFE.TRANSFORM = ''
    CALL OPF(FN.DFE.TRANSFORM,F.DFE.TRANSFORM)
*SJ end	;*Interface Change by Santiago-end
RETURN
*----------------
CHECK.RNC.FORMAT:
*-------------------------------------------------------------------------------------
* Check whether the length equal to nine.If not throw an error invalid document format
* If equal to nine perform check digit operation
*------------------------------------------------
    VAR.INTERFACE.RNC = '' ; POS.RNC = ''
    CALL GET.LOC.REF('CUSTOMER','L.CU.RNC',POS.RNC)
    Y.VAR.RNC=COMI
    VAR.RNC = Y.VAR.RNC
    Y.LEN.COUNT.RNC=LEN(Y.VAR.RNC)
    IF Y.VAR.RNC NE '' THEN
        IF Y.LEN.COUNT.RNC NE 9 THEN
            GOSUB CHECK.FORMAT
        END ELSE
            CHECK.NUMERIC = NUM(Y.VAR.RNC)
            IF CHECK.NUMERIC EQ 1 THEN
*CALL REDO.RNC.CHECK.DIGIT(Y.VAR.RNC)
*R22 MANUAL CONVERSION
*APAP.TAM.REDO.RNC.CHECK.DIGIT(Y.VAR.RNC) ;*R22 MANUAL CODE CONVERSION
                APAP.TAM.redoRncCheckDigit(Y.VAR.RNC) ;*R22 MANUAL CODE CONVERSION
            END ELSE
                GOSUB CHECK.FORMAT
            END
        END
    END
RETURN
************
PROCESS.OLD:	;*Interface Change by Santiago- changes "PROCESS" to "PROCESS.OLD"
*************
*------------------------------------------------------------------------------------
* Check the padrone interface for the given rnc values
*------------------------------------------------
    IF Y.VAR.RNC EQ 'PASS' THEN
        Cedule = "rnc$":VAR.RNC
        Param1 = "com.padrone.ws.util.MainClass"
        Param2 = "callPadrone"
        Param3 = Cedule
        Ret = ""
        ACTIVATION = "APAP_PADRONES_WEBSERVICES"
        INPUT_PARAM=Cedule
        ERROR.CODE = CALLJEE(ACTIVATION,INPUT_PARAM)
*PACS00157018 - S
        IF NOT(ERROR.CODE) THEN
            Ret=INPUT_PARAM
        END
*PACS00157018 - E
    END
    VAR.NAME = Ret
    INT.CODE = 'RNC'
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
    CHANGE '::' TO @FM IN VAR.NAME ;*R22 AUTO CONVERSION
    REC.CON = VAR.NAME<2>
    DESC = VAR.NAME<3>
    IF Ret THEN
        GOSUB PADRONE.CHECK
        IF APELLIDOS.1 THEN
            R.NEW(EB.CUS.NAME.1) = APELLIDOS.1
        END
        IF APELLIDOS.2 THEN
            R.NEW(EB.CUS.NAME.2) = APELLIDOS.2
        END
    END
RETURN
******************
PADRONE.CHECK.OLD:	;*Interface Change by Santiago- changes "PADRONE.CHECK" to "PADRONE.CHECK.OLD"
******************
*Checks for Success case and Failure Case
    CHANGE '$' TO '' IN VAR.NAME
    CHANGE '#' TO @FM IN VAR.NAME ;*R22 AUTO CONVERSION
    VAL.NAME = VAR.NAME<1>
    CHANGE ':' TO @FM IN VAL.NAME ;*R22 AUTO CONVERSION
    IF VAL.NAME<1> EQ 'SUCCESS' THEN
        APELLIDOS = VAR.NAME<3>
        APELLIDOS.1=APELLIDOS[1,35]
        IF LEN(APELLIDOS) GT 35 THEN
            DIFF = LEN(APELLIDOS) - 35
            APELLIDOS.2 = APELLIDOS[36,DIFF]
        END
    END
    IF VAL.NAME<1> EQ 'FAILURE' THEN
        GOSUB FAIL.PADRONE
    END
RETURN
;*Interface Change by Santiago-new lines added-start
************
PROCESS:
*************
*------------------------------------------------------------------------------------
* Check the padrone interface for the given rnc values
*------------------------------------------------
    IF Y.VAR.RNC EQ 'PASS' THEN
*        Cedule = "rnc$":VAR.RNC
        Cedule = VAR.RNC
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

        IF Y.RESPONSE EQ 'ERROR' OR Y.RESPONSE EQ '' THEN
            ERROR.CODE = 'REDO.V.VAL.CED.IDENT'
            ETEXT= "EB-JAVACOMP":@FM:ERROR.CODE
            CALL STORE.END.ERROR
        END
    END

    INT.CODE = 'RNC'
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
    REC.CON = Y.RESPONSE<7>
    DESC = Y.RESPONSE<8>
    GOSUB PADRONE.CHECK
    IF APELLIDOS.1 THEN
        R.NEW(EB.CUS.NAME.1) = APELLIDOS.1
    END
    IF APELLIDOS.2 THEN
        R.NEW(EB.CUS.NAME.2) = APELLIDOS.2
    END
RETURN
******************
PADRONE.CHECK:
******************
*Checks for Success case and Failure Case

    IF Y.RESPONSE<7> EQ 'SUCCESS' THEN
        APELLIDOS = Y.RESPONSE<2>
        APELLIDOS.1=APELLIDOS[1,35]
        IF LEN(APELLIDOS) GT 35 THEN
            DIFF = LEN(APELLIDOS) - 35
            APELLIDOS.2 = APELLIDOS[36,DIFF]
        END
    END
    IF VAL.NAME<1> EQ 'FAILURE' THEN
        GOSUB FAIL.PADRONE
    END
RETURN
;*Interface Change by Santiago-end
***************
FAIL.PADRONE:
***************
*Log Error by checking the Padrone Interface
    MON.TP = '04'
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*R22 MANUAL CONVERSION
*APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CODE CONVERSION
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)  ;*R22 MANUAL CODE CONVERSION
    
RETURN
*******************
CHECK.FORMAT:
*******************
    AF = EB.CUS.LOCAL.REF
    AV = POS.RNC
    ETEXT='EB-REDO.INVALID.DOC.FORMAT'
    CALL STORE.END.ERROR
RETURN
*---------------------------------------------------------------------
END
