*-----------------------------------------------------------------------------
* <Rating>-109</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.INP.PJ.CUST.RTN
*******************************************************************************************************************
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : P.ANAND(anandp@temenos.com)
*Date              : 26.10.2009
*Program   Name    : REDO.V.INP.CUST.RTN
*------------------------------------------------------------------------------------------------------------------
*Description       : This subroutine validates the customer's age and check whether the customer is major or a minor
*Linked With       : This routine has to be attached as an input routine to the versions of CORPORATE CUSTOMER
*In  Parameter     : -NA-
*Out Parameter     : -NA-
*-----------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
* 29/10/2009           R.Ganesh               ODR-2009-10-0807         Initial Version
* 13/01/2011         J.Riyas Ahamad Basha       HD1052468              MODIFY (LINE: 127 AND 134)
* 09-MAR-2010        Prabhu N                   HD1053255              Line 128 Modified,Age checking added for Persona Fisica also
* 23-MAY-2011        Marimuthu S                PACS00060200           Line 132 Modified
* 21-NOV-2011        S.SUDHARSANAN              PACS00157018           Raise the override message if padrone interface is down
* 15-NOV-2017        GOPALA KRISHNAN R          PACS00635391           Prospect using the CLIENTEPJMOD, the Customer Type
*                                                                      is expected to be as “ACTIVE” and not as “PROSPECT”.
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.V.VAL.CED.IDENT.COMMON
    $INSERT JBC.h
*------------------------------------------------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

    RETURN
*-------------------------------------------------------------------------------------------------------------------
INIT:
******
* This block initialise the local fields and variables used
    Y.PGM.VERSION = PGM.VERSION
    FLAG = 1  ; FLAG.ACT = 1 ; FLAG.NOUN = 1 ; FLAG.LEGAL = 1 ;FLAG.OVERRIDE = ''
    LREF.FIELDS = 'L.CU.CIDENT':VM:'L.CU.NOUNICO':VM:'L.CU.RNC':VM:'L.CU.ACTANAC':VM:'L.CU.AGE':VM:'L.CU.TIPO.CL':VM:'L.APAP.INDUSTRY'
    Y.LREF.POS = ''
    CALL MULTI.GET.LOC.REF('CUSTOMER',LREF.FIELDS,Y.LREF.POS)
    Y.L.CU.CIDENT.POS = Y.LREF.POS<1,1>
    Y.L.CU.NOUNICO.POS = Y.LREF.POS<1,2>
    Y.L.CU.RNC.POS = Y.LREF.POS<1,3>
    Y.L.CU.ACTANAC.POS = Y.LREF.POS<1,4>
    Y.L.CU.AGE.POS = Y.LREF.POS<1,5>
    Y.L.CU.TIPO.CL.POS = Y.LREF.POS<1,6>
    Y.L.CU.CIDENT = R.NEW(EB.CUS.LOCAL.REF)<1,Y.L.CU.CIDENT.POS>
    Y.L.CU.NOUNICO = R.NEW(EB.CUS.LOCAL.REF)<1,Y.L.CU.NOUNICO.POS>
    Y.L.CU.RNC = R.NEW(EB.CUS.LOCAL.REF)<1,Y.L.CU.RNC.POS>
    Y.L.CU.ACTANAC = R.NEW(EB.CUS.LOCAL.REF)<1,Y.L.CU.ACTANAC.POS>
    Y.LEGAL.ID = R.NEW(EB.CUS.LEGAL.ID)<1,1>
    VAR.TIPO.CL = R.NEW(EB.CUS.LOCAL.REF)<1,Y.L.CU.TIPO.CL.POS>
    Y.NATIONALITY = R.NEW(EB.CUS.NATIONALITY)
    Y.APAP.INDUS.POS = Y.LREF.POS<1,7>
    Y.INDUSTRY = R.NEW(EB.CUS.LOCAL.REF)<1,Y.APAP.INDUS.POS>
    RETURN
