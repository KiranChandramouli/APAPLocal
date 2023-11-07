* @ValidationCode : MjotMTk4MzA4MjY1OTpDcDEyNTI6MTY5OTM1MDY0NTAyMTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 07 Nov 2023 15:20:45
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.360.PADRONE(Ret)
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
**DATE           ODR                   DEVELOPER               VERSION
* 08-11-2011    ODR2011080071           JOHN                  Initial Creation
*
* 18-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM, if condition added
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*06/10/2023	VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES      Interface Change by Santiago
*-----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT JBC.h
    $INSERT I_System
    $INSERT I_F.CUSTOMER
    $INSERT I_F.IM.IMAGE.TYPE
;*Interface Change by Santiago-NEW LINES ADDED-START    
*SJ start
    $INSERT I_F.DFE.TRANSFORM
    $INSERT I_F.REDO.PADRON.WS
*SJ end
;*Interface Change by Santiago-END
    GOSUB MAIN
    GOSUB PROCESS
RETURN

*****
MAIN:
****


    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    CALL OPF(FN.CUS,F.CUS)

    FN.IMG.TYPE = 'F.IM.IMAGE.TYPE'
    F.IMG.TYPE = ''
    CALL OPF(FN.IMG.TYPE,F.IMG.TYPE)
    IM.ID = 'PHOTOS'

    R.IMG.REC = ''
    IMG.PATH = ''
    CUST.ID = System.getVariable("CURRENT.CUSTOMER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - start
        CUST.ID = ""
    END					;*R22 Auto conversion - end
    LREF.FIELDS = 'L.CU.CIDENT':@VM:'L.CU.TIPO.CL':@VM:'L.CUSTOMER.IMG'
    Y.LREF.POS = ''
    CALL MULTI.GET.LOC.REF('CUSTOMER',LREF.FIELDS,Y.LREF.POS)
    CIDENT.POS = Y.LREF.POS<1,1>

    SUC.FAIL = ''
    CALL F.READ(FN.CUS,CUST.ID,R.CUS,F.CUS,CUS.ERR)
    IF NOT(CUS.ERR) THEN
        VAR.CIDENT = R.CUS<EB.CUS.LOCAL.REF><1,CIDENT.POS>
    END
;*Interface Change by Santiago-START-NEW LINES ADDED
*SJ start
    FN.DFE.TRANSFORM = 'F.DFE.TRANSFORM'
    F.DFE.TRANSFORM = ''
    CALL OPF(FN.DFE.TRANSFORM,F.DFE.TRANSFORM)
*SJ end
;*Interface Change by Santiago-END
RETURN

********
PROCESS.OLD: ;*Interface Change by Santiago-CHANGE "PROCESS" TO "PROCESS.OLD"
********
    CALL F.READ(FN.IMG.TYPE,IM.ID,R.IMG.REC,F.IMG.TYPE,IMG.ERR)
    IF NOT(IMG.ERR) THEN
        IMG.PATH = R.IMG.REC<IM.TYP.PATH>

    END
    Cedule = "padrone$":VAR.CIDENT
*  Cedule = "rnc$":VAR.RNC
    Param1 = "com.padrone.ws.util.MainClass"
    Param2 = "callPadrone"
    Param3 = Cedule
    Ret = ""
    ACTIVATION = "APAP_PADRONES_WEBSERVICES"
    INPUT_PARAM=Cedule
    ERROR.CODE = CALLJEE(ACTIVATION,INPUT_PARAM)
    SUC.FAIL = FIELD(INPUT_PARAM,":",1)
    IF ERROR.CODE THEN
        Ret = "FAIL@FM"
        ETEXT= "FAIL@FM":ERROR.CODE
        CALL STORE.END.ERROR
    END ELSE
        VAR.NAME=INPUT_PARAM
    END

    CHANGE '$' TO '' IN VAR.NAME
    CHANGE '#' TO @FM IN VAR.NAME
    VAL.NAME = VAR.NAME<1>
    CHANGE '::' TO @FM IN VAR.NAME


    APELLIDOS = VAR.NAME<2>
    FECHANACIMIENTO = VAR.NAME<3>
    NOMBRE = VAR.NAME<4>
    IMAGEPATH=VAR.NAME<5>
    SLASHC=DCOUNT(IMAGEPATH,'/')
    IMAGENAME=FIELD(IMAGEPATH,'/',SLASHC)
    C$SPARE(500) = "SUCCESS"
    FLAG = '1'
    IF IMAGENAME THEN
        Ret<-1> = IMG.PATH:"@":IMAGENAME

    END

RETURN
;*Interface Change by Santiago-START-NEW LINES ADDED-START
********
PROCESS:
********
    CALL F.READ(FN.IMG.TYPE,IM.ID,R.IMG.REC,F.IMG.TYPE,IMG.ERR)
    IF NOT(IMG.ERR) THEN
        IMG.PATH = R.IMG.REC<IM.TYP.PATH>
    END

    Cedule = VAR.CIDENT
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
        Ret = "FAIL@FM"
        ETEXT= "FAIL@FM":ERROR.CODE
        CALL STORE.END.ERROR
    END

    APELLIDOS = Y.RESPONSE<6>
    FECHANACIMIENTO = Y.RESPONSE<5>
    NOMBRE = Y.RESPONSE<2>
    IMAGEPATH = ''  ;* SJ VAR.NAME<5> pending validate with APAP because this WS dont return IMAGEPATH
    SLASHC=DCOUNT(IMAGEPATH,'/')
    IMAGENAME=FIELD(IMAGEPATH,'/',SLASHC)
    C$SPARE(500) = "SUCCESS"
    FLAG = '1'
    IF IMAGENAME THEN
        Ret<-1> = IMG.PATH:"@":IMAGENAME
    END

RETURN
;*Interface Change by Santiago-END
END
