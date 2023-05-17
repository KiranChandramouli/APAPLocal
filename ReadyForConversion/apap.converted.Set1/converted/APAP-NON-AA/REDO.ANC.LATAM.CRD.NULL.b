SUBROUTINE REDO.ANC.LATAM.CRD.NULL

*--------------------------------------------------------------------------------------------------------
*Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By : Temenos Application Management
*Program Name : LATAM.CARD.ORDER.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description : This is a process routine to update renewal status on changing renewal status of damaged card
*Linked With : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date Who Reference Description
* ------ ------ ------------- -------------
* 1 Sep 2011 Balagurunathan ODR-2010-03-0400 (PACS00093181) Initial Creation
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.ORDER

    R.NEW(CARD.IS.RENEW.STATUS)=''


RETURN


END
