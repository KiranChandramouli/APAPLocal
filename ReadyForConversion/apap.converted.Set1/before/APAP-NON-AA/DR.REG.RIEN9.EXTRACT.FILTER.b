*-----------------------------------------------------------------------------
* <Rating>-4</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RIEN9.EXTRACT.FILTER(REC.ID)
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.RIEN9.EXTRACT
* Date           : 10-June-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* Dont process AA.ARR.OVERDUE>L.LOAN.STATUS1 NE "3".
* Byron - PACS00313072 - Right spec is Dont process AA.ARR.OVERDUE>L.LOAN.STATUS1 EQ "Writte-Off"
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
* Date              Author                    Description
* ==========        ====================      ============
* 28-08-2014        Ashokkumar                PACS00313072- Fixed all the fields
*-----------------------------------------------------------------------

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_BATCH.FILES
  $INSERT I_F.AA.OVERDUE
$INSERT I_DR.REG.RIEN9.EXTRACT.COMMON

  BEGIN CASE

  CASE CONTROL.LIST<1,1> EQ "AA.DETAIL"
    ArrangementID = REC.ID
    effectiveDate = ''
    idPropertyClass = 'OVERDUE'
    idProperty = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.OVERDUE = RAISE(returnConditions)
    L.LOAN.STATUS = R.AA.OVERDUE<AA.OD.LOCAL.REF,OD.L.LOAN.STATUS1.POS>
*        IF L.LOAN.STATUS EQ 3 THEN             ;* Byron - PACS00313072 S/E
    IF L.LOAN.STATUS EQ 'Write-Off' THEN          ;* Byron - PACS00313072 S/E
      REC.ID = ""   ;* Return NULL if L.LOAN.STATUS1 NE 3.
    END

  CASE 1
    NULL
  END CASE

  RETURN

*-----------------------------------------------------------------------------
END
