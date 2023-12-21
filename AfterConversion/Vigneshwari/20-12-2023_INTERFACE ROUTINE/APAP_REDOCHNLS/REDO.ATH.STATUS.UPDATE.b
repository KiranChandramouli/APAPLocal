* @ValidationCode : MjoxMjA5NTM3OTkzOkNwMTI1MjoxNzAzMDc2MTQxNTQ1OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Dec 2023 18:12:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
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
*
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 10-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*20-12-2023	  VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES          NO CHANGES
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
