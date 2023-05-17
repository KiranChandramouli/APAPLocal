*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.CHK.CUSTOMER.ACCOUNT
**************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Ganesh R
* PROGRAM NAME: REDO.CHK.CUSTOMER.ACCOUNT
* ODR NO      : ODR-2011-03-0150
*-----------------------------------------------------------------------------------------------------
*DESCRIPTION: This routine is to get the card number and check whether it is Valid or not.
*******************************************************************************************************
*linked with :
*In parameter:
*Out parameter:
*****************************************************************************************************
*Modification History
*  Date       Who             Reference       Description
* 20 jan 2012 Ganesh R    ODR-2011-03-0150    Will Raise the Error message
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    GOSUB PROCESS
    CALL REDO.V.INP.TT.AC.VAL

    RETURN

PROCESS:
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.APP = "ACCOUNT"
    Y.APPL.FLS = "L.AC.STATUS2"
    Y.FLD.POS = ""

    CALL MULTI.GET.LOC.REF(Y.APP,Y.APPL.FLS,Y.FLD.POS)      ;* PACS00631629
    AC2.POS = Y.FLD.POS<1,1>

    ACCT.ID = COMI
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    CUST.ID = R.ACCOUNT<AC.CUSTOMER>
    Y.AC.STATUS = R.ACCOUNT<AC.LOCAL.REF,AC2.POS>


    IF Y.AC.STATUS EQ 'DECEASED' THEN   ;* PACS00631629 -s
        ETEXT = "EB-REDO.AC.DECEASED"
        CALL STORE.END.ERROR
        RETURN
    END   ;* PACS00631629 -e

    IF NOT(CUST.ID) THEN
        ETEXT = "TT-CUST.ACCT"
        CALL STORE.END.ERROR
    END
    RETURN
