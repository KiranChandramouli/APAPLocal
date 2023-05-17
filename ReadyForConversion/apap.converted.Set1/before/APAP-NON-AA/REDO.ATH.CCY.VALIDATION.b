*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ATH.CCY.VALIDATION
***********************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Prabhu N
*  Program   Name    :REDO.ATH.CCY.VALIDATION
***********************************************************************************
*Description: This routine is to validate both source and detination to DOP
*
*****************************************************************************
*linked with: NA
*In parameter: NA
*Out parameter: REDO.ATH.CCY.VALIDATION
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*29.03.2013   Prabhu N       PACS00255610-ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CURRENCY
$INSERT I_REDO.ATH.STLMT.FILE.PROCESS.COMMON
$INSERT I_F.REDO.ATH.SETTLMENT



  IF ERROR.MESSAGE NE '' THEN
    RETURN
  END

  GOSUB PROCESS
  RETURN

*******
PROCESS:
********
  DST.CURRENCY=TRIM(R.REDO.STLMT.LINE<ATH.SETT.ISSUER.CCY.CODE>)
  SRC.CURRENCY=TRIM(Y.FIELD.VALUE)


  Y.CCY.NUM.CODE=C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE>

  IF SRC.CURRENCY EQ Y.CCY.NUM.CODE THEN
    IF Y.CCY.NUM.CODE NE R.REDO.STLMT.LINE<ATH.SETT.ISSUER.CCY.CODE> THEN
      ERROR.MESSAGE='INVALID.CURRENCY'
    END
  END ELSE
    ERROR.MESSAGE='INVALID.CURRENCY'
  END

  RETURN

END
