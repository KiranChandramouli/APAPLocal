*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.SET.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Authorisation to generate the PDF for OPEN letter and this routine
* is attached to REDO.ISSUE.CLAIM
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Prabhu N
* PROGRAM NAME : REDO.V.INP.SET.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 16.AUG.2010       BRENUGADEVI        ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ISSUE.CLAIMS

  FN.CUS.BEN.LIST = 'F.CUS.BEN.LIST'
  F.CUS.BEN.LIST  = ''
  CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)

  CUS.BEN.LIST.ID = R.NEW(ISS.CL.CUSTOMER.CODE):'-CLAIM'
  R.CUS.BEN.LIST = ID.NEW
  CALL F.WRITE(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST)

  RETURN
END
