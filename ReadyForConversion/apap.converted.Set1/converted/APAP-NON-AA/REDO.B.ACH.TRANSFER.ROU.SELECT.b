SUBROUTINE REDO.B.ACH.TRANSFER.ROU.SELECT
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.B.ACH.TRANSFER.ROU.SELECT
* ODR NUMBER    : PACS0006290 - ODR-2011-01-0492
*--------------------------------------------------------------------------------------
* Description   : This routine will run while daily cob and create FT records
* In parameter  : Y.ID
* out parameter : none
*--------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE                      DESCRIPTION
* 01-06-2011      MARIMUTHU s     ODR-2011-01-0492 (PACS0006290)    Initial Creation
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ACH.TRANSFER.ROU.COMMON

MAIN:


    SEL.CMD = 'SELECT ':FN.REDO.ACH.TRANSFER.DETAILS:' WITH TRANS.ACH EQ "NO" BY CLIENT.ID BY DEPOSIT.NO'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN

END
