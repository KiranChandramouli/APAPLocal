* @ValidationCode : MjotMjA2MDEwMjc4NTpDcDEyNTI6MTY4NDQ5MTA0NTYwNzpJVFNTOi0xOi0xOjExNjoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 116
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM, FM TO @FM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.V.VAL.CED.IDENT
*******************************************************************************************************************
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : P.ANAND(anandp@temenos.com)
*Date              : 26.10.2009
*Program   Name    : REDO.V.VAL.CED.IDENT
*------------------------------------------------------------------------------------------------------------------

*Description       : This subroutine validates the customers age and check whether the customer is major or a minor
*Linked With       : This routine has to be attached as an input routine to the versions of CUSTOMER,REDO.OPEN.PROSP.PF.TEST &
*                    CUSTOMER,REDO.OPEN.CL.MINOR.TEST & CUSTOMER,REDO.OPEN.CLIENTE.PF.TEST & CUSTOMER,REDO.MOD.CL.MINOR.TEST
*                    CUSTOMER,REDO.ACT.MOD.CL.PF.TEST

*In  Parameter     : -NA-
*Out Parameter     : -NA-
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
* 29/10/2009           R.Ganesh               ODR-2009-10-0807      Initial Version
* 13/01/2011         J.Riyas Ahamad Basha       HD1052460           MODIFY (LINE: 1)
* 05-MAR-2010         Prabhu N                                      Part added to populate customer name based on data returned from interface
*                                                                   C$SPARE removed and VAL.TEXT added
* 07-Jun-2011        Shankar Raju                CR.008             Format the date accordingly when it's retrieved from Web-Service/Database
* 22-Jun-2011        Shankar Raju           B.70 - PACS00023920     Assigning Null values to names restricted only of the CIDENT values changed
* 23-JUL-2011        Sudharsanan S                B.70              Restrict the validation in the field level(hot.field) and nullify the names details once cident value is removed from table
* 27-NOV-2011        Sudharsanan S            PACS00157018          If padrone interface is down then remove the error message and raised the override msg in INPUT level routines
* 22-04-2013 MG PACS00260090

*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_BROWSER.TAGS
    $INSERT I_REDO.V.VAL.CED.IDENT.COMMON
    $INSERT JBC.h
    $USING APAP.REDOCHNLS
    $USING APAP.REDOSRTN
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB CHECK.CIDENT.FORMAT

    IF NOT(OFS$BROWSER) THEN
        GOSUB PROCESS
    END ELSE
        IF OFS.VAL.ONLY EQ 1 AND MESSAGE EQ '' AND OFS$OPERATION EQ 'BUILD' AND OFS$HOT.FIELD EQ 'L.CU.CIDENT' THEN
            GOSUB PROCESS
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------
INIT:
*****
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    LOC.INTERFACE = ''
    FLAG.SET = 1  ; FLAG = ''
    LREF.FIELDS = 'L.CU.CIDENT':@VM:'L.CU.TIPO.CL':@VM:'L.CUSTOMER.IMG':@VM:'L.CU.AGE':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@VM:'L.CU.DAT.END.CO' ;*R22 AUTO CONVERSION
    Y.LREF.POS = ''
    CALL MULTI.GET.LOC.REF('CUSTOMER',LREF.FIELDS,Y.LREF.POS)
    CIDENT.POS = Y.LREF.POS<1,1>
    TIPO.POS= Y.LREF.POS<1,2>
    REF.IMG= Y.LREF.POS<1,3>
    AGE.POS = Y.LREF.POS<1,4>
    NOUN.POS  = Y.LREF.POS<1,5>
    ACT.POS   = Y.LREF.POS<1,6>
    DAT.END = Y.LREF.POS<1,7>
    Y.TIPO.CL = R.NEW(EB.CUS.LOCAL.REF)<1,TIPO.POS>
    CIDENT.OLD = R.OLD(EB.CUS.LOCAL.REF)<1,CIDENT.POS>
    CIDENT.NEW = R.NEW(EB.CUS.LOCAL.REF)<1,CIDENT.POS>
    NOUN.NEW  = R.NEW(EB.CUS.LOCAL.REF)<1,NOUN.POS>
    ACT.NEW  = R.NEW(EB.CUS.LOCAL.REF)<1,ACT.POS>
    LEGAL.NEW = R.NEW(EB.CUS.LEGAL.ID)<1,1>
    VAR.CURR.NO  = R.NEW(EB.CUS.CURR.NO)
