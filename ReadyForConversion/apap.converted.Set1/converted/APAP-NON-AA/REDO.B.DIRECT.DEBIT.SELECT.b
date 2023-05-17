SUBROUTINE REDO.B.DIRECT.DEBIT.SELECT

*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.DIRECT.DEBIT.SELECT
*------------------------------------------------------------------
* Description : This is the update rotuine which will select all the customer
* accounts for processing
******************************************************************
*31-10-2011         JEEVAT             EB.LOOKUP select has been removed
*------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.W.DIRECT.DEBIT
    $INSERT I_REDO.B.DIRECT.DEBIT.COMMON


    GOSUB ACCOUNT.SELECT
RETURN
*-----------------------------------------------------
ACCOUNT.SELECT:
*-----------------------------------------------------

    SEL.LIST = R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID>
    CHANGE @VM TO @FM IN SEL.LIST
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
