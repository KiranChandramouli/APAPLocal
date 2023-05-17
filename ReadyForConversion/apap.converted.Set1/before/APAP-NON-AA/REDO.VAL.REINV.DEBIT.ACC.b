*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.REINV.DEBIT.ACC
*-----------------------------------------------------------------------------

*Description: This routine is hot validation routine for DEBIT.ACCOUNT field in order
* to make B.29 fields as disable

*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 24-02-2011      H GANESH      PACS00033293       initial draft
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.AZ.REINV.DEPOSIT


  GOSUB PROCESS
  RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
  IF COMI NE '' THEN
    T(REDO.AZ.REINV.AZ.METHOD.PAY)<3>='NOINPUT'
    T(REDO.AZ.REINV.AZ.AMOUNT)<3>='NOINPUT'
    T(REDO.AZ.REINV.AZ.SOURCE.FUND)<3>='NOINPUT'
    T(REDO.AZ.REINV.AZ.DEBIT.ACC)<3>='NOINPUT'
  END
  RETURN
END
