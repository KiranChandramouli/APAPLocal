* @ValidationCode : MjotMTk0NTcxMzA3MDpDcDEyNTI6MTY4MjU5ODAxMTYwODpzYW1hcjotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.A.SYNC.MASTER.DATA
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.04.2013
* Description  : Routine for synch master data
* Type         : Auth Routine
* Attached to  : VERSION > CUSTOMER Vision Plus Versions
* Dependencies :
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $USING APAP.TAM
    $USING APAP.REDOSRTN
    

* </region>

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
    Y.LOCAL.REF = 'LOCAL.REF'

    Y.LOCAL.FIELDS = ''
    Y.LOCAL.FIELDS.POS = ''

    Y.LOCAL.FIELDS<1,1> = 'L.CU.TIPO.CL'
    Y.LOCAL.FIELDS<1,2> = 'L.CU.CIDENT'
    Y.LOCAL.FIELDS<1,3> = 'L.CU.RNC'
    Y.LOCAL.FIELDS<1,4> = 'L.CU.RES.SECTOR'
    Y.LOCAL.FIELDS<1,5> = 'L.CU.URB.ENS.RE'
    Y.LOCAL.FIELDS<1,6> = 'L.CU.TEL.TYPE'
    Y.LOCAL.FIELDS<1,7> = 'L.CU.TEL.AREA'
    Y.LOCAL.FIELDS<1,8> = 'L.CU.TEL.NO'
    Y.LOCAL.FIELDS<1,9> = 'L.CU.TEL.EXT'
    Y.LOCAL.FIELDS<1,10> = 'L.APAP.INDUSTRY'

    CALL EB.FIND.FIELD.NO(APPLICATION, Y.LOCAL.REF)
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    CU.TIPO.CL.POS = Y.LOCAL.FIELDS.POS<1,1>
    CU.CIDENT.POS = Y.LOCAL.FIELDS.POS<1,2>
    CU.RNC.POS = Y.LOCAL.FIELDS.POS<1,3>
    CU.RES.SECTOR.POS = Y.LOCAL.FIELDS.POS<1,4>
    CU.URB.ENS.RE.POS = Y.LOCAL.FIELDS.POS<1,5>
    CU.TEL.TYPE.POS = Y.LOCAL.FIELDS.POS<1,6>
    CU.TEL.AREA.POS = Y.LOCAL.FIELDS.POS<1,7>
    CU.TEL.NO.POS = Y.LOCAL.FIELDS.POS<1,8>
    CU.TEL.EXT.POS = Y.LOCAL.FIELDS.POS<1,9>
    CU.APAP.INDUSTRY = Y.LOCAL.FIELDS.POS<1,10>

    BLANK.DELIM = '*'
    NAME.PRE = ''

RETURN

***********************
* Open Files
OPEN.FILES:
***********************

RETURN

***********************
* Main Process
PROCESS:
***********************
    ACTIVATION = 'VP_MASTER_DATA'

    GOSUB SET.RECORD.ID
    GOSUB SET.CUST.ID
    GOSUB SET.CUST.NAT.ID
    GOSUB SET.CUST.DATA
    CRT "ACTIVATION: ":ACTIVATION
    CRT "WS.DATA: ":WS.DATA

* Invoke VisionPlus Web Service
*APAP.TAM.REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)
    APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA);* MANUAL R22 CODE CONVERSION

    IF WS.DATA<1> NE "OK" THEN
* Log writing: abnormal error that must be notified
*APAP.REDOSRTN.REDO.S.NOTIFY.INTERFACE.ACT('VPL002', 'ONLINE', '04', 'EMAIL ERROR ARCHIVO NO MONETARIO [' : WS.DATA<1> : '] - ' : WS.DATA<2>, 'REVISAR EN LOG $JBOSS_HOME\server\default\log\server.log ERROR EN ARCHIVO NO MONETARIO A LAS ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '')
        APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL002', 'ONLINE', '04', 'EMAIL ERROR ARCHIVO NO MONETARIO [' : WS.DATA<1> : '] - ' : WS.DATA<2>, 'REVISAR EN LOG $JBOSS_HOME\server\default\log\server.log ERROR EN ARCHIVO NO MONETARIO A LAS ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '')  ;* MANUAL R22 CODE CONVERSION
        TEXT = "ST-VP-NO.INSERT.MD"
        IF R.NEW(EB.CUS.OVERRIDE) THEN
            Y.OV.POS = DCOUNT(R.NEW(EB.CUS.OVERRIDE), @VM) + 1
        END ELSE
            Y.OV.POS = 1
        END
        CALL STORE.OVERRIDE(Y.OV.POS)
    END

