* @ValidationCode : MjotMTcxNTM2ODE5NTpDcDEyNTI6MTY4MDc3Mjc4MjMyMTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:49:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE NOFILE.REDO.DISP.RESTR.LIST(OUTPUT.ARRAY)
*------------------------------------------------------------------------------
* DATE        NAME                REFERENCE              DESCRIPTION
* 02-08-2011 Sudharsanan S        PACS00088610          INITIAL CREATION
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - SM to @SM and FM to @FM
* 06-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOFCFI to CALL
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.RESTRICTIVE.LIST

    GOSUB INIT
    GOSUB PROCESS
RETURN
******
INIT:
******
    FN.RESTR.LIST = 'F.REDO.RESTRICTIVE.LIST'
    F.RESTR.LIST = ''
    CALL OPF(FN.RESTR.LIST,F.RESTR.LIST)
RETURN
*********
PROCESS:
*********
    VALUE.BK = D.RANGE.AND.VALUE ;  OPERAND.BK = D.LOGICAL.OPERANDS ;  FIELDS.BK = D.FIELDS
    D.RANGE.AND.VALUE='' ; D.LOGICAL.OPERANDS=''; D.FIELDS=''
    CUS.APP.FLDS = 'TIPO.DE.PERSONA':@FM:'TIPO.DE.DOCUMENTO':@FM:'NUMERO.DOCUMENTO':@FM:'NOMBRES':@FM:'APELLIDOS':@FM:'RAZON.SOCIAL':@FM:'NACIONALIDAD'
    CUS.APP.FLDS:=  @FM:'LISTA.RESTRICTIVA'
    LOOP
        REMOVE APP.FLD FROM CUS.APP.FLDS SETTING CUS.FLD.POS
    WHILE APP.FLD:CUS.FLD.POS
        LOCATE APP.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            VAR.FIELD.VAL         = FIELDS.BK<POS1>
            VAR.VALUE             = VALUE.BK<POS1>
            IF VAR.FIELD.VAL EQ 'TIPO.DE.PERSONA' THEN
                GOSUB CHECK.PERSONA
            END
            IF VAR.FIELD.VAL EQ 'LISTA.RESTRICTIVA' THEN
                GOSUB CHECK.LISTA
            END
            D.RANGE.AND.VALUE<-1>= VAR.VALUE
            D.LOGICAL.OPERANDS<-1>=OPERAND.BK<POS1>
            D.FIELDS<-1>=FIELDS.BK<POS1>
        END
    REPEAT
    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.RESTR.LIST
        CALL APAP.REDOENQ.REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.CUS.CMD)   ;*R22 Manual Conversion - Added APAP.REDOENQ
        SEL.CMD1 = SEL.CUS.CMD:" AND (LISTA.RESTRICTIVA NE 'CLIENTE NO DESEADO EN APAP') AND (LISTA.RESTRICTIVA NE 'POLICIA NACIONAL')"
    END ELSE
        SEL.CMD1 = "SELECT ":FN.RESTR.LIST:" WITH (LISTA.RESTRICTIVA NE 'CLIENTE NO DESEADO EN APAP') AND (LISTA.RESTRICTIVA NE 'POLICIA NACIONAL')"
    END
    CALL EB.READLIST(SEL.CMD1,SEL.LIST,'',NOR,SEL.ERR)
    Y.SEL.COUNT = DCOUNT(SEL.LIST,@FM)
    Y.SEL.CT.LOOP = 1
    LOOP
    WHILE Y.SEL.CT.LOOP LE Y.SEL.COUNT
        CUST.ID = SEL.LIST<Y.SEL.CT.LOOP>
        R.RESTR.LIST                     = '' ; CUST.ERR      = ''
        CALL F.READ(FN.RESTR.LIST,CUST.ID,R.RESTR.LIST,F.RESTR.LIST,CUST.ERR)
        GOSUB PROCESS.EXTRACT
        Y.SEL.CT.LOOP + =1
    REPEAT
RETURN
*****************
PROCESS.EXTRACT:
*****************
    Y.TIPO.DE.PERSONA   = R.RESTR.LIST<RESTR.LIST.TIPO.DE.PERSONA>
    Y.TIPO.DE.DOC       = R.RESTR.LIST<RESTR.LIST.TIPO.DE.DOCUMENTO>
    Y.NUMERO.DOC        = R.RESTR.LIST<RESTR.LIST.NUMERO.DOCUMENTO>
    Y.NOMBERS           = R.RESTR.LIST<RESTR.LIST.NOMBRES>
    Y.APELLIDOS         = R.RESTR.LIST<RESTR.LIST.APELLIDOS>
    Y.RAZON.SOCIAL      = R.RESTR.LIST<RESTR.LIST.RAZON.SOCIAL>
    Y.NACIONALIDAD      = R.RESTR.LIST<RESTR.LIST.NACIONALIDAD>
    Y.LISTA.RESTR       = R.RESTR.LIST<RESTR.LIST.LISTA.RESTRICTIVA>
    Y.OVERRIDE          = R.RESTR.LIST<RESTR.LIST.OVERRIDE>
    VAR.SEP = "*"

    OUTPUT.ARRAY<-1> = Y.TIPO.DE.PERSONA:VAR.SEP:Y.TIPO.DE.DOC:VAR.SEP:Y.NUMERO.DOC:VAR.SEP:Y.NOMBERS:VAR.SEP:Y.APELLIDOS:VAR.SEP:Y.RAZON.SOCIAL
    OUTPUT.ARRAY:= VAR.SEP:Y.NACIONALIDAD:VAR.SEP:Y.LISTA.RESTR:VAR.SEP:Y.OVERRIDE
RETURN
****************
CHECK.PERSONA:
****************
    SM.CNT = DCOUNT(VAR.VALUE,@SM)
    IF SM.CNT GT 1 THEN
        FINDSTR '.' IN VAR.VALUE<1,1,1> SETTING POS.SM THEN
            VAR.VALUE = FIELDS(VAR.VALUE,'.',4,1)
            CHANGE @SM TO ' ' IN VAR.VALUE
            VAR.VALUE = '...':VAR.VALUE:'...'
        END ELSE
            CHANGE @SM TO ' ' IN VAR.VALUE
        END
    END
RETURN
*************
CHECK.LISTA:
*************
    SM.CNT = DCOUNT(VAR.VALUE,@SM)
    IF SM.CNT GT 1 THEN
        FINDSTR '.' IN VAR.VALUE<1,1,1> SETTING POS.SM THEN
            VAR.VALUE = FIELDS(VAR.VALUE,'.',4,1)
            CHANGE @SM TO '.' IN VAR.VALUE
            VAR.VALUE = '...':VAR.VALUE:'...'
        END
    END
RETURN
*********************************************************************************************************************************************************************
END