RETURN
*-------------------------------------------------------------------------------------------------------------------
OPEN.FILES:
***********
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN
*-------------------------------------------------------------------------------------------------------------------
CHECK.CIDENT.FORMAT:
**********************
* The local reference field L.CU.CIDENT can take only 11 characters.If the length is less than 11 characters,
* then set the common variable, ETEXT to the error code, EB-INVALID.DOC.FORMAT.Else call subroutine REDO.S.CALC.CHECK.DIGIT
* If the returned value is FAIL, then set  ETEXT as 'EB-REDO.INCORRECT.CHECKDIGIT'
*---------------------------------------------------------------------------------------------------------------------

    Y.L.CU.CIDENT = COMI

    Y.LEN.L.CU.CIDENT = LEN(Y.L.CU.CIDENT)
    IF Y.L.CU.CIDENT NE '' THEN
        IF Y.LEN.L.CU.CIDENT NE 11 AND Y.LEN.L.CU.CIDENT THEN
            GOSUB CHECK.COUNT
        END
        IF Y.LEN.L.CU.CIDENT EQ 11 THEN
            CHECK.NUMERIC  = NUM(Y.L.CU.CIDENT)
            IF CHECK.NUMERIC EQ 1 THEN
                GOSUB CHECK.DIGIT
            END ELSE
                GOSUB CHECK.COUNT
            END
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------
PROCESS:
*******
* This para is used to check the given value s available in PADRONE Interface
*----------------------------------------------------------------------------------------------------------------------
    IF Y.L.CU.CIDENT EQ '' AND OFS$BROWSER THEN
        Y.LOC.SPARE=''
        GOSUB CHECK.NAMES
        RETURN
    END
    IF Y.L.CU.CIDENT EQ 'PASS' THEN
        Cedule = "padrone$":COMI
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
    IF Y.L.CU.CIDENT EQ 'FAIL' THEN
        AF = EB.CUS.LOCAL.REF
        AV = CIDENT.POS
        ETEXT = 'EB-REDO.INCORRECT.CHECK.DIGIT'
        CALL STORE.END.ERROR
    END
    VAR.NAME = Ret
    INT.CODE = 'CIDENT'
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
        IF VAL.NAME<1> EQ 'FAILURE' THEN
            MON.TP = '04'
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*R22 MANUAL CONVERSION
*CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CODE CONVERSION
            CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CODE CONVERSION
         
            IF COMI NE Y.LOC.SPARE THEN
                GOSUB CHECK.NAMES
            END
            Y.LOC.SPARE=COMI
            R.NEW(EB.CUS.LOCAL.REF)<1,REF.IMG>=IMAGENAME
            RETURN
        END

        IF FLAG EQ '1' THEN
* Changes for CR.008 - Format the date accordingly when it's retrieved from Web-Service/Database - Start
            FINDSTR "-" IN FECHANACIMIENTO SETTING POS1 THEN
                YEAR = FIELD(FECHANACIMIENTO,'-',1)
                MONTH = FIELD(FECHANACIMIENTO,'-',2)
                Y.DATE = FIELD(FECHANACIMIENTO,'-',3)
                Y.DATE = FIELD(Y.DATE,' ',1)
            END ELSE
                YEAR = FIELD(FECHANACIMIENTO,'/',3)
                MONTH = FIELD(FECHANACIMIENTO,'/',2)
                Y.DATE = FIELD(FECHANACIMIENTO,'/',1)
            END
* Changes for CR.008 - Format the date accordingly when it's retrieved from Web-Service/Database - End
            R.NEW(EB.CUS.DATE.OF.BIRTH)= YEAR:MONTH:Y.DATE
            R.NEW(EB.CUS.FAMILY.NAME)=APELLIDOS
            R.NEW(EB.CUS.GIVEN.NAMES)=NOMBRE
            R.NEW(EB.CUS.LOCAL.REF)<1,REF.IMG>=IMAGENAME
        END
        IF FLAG.SET EQ 1 THEN
            VAR.APELLIDOS = R.NEW(EB.CUS.FAMILY.NAME)
            VAR.NOMBRE = R.NEW(EB.CUS.GIVEN.NAMES)
            IF Y.TIPO.CL NE 'PERSONA JURIDICA' THEN
                R.NEW(EB.CUS.NAME.1)= VAR.NOMBRE:" ":VAR.APELLIDOS
            END
        END
    END
RETURN
***************
PADRONE.CHECK:
****************
    CHANGE '$' TO '' IN VAR.NAME
    CHANGE '#' TO @FM IN VAR.NAME ;*R22 AUTO CONVERSION
    VAL.NAME = VAR.NAME<1>
    CHANGE ':' TO @FM IN VAL.NAME ;*R22 AUTO CONVERSION
    IF VAL.NAME<1> EQ 'SUCCESS' THEN
        IF VAL.TEXT EQ '' THEN
            APELLIDOS = VAR.NAME<2>
            FECHANACIMIENTO = VAR.NAME<3>
* NOMBRE = VAR.NAME<5>
            NOMBRE = VAR.NAME<4>
* IMAGEPATH=VAR.NAME<8>
            IMAGEPATH=VAR.NAME<5>
            SLASHC=DCOUNT(IMAGEPATH,'/')
            IMAGENAME=FIELD(IMAGEPATH,'/',SLASHC)
            C$SPARE(500) = "SUCCESS"
            FLAG = '1'
        END ELSE
            FLAG = '2'
        END
    END
RETURN
************
CHECK.COUNT:
************
    AF = EB.CUS.LOCAL.REF
    AV = CIDENT.POS
    ETEXT = 'EB-REDO.INVALID.DOC.FORMAT'
    CALL STORE.END.ERROR
RETURN
************
CHECK.DIGIT:
************
    VAR.CED=Y.L.CU.CIDENT
*CALL REDO.S.CALC.CHECK.DIGIT(Y.L.CU.CIDENT)
*R22 MANUAL CONVERSION
*CALL APAP.REDOSRTN.REDO.S.CALC.CHECK.DIGIT(Y.L.CU.CIDENT) ;*R22 MANUAL CODE CONVERSION
    CALL APAP.REDOSRTN.redoSCalcCheckDigit(Y.L.CU.CIDENT) ;*R22 MANUAL CODE CONVERSION
    
RETURN
*************
CHECK.NAMES:
*************
    IF OFS$BROWSER THEN
        R.NEW(EB.CUS.DATE.OF.BIRTH)= ''
    END
    R.NEW(EB.CUS.FAMILY.NAME)= ''
    R.NEW(EB.CUS.GIVEN.NAMES)= ''
    R.NEW(EB.CUS.LOCAL.REF)<1,AGE.POS>= ''
    FLAG.SET = ''
RETURN
*-------------------------------------------------------------------------
END
*------------------------------------------------------------------------
