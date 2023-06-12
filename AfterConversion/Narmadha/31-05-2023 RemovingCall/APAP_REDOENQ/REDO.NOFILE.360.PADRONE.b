* @ValidationCode : MjotMjM5NzI2NTk1OkNwMTI1MjoxNjgyMDc4ODczMjAzOklUU1M6LTE6LTE6NDgzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 483
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
*-----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT JBC.h
    $INSERT I_System
    $INSERT I_F.CUSTOMER
    $INSERT I_F.IM.IMAGE.TYPE


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


RETURN

********
PROCESS:
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
END
