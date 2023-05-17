SUBROUTINE REDO.B.CONV.FILE.SELECT
*-------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Sakthi Sellappillai
* Program Name  : REDO.B.CONV.FILE.SELECT
* ODR           : ODR-2010-08-0031
*-------------------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*-------------------------------------------------------------------------------------
* out parameter : None
*-------------------------------------------------------------------------------------
* MODIFICATION HISTORY
*-------------------------------------------------------------------------------------
*DATE               WHO                       ODR                  DESCRIPTION
*============       ====================      ==================   ==============
*19-10-2010         Sakthi Sellappillai       ODR-2010-08-0031     INITIAL CREATION
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.CONV.FILE.COMMON
    $INSERT I_F.EB.FILE.UPLOAD.PARAM
    $INSERT I_F.REDO.FILE.DATE.PROCESS
    $INSERT I_F.REDO.SUPPLIER.PAYMENT
    $INSERT I_F.REDO.SUPPLIER.PAY.DATE

    GOSUB PROCESS
    GOSUB GOEND
RETURN
*-------------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------------

    SEL.CMD   = "SELECT " : Y.FILE.DEST.PATH
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
RETURN
*-------------------------------------------------------------------------------------
GOEND:
*-------------------------------------------------------------------------------------
END
*-----------------------------------*END OF SUBROUTINE*-------------------------------
