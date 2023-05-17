*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.TELLER.ID
*---------------------------------------------------------------------------------------
*DESCRIPTION: This routine will default the teller id for the from teller attach to the
*version of TELLER,REDO.TILL.TRNS
*---------------------------------------------------------------------------------------
*IN  :  -NA-
*OUT :  -NA-
*****************************************************
*COMPANY NAME : APAP
*DEVELOPED BY : DHAMU S
*PROGRAM NAME : REDO.V.INP.TELLER.ID
*----------------------------------------------------------------------------------------------
*Modification History:
*------------------------
*DATE               WHO              REFERENCE                    DESCRIPTION
*10-6-2011         RIYAS          ODR-2009-10-0525             INITIAL CREATION
*-----------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
  $INSERT I_F.TELLER
  $INSERT I_F.TELLER.ID

  GOSUB INIT
  GOSUB PROCESS
  RETURN
******
INIT:
******

  FN.TELLER = 'F.TELLER'
  F.TELLER  = ''
  CALL OPF(FN.TELLER,F.TELLER)

  FN.TELLER.ID = 'F.TELLER.ID'
  F.TELLER.ID  = ''
  CALL OPF(FN.TELLER.ID,F.TELLER.ID)
  RETURN
********
PROCESS:
********
  Y.LCCY=LCCY
  Y.CCY=R.NEW(TT.TE.CURRENCY.1)
  IF Y.CCY NE Y.LCCY THEN
    R.NEW(TT.TE.AMOUNT.LOCAL.1) = ''
  END
  RETURN
***************************************************************
END
*-----------------End of program--------------------------------------------------
