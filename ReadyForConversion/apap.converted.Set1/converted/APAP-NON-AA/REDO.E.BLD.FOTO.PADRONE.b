SUBROUTINE REDO.E.BLD.FOTO.PADRONE(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep M
* Program Name : REDO.E.BLD.FOTO.PADRONE
*-----------------------------------------------------------------------------
* Description :Bulit routine to assign value to set variable.
* Linked with :
* In Parameter :
* Out Parameter :
*
**DATE           ODR                   DEVELOPER               VERSION
* 10-11-2011    ODR2011080055          Pradeep M
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER



    GOSUB OPEN.PROCESS

RETURN

OPEN.PROCESS:
*------------

    Y.CUS.ID=ENQ.DATA<4>

    CALL System.setVariable("CURRENT.CUSTOMER",Y.CUS.ID)

RETURN

END
