SUBROUTINE REDO.E.INS.SELECT(ENQ.DATA)

************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.INS.SELECT
*----------------------------------------------------------

* Description   : This subroutine will return the list of AZ PRODUCT PARAMETERS
* Linked with   : Enquiry REDO.E.INS.SELECT as conversion routine
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----
INIT:
*-----
    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    Y.VAR.EXT.CUSTOMER=''
    Y.VAR.EXT.CUSTOMER=System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.VAR.EXT.CUSTOMER = ""
    END
RETURN
*-------
PROCESS:
*-------
    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.VAR.EXT.CUSTOMER,R.AZ.LIST,F.CUSTOMER.ACCOUNT,ERR)
    R.AZ.COUNT=DCOUNT(R.AZ.LIST,@FM)
    FOR AZ.COUNT=1 TO R.AZ.COUNT
        CALL F.READ(FN.AZ.ACCOUNT,R.AZ.LIST<AZ.COUNT>,R.AZ.RECORD,F.AZ.ACCOUNT,ERR)
        IF R.AZ.RECORD THEN
            LOCATE R.AZ.RECORD<AZ.ALL.IN.ONE.PRODUCT> IN VAR.AZ.LIST SETTING POS ELSE

                VAR.AZ.LIST<-1>=R.AZ.RECORD<AZ.ALL.IN.ONE.PRODUCT>
            END
        END
    NEXT AZ.COUNT

    CHANGE @FM TO @SM IN VAR.AZ.LIST
    ENQ.DATA<2>= '@ID'
    ENQ.DATA<3>= 'EQ'
    ENQ.DATA<4>= VAR.AZ.LIST
RETURN
END
