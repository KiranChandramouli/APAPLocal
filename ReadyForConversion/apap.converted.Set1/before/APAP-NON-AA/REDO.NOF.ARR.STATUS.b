*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOF.ARR.STATUS(Y.ARR.STATUS.LIST)
*******************************************************************************
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S & MOHAMMED ANIES.K
* Program Name : REDO.NOF.ARR.STATUS
*--------------------------------------------------------------------------------
*Description : This routine is used to display the ARR.STATUS in selection citeria
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.PRD.ARR.STATUS
* In Parameter : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   19-10-2010       DHAMU S          ODR-2010-08-0182 113       Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT  = ''
  CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

  SEL.CMD = "SELECT ":FN.AA.ARRANGEMENT
  CALL  EB.READLIST(SEL.CMD, SEL.LIST, '', NO.OF.REC, Y.SEL.ERR)
  LOOP
    REMOVE Y.ID FROM SEL.LIST SETTING Y.POS
  WHILE Y.ID:Y.POS
    CALL F.READ(FN.AA.ARRANGEMENT, Y.ID, R.REC.AA.ARANGEMENT, F.AA.ARRANGEMENT, Y.ERR.ARR)
    Y.ARR.STATUS = R.REC.AA.ARANGEMENT<AA.ARR.ARR.STATUS>
    LOCATE Y.ARR.STATUS IN Y.ARR.STATUS.LIST<1> SETTING Y.POS.ARR.TEMP ELSE
      Y.ARR.STATUS.LIST<-1> = Y.ARR.STATUS
    END
  REPEAT

  RETURN
