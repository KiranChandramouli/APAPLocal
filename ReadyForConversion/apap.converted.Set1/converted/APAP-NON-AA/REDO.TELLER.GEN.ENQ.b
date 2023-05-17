SUBROUTINE REDO.TELLER.GEN.ENQ

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.BRANCH.STATUS

*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.TELLER.GEN.ENQ
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.TELLER.GEN.ENQ is a Input routine to generate Withdraw,Deposit and Denomination
*                    enquiry
*Linked With       :

*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Output array for display
*Files  Used       :
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 30 May 2011       Shiva Prasad Y              ODR-2011-04-0007 32         Initial Creation
* 20 Jul 2018       Gopala Krishnan R           PACS00676434                Issue Fix
*********************************************************************************************************
    Y.GET.STATUS = R.NEW(TT.TID.STATUS)

    IF Y.GET.STATUS EQ 'CLOSE' THEN
        Y.INP = 'ENQ REDO.APAP.ENQ.CASH.WINDOW.WIT.R32 TELLER.ID EQ ':ID.NEW:''
        CALL EB.SET.NEW.TASK(Y.INP)

        Y.INP = 'ENQ REDO.APAP.ENQ.CASH.WINDOW.DEP.R32 TELLER.ID EQ ':ID.NEW:''
        CALL EB.SET.NEW.TASK(Y.INP)

        Y.INP = 'ENQ REDO.APAP.ENQ.CASHIER.DENOM TELLER.ID EQ ':ID.NEW:''
        CALL EB.SET.NEW.TASK(Y.INP)

        Y.INP = 'ENQ REDO.TELLER.CASHIER.REPORT TELLER.ID EQ ':ID.NEW:''
        CALL EB.SET.NEW.TASK(Y.INP)
    END
RETURN
END
