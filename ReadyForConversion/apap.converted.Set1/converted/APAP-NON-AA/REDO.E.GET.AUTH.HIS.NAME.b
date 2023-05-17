SUBROUTINE REDO.E.GET.AUTH.HIS.NAME
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.GET.AUTH.HIS.NAME
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.EXE.ACCT.OPEN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*    02 08 2012       GANESH R                 ODR-2010-03-0141           Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    ACCT.ID = O.DATA
    O.DATA = ''
    FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT$HIS  = ''
    CALL OPF(FN.ACCOUNT$HIS,F.ACCOUNT$HIS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    CALL F.READ(FN.ACCOUNT$HIS,ACCT.ID,R.ACCOUNT,F.ACCOUNT$HIS,ACCT.ERR)
    O.DATA = R.ACCOUNT<AC.AUTHORISER>
    IF NOT(O.DATA) THEN
        ACCT.LIVE.ID = FIELD(ACCT.ID,';',1)
        CALL F.READ(FN.ACCOUNT,ACCT.LIVE.ID,R.ACCOUNT,F.ACCOUNT,ACCT.LIVE.ERR)
        O.DATA = R.ACCOUNT<AC.AUTHORISER>
    END
RETURN
*-------------------------------------------------------------------------------------------------------
