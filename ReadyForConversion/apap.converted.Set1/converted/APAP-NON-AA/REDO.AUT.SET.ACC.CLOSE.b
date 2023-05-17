SUBROUTINE REDO.AUT.SET.ACC.CLOSE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AUT.SET.ACC.CLOSE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.AUT.SET.ACC.CLOSE is a auth routine to generate a interest liq account close
*                    enquiry
*In  Parameter     : NA
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 27 Dec 2011       Sudharsanan S                  PACS00164588         Initial Creation
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT

    Y.INP = 'ENQ REDO.LIQ.ACCT.CLOSURE @ID EQ ':ID.NEW
    CALL EB.SET.NEW.TASK(Y.INP)
RETURN
END