*-------------------------------------------------------------------------------------------------------------------
OPEN.FILES:
***********
* This block open the CUSTOMER file
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    RETURN
*-------------------------------------------------------------------------------------------------------------------
PROCESS:
********
* This block checks the basic validation for creating and modifing the corporate customer
    GOSUB CHK.SECT.INDUS
    GOSUB CHK.CUS.TYPE
    GOSUB CHECK.OVERRIDE
    RETURN
*-------------------------------------------------------------------------------------------------------------------
CHK.SECT.INDUS:
***************
* This block checks CUSTOMER.TYPE is ACTIVE or BLANK.If yes,then check field L.CU.TIPO.CL value is equal to
* "PERSONA FISICA" or "PERSONA JURIDICA" and if yes then check whether the SECTOR field value is 9999 or the INDUSTRY field value
* is 9999, and if yes, then set the error variable ETEXT to "EB-REDO.VALOR.NO VALIDO"
    Y.SECTOR = R.NEW(EB.CUS.SECTOR)
*   Y.INDUSTRY = R.NEW(EB.CUS.INDUSTRY)
    Y.CUSTOMER.TYPE = R.NEW(EB.CUS.CUSTOMER.TYPE)
    IF (Y.CUSTOMER.TYPE EQ 'ACTIVE' OR Y.CUSTOMER.TYPE EQ '') AND ( VAR.TIPO.CL EQ 'PERSONA FISICA' OR VAR.TIPO.CL EQ 'PERSONA JURIDICA' ) AND ( Y.SECTOR EQ '9999') THEN
        AF = EB.CUS.SECTOR
        ETEXT = 'EB-REDO.VAL.OR.NO.VALIDO'
        CALL STORE.END.ERROR
        FLAG = ''
    END
    IF (Y.CUSTOMER.TYPE EQ 'ACTIVE' OR Y.CUSTOMER.TYPE EQ '') AND ( VAR.TIPO.CL EQ 'PERSONA FISICA' OR VAR.TIPO.CL EQ 'PERSONA JURIDICA' ) AND ( Y.INDUSTRY EQ '9999') THEN
*       AF = EB.CUS.INDUSTRY
*       AF = L.APAP.INDUSTRY
        AF = EB.CUS.LOCAL.REF<1,Y.APAP.INDUS.POS>
        ETEXT = 'EB-REDO.VAL.OR.NO.VALIDO'
        CALL STORE.END.ERROR
        FLAG = ''
    END
    RETURN
*-------------------------------------------------------------------------------------------------------------------
CHK.CUS.TYPE:
*************
* This is for defaulting the CUSTOMER.SINCE field for certain types of customers
* If CUSTOMER.TYPE is equal to PROSPECT then return from this paragraph
* Else check the field CUSTOMER.SINCE.If it has no value then assign TODAY to CUSTOMER.SINCE

    Y.CUSTOMER.TYPE = R.NEW(EB.CUS.CUSTOMER.TYPE)
    Y.CUSTOMER.SINCE = R.NEW(EB.CUS.CUSTOMER.SINCE)
    IF Y.CUSTOMER.TYPE EQ 'PROSPECT' THEN
*PACS00635391 - S
        R.NEW(EB.CUS.CUSTOMER.TYPE) = 'ACTIVE'
*PACS00635391 - E
    END ELSE
        IF Y.CUSTOMER.SINCE EQ '' THEN
            R.NEW(EB.CUS.CUSTOMER.SINCE) = TODAY
        END
    END
    RETURN
