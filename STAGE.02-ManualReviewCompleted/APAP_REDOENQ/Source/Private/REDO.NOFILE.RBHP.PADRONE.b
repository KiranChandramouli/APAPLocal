$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.RBHP.PADRONE(Ret)
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
* 08-11-2011    ODR2011080055           JOHN                  Initial Creation
* 27-02-2012    HD ISSUE PACS00182520   PRABHU N              REDO.NOFILE.RBHP.PADRONE
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT JBC.h
    $INSERT I_System
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.IM.IMAGE.TYPE
    $INSERT I_ENQUIRY.COMMON

    GOSUB MAIN
    GOSUB PROCESS
RETURN

*****
MAIN:
****

    Y.CUS.ID=''
    Y.CED.ID=''

    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    CALL OPF(FN.CUS,F.CUS)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS = ''
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

    FN.IMG.TYPE = 'F.IM.IMAGE.TYPE'
    F.IMG.TYPE = ''
    CALL OPF(FN.IMG.TYPE,F.IMG.TYPE)


    IM.ID = 'PHOTOS'

    R.IMG.REC = ''
    IMG.PATH = ''

    LREF.FIELDS = 'L.CU.CIDENT':@VM:'L.CU.TIPO.CL':@VM:'L.CUSTOMER.IMG'
    Y.LREF.POS = ''
    CALL MULTI.GET.LOC.REF('CUSTOMER',LREF.FIELDS,Y.LREF.POS)
    CIDENT.POS = Y.LREF.POS<1,1>

    SUC.FAIL = ''

RETURN

********
PROCESS:
********

    IF ENQ.SELECTION<1,1> EQ 'REDO.ENQ.RBHP.PADRONE' THEN

        LOCATE 'ACCOUNT.NO' IN D.FIELDS SETTING Y.ACCT.POS THEN
            Y.ACCT.ID=D.RANGE.AND.VALUE<1,Y.ACCT.POS>
            R.ACCOUNT=''
            ERR.ACCT=''
            CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCT)
            IF NOT(R.ACCOUNT) THEN
                Y.ACCT.ID.HIS = Y.ACCT.ID
                CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,Y.ACCT.ID.HIS,R.ACCOUNT,ERR.ACCT.HIS)
            END

            IF R.ACCOUNT NE '' THEN
                Y.CUS.ID=R.ACCOUNT<AC.CUSTOMER>
            END
        END

    END

    IF ENQ.SELECTION<1,1> EQ 'REDO.ENQ.PADRONE' THEN
        LOCATE 'ACCOUNT.NO' IN D.FIELDS SETTING Y.CUS.POS THEN
            Y.CUS.ID=D.RANGE.AND.VALUE<1,Y.CUS.POS>
        END
    END

    IF ENQ.SELECTION<1,1> EQ 'REDO.ENQ.CEDULA.PADRONE' THEN
        LOCATE 'ACCOUNT.NO' IN D.FIELDS SETTING Y.CED.POS THEN
            VAR.CIDENT=D.RANGE.AND.VALUE<1,Y.CED.POS>
        END
    END

    IF Y.CUS.ID THEN
        CALL F.READ(FN.CUS,Y.CUS.ID,R.CUS,F.CUS,CUS.ERR)
        IF NOT(CUS.ERR) THEN
            VAR.CIDENT = R.CUS<EB.CUS.LOCAL.REF><1,CIDENT.POS>
        END
    END

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
        ETEXT= 'EB-FAIL.JAVA.ERROR':@FM:ERROR.CODE
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
    CALL System.setVariable("CURRENT.NOMBRE",NOMBRE)
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
