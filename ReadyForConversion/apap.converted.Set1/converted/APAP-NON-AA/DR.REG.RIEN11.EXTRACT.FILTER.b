*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN11.EXTRACT.FILTER(REC.ID)
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.RIEN11.EXTRACT
* Date           : 10-June-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transaction made over 1000 USD by individual Customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
*
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES

    $INSERT I_DR.REG.RIEN11.EXTRACT.COMMON

    BEGIN CASE

        CASE CONTROL.LIST<1,1> EQ "TRANSACTION.DETAIL"
            IF NOT(NUM(REC.ID)) THEN
                REC.ID = ""   ;* Return NULL if it is not a CUSTOMER Account
            END

        CASE 1
            NULL
    END CASE

RETURN

*-----------------------------------------------------------------------------
END
