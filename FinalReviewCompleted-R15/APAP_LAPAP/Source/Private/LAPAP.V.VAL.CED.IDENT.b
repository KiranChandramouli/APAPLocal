* @ValidationCode : MjotNTM4NDQ4ODM5OkNwMTI1MjoxNjk5NTIyNzQ3Nzc2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Nov 2023 15:09:07
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
SUBROUTINE LAPAP.V.VAL.CED.IDENT
*******************************************************************************************************************
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : APAP
*Date              : 14.02.2020
*Program   Name    : LAPAP.V.VAL.CED.IDENT
*------------------------------------------------------------------------------------------------------------------

*Description       : Basada en la logica de la rutina de TEMENOS: REDO.V.VAL.CED.IDENT This subroutine validates the customers age and check whether the customer is major or a minor
*Linked With       : This routine has to be attached as an input routine to the versions of CUSTOMER,REDO.OPEN.PROSP.PF.TEST &
*                    CUSTOMER,REDO.OPEN.CL.MINOR.TEST & CUSTOMER,REDO.OPEN.CLIENTE.PF.TEST & CUSTOMER,REDO.MOD.CL.MINOR.TEST
*                    CUSTOMER,REDO.ACT.MOD.CL.PF.TEST

*In  Parameter     : -NA-
*Out Parameter     : -NA-
*-------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*21-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,INSERT FILE MODIFIED
*21-04-2023              Samaran T                R22 Manual Code conversion                         CALL ROUTINE FORMAT MODIFIED
*06/10/2023		VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES      			Interface Change by Santiago
*----------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_BROWSER.TAGS
    $INSERT I_REDO.V.VAL.CED.IDENT.COMMON    ;*R22 AUTO CODE CONVERSION.END
    $INSERT JBC.h
*SJ start	;*Interface Change by Santiago-START-NEW LINES ADDED
    $INSERT I_F.DFE.TRANSFORM
    $INSERT I_F.REDO.PADRON.WS
*SJ end	;*Interface Change by Santiago-END
    $USING APAP.REDOCHNLS
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
    LREF.FIELDS = 'L.CU.CIDENT':@VM:'L.CU.TIPO.CL':@VM:'L.CUSTOMER.IMG':@VM:'L.CU.AGE':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@VM:'L.CU.DAT.END.CO'
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
    
*SJ start	;*Interface Change by Santiago-START-NEW LINES ADDED
    FN.DFE.TRANSFORM = 'F.DFE.TRANSFORM'
    F.DFE.TRANSFORM = ''
    CALL OPF(FN.DFE.TRANSFORM,F.DFE.TRANSFORM)
*SJ end	;*Interface Change by Santiago-END
RETURN
*-------------------------------------------------------------------------------------------------------------------
CHECK.CIDENT.FORMAT:
**********************
* The local reference field L.CU.CIDENT can take only 11 characters.If the length is less than 11 characters,
* then set the common variable, ETEXT to the error code, EB-INVALID.DOC.FORMAT.Else call subroutine LAPAP.S.CALC.DIGIT.PADRON
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

PROCESS.OLD:	;*Interface Change by Santiago- CHANGED "PROCESS" TO "PROCESS.OLD"
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
    CHANGE '::' TO @FM IN VAR.NAME
    REC.CON = VAR.NAME<2>
    DESC = VAR.NAME<3>
    IF Ret THEN
        GOSUB PADRONE.CHECK
        IF VAL.NAME<1> EQ 'FAILURE' THEN
            MON.TP = '04'
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)     ;*R22 MANUAL CODE CONVERSION
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
;*Interface Change by Santiago-START-NEW LINES ADDED
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
        Cedule = COMI
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

        IF Y.RESPONSE EQ 'ERROR' THEN
            INT.CODE = 'CIDENT'
            INT.TYPE = 'ONLINE'
            BAT.NO = ''
            BAT.TOT = ''
            INFO.OR = ''
            INFO.DE = ''
            ID.PROC = ''
            MON.TP = ''
            EX.USER = ''
            EX.PC = ''
            REC.CON = Y.INTRF.ID
            DESC = Y.INTRF.ID

            MON.TP = '04'
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)     ;*R22 MANUAL CODE CONVERSION

            IF COMI NE Y.LOC.SPARE THEN
                GOSUB CHECK.NAMES
            END
            Y.LOC.SPARE=COMI
            R.NEW(EB.CUS.LOCAL.REF)<1,REF.IMG>=IMAGENAME
               
            ERROR.CODE = 'LAPAP.VLVAL.CED.IDENT'
            ETEXT= "EB-JAVACOMP":@FM:ERROR.CODE
            CALL STORE.END.ERROR
            RETURN
        END
    END
    IF Y.L.CU.CIDENT EQ 'FAIL' THEN
        AF = EB.CUS.LOCAL.REF
        AV = CIDENT.POS
        ETEXT = 'EB-REDO.INCORRECT.CHECK.DIGIT'
        CALL STORE.END.ERROR
    END


    GOSUB PADRONE.CHECK
    IF VAL.NAME<1> EQ 'FAILURE' THEN
        

        RETURN
    END

    IF FLAG EQ '1' THEN
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

RETURN
***************
PADRONE.CHECK.OLD:	;*Interface Change by Santiago-CHANGED "PADRONE.CHECK" TO "PADRONE.CHECK.OLD"-END
****************
    CHANGE '$' TO '' IN VAR.NAME
    CHANGE '#' TO @FM IN VAR.NAME
    VAL.NAME = VAR.NAME<1>
    CHANGE ':' TO @FM IN VAL.NAME
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
;*Interface Change by Santiago-START-NEW LINES ADDED
***************
PADRONE.CHECK:
****************
* values obtained from the web service
*   IDENTI           = Y.RESPONSE<1>
*   NOMBRE           = Y.RESPONSE<2>
*   NOMBRE_COMPLETO  = Y.RESPONSE<3>
*   SEXO             = Y.RESPONSE<4>
*   FECHA_NACIMIENTO = Y.RESPONSE<5>
*   APELLIDOS        = Y.RESPONSE<6>
*   STATUS.CODE      = Y.RESPONSE<7>

    IF Y.RESPONSE<7> EQ 'SUCCESS' THEN
        IF VAL.TEXT EQ '' THEN
            APELLIDOS = Y.RESPONSE<6>
            FECHANACIMIENTO = Y.RESPONSE<5>
            NOMBRE = Y.RESPONSE<2>
            IMAGEPATH = ''  ;* SJ VAR.NAME<5> pending validate with APAP because this WS dont return IMAGEPATH
            SLASHC=DCOUNT(IMAGEPATH,'/')
            IMAGENAME=FIELD(IMAGEPATH,'/',SLASHC)
            C$SPARE(500) = "SUCCESS"
            FLAG = '1'
        END ELSE
            FLAG = '2'
        END
    END
RETURN
;*Interface Change by Santiago-END
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
    APAP.LAPAP.lapapSCalcDigitPadron(Y.L.CU.CIDENT)  ;*R22 MANUAL CODE CONVERSION
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