*-------------------------------------------------------------------------------------------------------------------
CHECK.OVERRIDE:
*----------------------------------------------------------------------------------------------------------------------
    IF FLAG EQ 1 AND NOT(OFS.VAL.ONLY) AND OFS$OPERATION EQ 'PROCESS' THEN
        IF Y.L.CU.CIDENT THEN
            Cedule = "padrone$":Y.L.CU.CIDENT
            INT.CODE = 'CIDENT'
            GOSUB CHK.PADRONE
            IF FLAG.OVERRIDE EQ 1 AND VAR.TIPO.CL NE 'PERSONA JURIDICA' THEN
                TEXT = "REPO.PADR.PF"
                CURR.NO = DCOUNT(R.NEW(EB.CUS.OVERRIDE),VM)+1
                CALL STORE.OVERRIDE(CURR.NO)
            END
        END
        IF Y.L.CU.RNC THEN
            Cedule = "rnc$":Y.L.CU.RNC
            INT.CODE = 'RNC'
            GOSUB CHK.PADRONE
            IF FLAG.OVERRIDE EQ 1 AND VAR.TIPO.CL EQ 'PERSONA JURIDICA' THEN
                TEXT = "REPO.PADR.PJ"
                CURR.NO = DCOUNT(R.NEW(EB.CUS.OVERRIDE),VM)+1
                CALL STORE.OVERRIDE(CURR.NO)
            END
        END
    END
    RETURN
*-------------------------------------------------------------------------------------------------------------------
CHK.PADRONE:
*--------------------------------------------------------------------------------------------------------------------
*Raising override if the given value is not availble in padrone interface
    Param1 = "com.padrone.ws.util.MainClass"
    Param2 = "callPadrone"
    Param3 = Cedule
    Ret = ""
    ACTIVATION = "APAP_PADRONES_WEBSERVICES"
    INPUT_PARAM=Cedule
    ERROR.CODE = CALLJEE(ACTIVATION,INPUT_PARAM)
*PACS00157018 - S
    IF ERROR.CODE THEN
*********TEXT = "REDO.CHECK.PADRONE"
*********CURR.NO = DCOUNT(R.NEW(EB.CUS.OVERRIDE),VM)+1
*********CALL STORE.OVERRIDE(CURR.NO)
*********ETEXT= "FAIL@FM":ERROR.CODE
*********CALL STORE.END.ERROR
    END ELSE
        Ret=INPUT_PARAM
    END
*PACS00157018 - E
    VAR.NAME = Ret
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
    CHANGE '::' TO FM IN VAR.NAME
    REC.CON = VAR.NAME<2>
    DESC = VAR.NAME<3>
    IF Ret THEN
        GOSUB PADRONE.CHECK
    END
    RETURN
*--------------------------------------------------------------------------------------------------------------------
PADRONE.CHECK:
*--------------------------------------------------------------------------------------------------------------------
    CHANGE '$' TO '' IN VAR.NAME
    CHANGE '#' TO FM IN VAR.NAME
    VAL.NAME = VAR.NAME<1>
    CHANGE ':' TO FM IN VAL.NAME
    IF VAL.NAME<1> EQ 'SUCCESS' ELSE
        IF VAL.NAME<1> EQ 'FAILURE' THEN
            GOSUB FAIL.PADRONE
        END
    END
    RETURN
*--------------------------------------------------------------------------------------------------------------------
FAIL.PADRONE:
*------------------------------------------------------------------------------------------------------------------------

    CHECK.FAIL.MSG  = VAR.NAME<2>
    CHECK.ERROR.CODE = FIELD(CHECK.FAIL.MSG,'-',1)
    ERROR.CODE.VALUE = TRIM(FIELD(CHECK.ERROR.CODE,':',2), "", 'A')
    IF ERROR.CODE.VALUE EQ '019' THEN
        TEXT = "REDO.CHECK.RNC.PADRONE"
        CURR.NO = DCOUNT(R.NEW(EB.CUS.OVERRIDE),VM)+1
        CALL STORE.OVERRIDE(CURR.NO)

        MON.TP = '08'
        DESC = 'El webservices no esta disponible'
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)

    END ELSE
        FLAG.OVERRIDE = 1
        MON.TP = '04'
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END
    RETURN
*-------------------------------------------END OF RECORD---------------------------------------------------------
END
