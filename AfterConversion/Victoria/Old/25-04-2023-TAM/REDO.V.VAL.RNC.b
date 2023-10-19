$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
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
                CALL APAP.TAM.REDO.RNC.CHECK.DIGIT(Y.VAR.RNC)
            END ELSE
                GOSUB CHECK.FORMAT
            END
        END
    END
RETURN
************
PROCESS:
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
PADRONE.CHECK:
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
***************
FAIL.PADRONE:
***************
*Log Error by checking the Padrone Interface
    MON.TP = '04'
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*R22 MANUAL CONVERSION
    CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
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
