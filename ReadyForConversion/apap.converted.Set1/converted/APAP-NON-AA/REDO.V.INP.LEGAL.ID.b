SUBROUTINE REDO.V.INP.LEGAL.ID
*******************************************************************************************************************
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : P.ANAND(anandp@temenos.com)
*Date              : 26.10.2009
*Program   Name    : REDO.V.INP.LEGAL.ID
*Reference Number  : ODR-2009-10-0807
*------------------------------------------------------------------------------------------------------------------
*Description       : This subroutine validates the customer's passport document and raise the Error Message
*Linked With       :
*
*

*In  Parameter     : -NA-
*Out Parameter     : -NA-
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
*------------------------------------------------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-------------------------------------------------------------------------------------------------------------------
INIT:
******
* This block initialise the local fields and variables used
    Y.LEGAL.ID = R.NEW(EB.CUS.LEGAL.ID)

RETURN
*-------------------------------------------------------------------------------------------------------------------
PROCESS:
********
    IF Y.LEGAL.ID NE '' THEN
        AF = EB.CUS.LEGAL.ID
        AV = 1
        ETEXT = 'EB-REDO.INVALID.DOC'
        CALL STORE.END.ERROR
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------
END
*-------------------------------------------END OF RECORD-----------------------------------------------------------
