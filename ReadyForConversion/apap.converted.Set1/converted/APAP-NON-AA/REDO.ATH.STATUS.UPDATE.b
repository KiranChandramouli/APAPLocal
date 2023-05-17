SUBROUTINE REDO.ATH.STATUS.UPDATE
*******************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.ATH.STATUS.UPDATE
*****************************************************************
*Description:This routine is to update the status and response code based on the error message
***********************************************************************************************
*In parameter :None
*Out parameter :None
***********************************************************************************************
*Modification History:
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   3-12-2010       DHAMU S              ODR-2010-08-0469         Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.ATH.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.REDO.ATH.SETTLMENT
    $INSERT I_F.REDO.DC.STLMT.ERR.CODE
    GOSUB PROCESS

RETURN
********
PROCESS:
********

    IF ERROR.MESSAGE EQ '' THEN

        R.REDO.STLMT.LINE<ATH.SETT.STATUS> = "SETTLED"
    END
    IF ERROR.MESSAGE NE '' THEN

        LOCATE ERROR.MESSAGE IN R.REDO.DC.STLMT.ERR.CODE<STM.ERR.CODE.ERR.MSG,1> SETTING ERROR.POS THEN
            R.REDO.STLMT.LINE<ATH.SETT.REASON.CODE> = R.REDO.DC.STLMT.ERR.CODE<STM.ERR.CODE.ERR.CODE,ERROR.POS>
        END

        R.REDO.STLMT.LINE<ATH.SETT.STATUS> = "REJECTED"
    END


RETURN

END
