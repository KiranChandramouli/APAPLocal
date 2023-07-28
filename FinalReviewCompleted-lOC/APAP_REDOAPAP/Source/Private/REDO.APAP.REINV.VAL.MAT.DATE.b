* @ValidationCode : MjotODQ1NDgwMjgyOkNwMTI1MjoxNjgxODAxMjIxMDI1OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 12:30:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.REINV.VAL.MAT.DATE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.REINV.VAL.MAT.DATE
*------------------------------------------------------------------------------
*Description  : REDO.APAP.REINV.VAL.MAT.DATE is a validation routine for the
*               version REDO.H.AZ.REINV.DEPOSIT,CPH which populates the
*               field VAL.MAT.DATE
*Linked With  : REDO.H.AZ.REINV.DEPOSIT,CPH
*In Parameter : N/A
*Out Parameter: N/A
*Files Used   : REDO.H.AZ.REINV.DEPOSIT
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  03-08-2010      JEEVA T            ODR-2009-10-0346 B.21      Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  NO CHANGE
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------

*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.AZ.REINV.DEPOSIT

**************************************************************************
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA
RETURN
**************************************************************************
*************
PROCESS.PARA:
*************


    Y.END.DATE=COMI
    Y.VAL.DATE=R.NEW(REDO.AZ.REINV.START.DATE)
    Y.VAL.MAT.DATE=Y.VAL.DATE:'-':Y.END.DATE
    R.NEW(REDO.AZ.REINV.VAL.MAT.DATE)=Y.VAL.MAT.DATE
RETURN
******************************************************
END
