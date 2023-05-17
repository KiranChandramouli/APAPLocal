SUBROUTINE REDO.COMP.GEN.ENQ

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.BRANCH.STATUS

*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.RTE.DENOM.EXCESS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.COMP.GEN.ENQ is a Input routine to generate Withdraw,Deposit and Denomination
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
* 30 May 2011       Shiva Prasad Y              ODR-2011-03-0150 35         Initial Creation
*
*********************************************************************************************************

    Y.GET.STATUS = R.NEW(BR.ST.OPERATION.STATUS)
    IF Y.GET.STATUS EQ 'CLOSED' THEN


        Y.INP = 'ENQ REDO.APAP.ENQ.CASH.WINDOW.WIT AGENCY EQ "':ID.NEW:'"'
        CALL EB.SET.NEW.TASK(Y.INP)

        Y.INP = 'ENQ REDO.APAP.ENQ.CASH.WINDOW.DEP AGENCY EQ "':ID.NEW:'"'
        CALL EB.SET.NEW.TASK(Y.INP)

        Y.INP = 'ENQ REDO.APAP.ENQ.CASH.WINDOW.DENOM AGENCY EQ "':ID.NEW:'"'
        CALL EB.SET.NEW.TASK(Y.INP)

    END
RETURN
END