RETURN

**********************
* Set record ID values
SET.RECORD.ID:
**********************
* msth: how to set Category when multiple buckets can be matched ?
* msth: e.g. 01 Company 05 Misc 06 Additional fields

    WS.DATA = ''
* secuencia
* solicitud
* tipo_registro
    WS.DATA<1> = '0000000000001'
    Y.SEQ = ID.NEW : R.NEW(EB.CUS.CURR.NO)
    WS.DATA<2> = Y.SEQ[-5,5]
    WS.DATA<3> = 'M'

RETURN

************************
* Set Customer ID values
SET.CUST.ID:
************************
* categoria
* tipo_cuenta
* nombre_cliente_linea1
* nombre_cliente_linea2
* sexo
* fecha_nacimiento
    Y.CATEGORIA = R.NEW(Y.LOCAL.REF)<1,CU.TIPO.CL.POS>

    IF Y.CATEGORIA EQ 'PERSONA FISICA' THEN
        WS.DATA<4> = '02'
        WS.DATA<5> = 'P'
        NAME.PRE = R.NEW(EB.CUS.GIVEN.NAMES)
        GOSUB FILTER.NAME.STRING
        WS.DATA<9> = NAME.POST[1,40]
        WS.DATA<10> = R.NEW(EB.CUS.FAMILY.NAME)[1,40]
        Y.GENDER = R.NEW(EB.CUS.GENDER)
        WS.DATA<25> = '0'
        IF Y.GENDER EQ 'MALE' THEN
            WS.DATA<25> = '1'
        END
        IF Y.GENDER EQ 'FEMALE' THEN
            WS.DATA<25> = '2'
        END
        WS.DATA<26> = R.NEW(EB.CUS.DATE.OF.BIRTH)
    END

    IF Y.CATEGORIA EQ 'PERSONA JURIDICA' THEN
        WS.DATA<4> = '01'
        WS.DATA<5> = 'C'
        NAME.PRE = R.NEW(EB.CUS.NAME.1)
        GOSUB FILTER.NAME.STRING
        WS.DATA<9> = NAME.POST[1,40]
        WS.DATA<10> = ''
        WS.DATA<25> = '0'
        WS.DATA<26> = R.NEW(EB.CUS.LEGAL.ISS.DATE)
    END

    IF WS.DATA<26> EQ '' THEN
        WS.DATA<26> = 0
    END

RETURN

**************************
* Set Customer national ID
SET.CUST.NAT.ID:
**************************

* id_cliente
    WS.DATA<6> = ID.NEW
    Y.TIPO.IDENT.CA  = R.NEW(Y.LOCAL.REF)<1,CU.CIDENT.POS>
    Y.TIPO.IDENT.PA  = R.NEW(EB.CUS.LEGAL.ID)
    Y.TIPO.IDENT.RNC = R.NEW(Y.LOCAL.REF)<1,CU.RNC.POS>

    IF Y.TIPO.IDENT.CA THEN
        WS.DATA<7> = 'CA'
        WS.DATA<8> = Y.TIPO.IDENT.CA[1,20]
    END
    IF Y.TIPO.IDENT.PA THEN
        WS.DATA<7> = 'PA'
        WS.DATA<8> = Y.TIPO.IDENT.PA[1,20]
    END
    IF Y.TIPO.IDENT.RNC THEN
        WS.DATA<7> = 'RNC'
        WS.DATA<8> = Y.TIPO.IDENT.RNC[1,20]
    END
    IF TRIM(WS.DATA<5>) EQ '' THEN
        WS.DATA<7> = STR(BLANK.DELIM,3)
        WS.DATA<8> = STR(BLANK.DELIM,20)
    END

RETURN

*************************
* Set Customer other data
SET.CUST.DATA:
*************************

* direccion1_linea1
    RDIRL1 = R.NEW(Y.LOCAL.REF)<1,CU.RES.SECTOR.POS> : ' ' : R.NEW(Y.LOCAL.REF)<1,CU.URB.ENS.RE.POS>
    WS.DATA<11> = RDIRL1[1,40]
* direccion1_linea2
    RDIRL2 = R.NEW(EB.CUS.STREET) : ' ' : R.NEW(EB.CUS.ADDRESS)
    WS.DATA<12> = RDIRL2[1,40]
* ciudad
    WS.DATA<13> = R.NEW(EB.CUS.COUNTRY)[1,30]
* estado
    WS.DATA<14> = R.NEW(EB.CUS.RESIDENCE)[1,3]
* codigo_postal
    WS.DATA<15> = R.NEW(EB.CUS.POST.CODE)[1,10]
