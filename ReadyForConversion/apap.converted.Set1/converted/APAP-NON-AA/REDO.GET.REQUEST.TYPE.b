SUBROUTINE REDO.GET.REQUEST.TYPE(Y.FINAL.ARRAY)
*--------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : S.Dhamu
* Program Name  : NOFILE.REDO.APAP.CARD.REQ
* ODR NUMBER    : ODR-2010-03-0092
*----------------------------------------------------------------------------------
* Description   : This is a Nofile routine for the Enquiry %REDO.ENQ.REQUEST.TYPE
*                 to display the value AUTOMATIC & MANUAL
* In parameter  : None
* out parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*   DATE             WHO            REFERENCE         DESCRIPTION
* 29-06-2011        Dhamu.S     ODR-2010-03-0092   Initial Creation
* ----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.FINAL.ARRAY = 'AUTOMATIC':@FM:'MANUAL'

RETURN
*****************
END
*---------------------------End of Program------------------------------------------
