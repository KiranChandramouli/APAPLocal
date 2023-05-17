SUBROUTINE REDO.B.UPD.USER.LOG.LOAD
*-------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.UPD.USER.LOG.LOAD
*-------------------------------------------------------------------------
*Description  : This is a validation routine to check the card is valid or
*               This routine has to be attached to versions used in ATM tr
*               to find out whether the status entered is valid or not
*In Parameter : N/A
*Out Parameter: N/A
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who              Description
*   ------         ------             -------------
* 01 NOV  2010     SRIRAMAN.C         Initial
* 12-05-2015      Ashokkumar          Changed the file from PROTOCOL to PROTOCOL.TEMP
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPD.USER.LOG.COMMON


    FN.LOGG = 'F.REDO.L.USER.LOG'
    F.LOGG =''
    CALL OPF(FN.LOGG,F.LOGG)

    FN.PROTO='F.PROTOCOL.TEMP'
    F.PROTO=''
    CALL OPF( FN.PROTO,F.PROTO)
RETURN
END