* telefonos
    Y.TEL.TYPE = R.NEW(Y.LOCAL.REF)<1,CU.TEL.TYPE.POS>
    Y.TEL.AREA = R.NEW(Y.LOCAL.REF)<1,CU.TEL.AREA.POS>
    Y.TEL.NUM = R.NEW(Y.LOCAL.REF)<1,CU.TEL.NO.POS>
    Y.TEL.EXT = R.NEW(Y.LOCAL.REF)<1,CU.TEL.EXT.POS>

    TEL.CASA = ''
    TEL.CEL  = ''
    TEL.TRAB = ''
    WS.DATA<16> = ''
    WS.DATA<17> = ''
    WS.DATA<18> = ''
    WS.DATA<19> = ''

    TELS = DCOUNT(Y.TEL.TYPE, @SM)
    FOR I.VAR = 1 TO TELS
        NUM.TEL = OCONV(FIELD(Y.TEL.AREA,@SM,I.VAR) : ' ' : FIELD(Y.TEL.NUM,@SM,I.VAR),'MCN')
        IF FIELD(Y.TEL.TYPE,@SM,I.VAR) EQ '01' AND TEL.CASA EQ '' THEN    ;* telefono casa
            WS.DATA<16> = NUM.TEL
        END
        IF FIELD(Y.TEL.TYPE,@SM,I.VAR) EQ '05' AND TEL.TRAB EQ '' THEN    ;* telefono trabajo + extension
            WS.DATA<17> = NUM.TEL
            WS.DATA<18> = FIELD(Y.TEL.EXT,@SM,I.VAR)[1,4]
        END
        IF FIELD(Y.TEL.TYPE,@SM,I.VAR) EQ '06' AND TEL.CEL EQ '' THEN     ;* telefono celular
            WS.DATA<19> = NUM.TEL
        END
    NEXT I.VAR
* email
    WS.DATA<20> = R.NEW(EB.CUS.EMAIL.1)[1,40]
* empleador
    WS.DATA<21> = R.NEW(EB.CUS.EMPLOYERS.NAME)[1,40]
*tipo_vinculacion
    WS.DATA<22> = R.NEW(EB.CUS.RELATION.CODE)[1,3]
* numero_dependientes
    WS.DATA<23> = R.NEW(EB.CUS.NO.OF.DEPENDENTS)
* estado_civil
    Y.ESTADO.CIVIL = R.NEW(EB.CUS.MARITAL.STATUS)
    BEGIN CASE
        CASE Y.ESTADO.CIVIL EQ 'SOLTERO'
            WS.DATA<24> = 'S'
        CASE Y.ESTADO.CIVIL EQ 'CASADO'
            WS.DATA<24> = 'M'
        CASE Y.ESTADO.CIVIL[1,5] EQ 'UNION'
            WS.DATA<24> = 'U'
        CASE Y.ESTADO.CIVIL EQ 'DIVORCIADO'
            WS.DATA<24> = 'D'
        CASE Y.ESTADO.CIVIL EQ 'VIUDO'
            WS.DATA<24> = 'S'
        CASE 1
            WS.DATA<24> = ' '
    END CASE
* Nacionalidad
    WS.DATA<27> = R.NEW(EB.CUS.NATIONALITY)[1,2]
* Actividad_economica
    Y.INDUSTRY = R.NEW(Y.LOCAL.REF)<1,CU.APAP.INDUSTRY>
    WS.DATA<28> = Y.INDUSTRY


RETURN

************************************************
* Filter out ascii chars from string as required
FILTER.NAME.STRING:
************************************************
    STRING.LEN = LEN(NAME.PRE)
    NAME.POST = ''
    FOR I.VAR = 1 TO STRING.LEN STEP 1
        CHAR.VAL = NAME.PRE[I.VAR,1]
        CHAR.ASC = SEQ(CHAR.VAL)
        BEGIN CASE
* msth: what about accented letters
            CASE CHAR.ASC GE 48 AND CHAR.ASC LE 57
                NAME.POST := CHAR.VAL
            CASE CHAR.ASC GE 97 AND CHAR.ASC LE 122
                NAME.POST := UPCASE(CHAR.VAL)
            CASE CHAR.ASC GE 65 AND CHAR.ASC LE 90
                NAME.POST := CHAR.VAL
            CASE CHAR.ASC EQ 47
                NAME.POST := CHAR.VAL
            CASE CHAR.ASC EQ 38
                NAME.POST := CHAR.VAL
            CASE CHAR.ASC EQ 32
                NAME.POST := CHAR.VAL
            CASE 1
                NULL
        END CASE
    NEXT I.VAR
RETURN

* </region>

END
