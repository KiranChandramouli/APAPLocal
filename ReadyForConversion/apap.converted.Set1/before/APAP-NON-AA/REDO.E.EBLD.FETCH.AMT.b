*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.EBLD.FETCH.AMT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.E.EBLD.FETCH.AMT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the local amount or Foreign amount
*                   by checking the currency
*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.TELLER

  CCY=O.DATA

  IF CCY EQ LCCY THEN
    O.DATA=R.RECORD<TT.TE.AMOUNT.LOCAL.1>
  END
  ELSE
    O.DATA=R.RECORD<TT.TE.AMOUNT.FCY.1>
  END

  RETURN
END
