SUBROUTINE REDO.E.PRD.SELECT(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JEEVA T
* Program Name : REDO.E.PRD.SELECT
*----------------------------------------------------------

* Description   :
* Linked with   :
* In Parameter  : None
* Out Parameter : None
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.10.2010   JEEVA T      ODR-2010-08-0031   INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System

    GOSUB OPEN
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPEN:
*-----------------------------------------------------------------------------
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.EXT.CUST=System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.EXT.CUST = ""
    END


    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.EXT.CUST,R.CUS.ACCT.RECORD,F.CUSTOMER.ACCOUNT,ERR)
    VAR.CUST.COUNT=DCOUNT(R.CUS.ACCT.RECORD,@FM)
    VAR.CUS.ACCT.COUNT=1
    LOOP
    WHILE VAR.CUS.ACCT.COUNT LE VAR.CUST.COUNT
        VAR.ACCT.ID=R.CUS.ACCT.RECORD<VAR.CUS.ACCT.COUNT>
        CALL F.READ(FN.ACCOUNT,VAR.ACCT.ID,R.ACCT.RECORD,F.ACCOUNT,ERR)
        VAR.ARR.ID=R.ACCT.RECORD<AC.ARRANGEMENT.ID>
        IF VAR.ARR.ID NE '' THEN
            CALL F.READ(FN.AA.ARRANGEMENT,VAR.ARR.ID,R.ARR.RECORD,F.AA.ARRANGEMENT,ERR)
            LOCATE R.ARR.RECORD<AA.ARR.PRODUCT,1> IN VAR.PRODUCT.LIST SETTING POS ELSE
                VAR.PRODUCT.LIST<-1>=R.ARR.RECORD<AA.ARR.PRODUCT,1>
            END
        END
        VAR.CUS.ACCT.COUNT+=1
    REPEAT
    CHANGE @FM TO @SM IN VAR.PRODUCT.LIST
    ENQ.DATA<2,-1> ='@ID'
    ENQ.DATA<3,-1> ='EQ'
    ENQ.DATA<4,-1> = VAR.PRODUCT.LIST
RETURN
*-----------------------------------------------------------------------------
END
