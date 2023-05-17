SUBROUTINE REDO.B.UPD.WORK.FILE

*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.UPD.WORK.FILE
*--------------------------------------------------------------------------------
* Description: This routine is for Deleting local template for the COB preformanace issue
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 02-12-2011      Jeeva T     For COB Performance
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.PARAMETER

    GOSUB OPEN.FILE
    GOSUB PROCESS.FILE
RETURN

*---------------------------------------------------------------------------------
OPEN.FILE:
*---------------------------------------------------------------------------------
    FN.REDO.W.ACCOUNT.UPDATE = 'F.REDO.W.ACCOUNT.UPDATE'
    F.REDO.W.ACCOUNT.UPDATE = ''
    CALL OPF(FN.REDO.W.ACCOUNT.UPDATE,F.REDO.W.ACCOUNT.UPDATE)
    R.REDO.W.ACCOUNT.UPDATE = '' ; Y.FUNCTION = ''
RETURN
*---------------------------------------------------------------------------------
PROCESS.FILE:
*---------------------------------------------------------------------------------
    CALL F.DELETE(FN.REDO.W.ACCOUNT.UPDATE,TODAY)
RETURN
END
