SUBROUTINE REDO.GET.CLASS.119
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.GET.CLASS.119
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.APAP.ENQ.INV.GEN.RPT
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

    Y.CRITERIA = ''

    Y.AGENCY       = FIELD(O.DATA,'*',3)
    Y.ACCT.OFFICER = FIELD(O.DATA,'*',2)
    Y.TXN.DATE     = FIELD(O.DATA,'*',1)

    IF Y.TXN.DATE THEN
        Y.CRITERIA = 'FECHA APERTURA CTA. - ':Y.TXN.DATE
    END
    IF Y.ACCT.OFFICER THEN
        IF Y.TXN.DATE THEN
            Y.CRITERIA:=' ,'
        END
        Y.CRITERIA:= ' OFICIAL DE CUENTA - ':Y.ACCT.OFFICER
    END
    IF Y.AGENCY THEN
        IF Y.TXN.DATE OR Y.ACCT.OFFICER THEN
            Y.CRITERIA:=' ,'
        END
        Y.CRITERIA := ' AGENCIA - ':Y.AGENCY:
    END

    IF NOT(Y.TXN.DATE) AND NOT(Y.ACCT.OFFICER) AND NOT(Y.AGENCY) THEN
        Y.CRITERIA = 'ALL'
    END
    O.DATA = Y.CRITERIA
RETURN
*-------------------------------------------------------------------------------------------------------
