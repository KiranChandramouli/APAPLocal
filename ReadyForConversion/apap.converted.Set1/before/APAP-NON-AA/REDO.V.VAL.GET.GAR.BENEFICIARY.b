*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.GET.GAR.BENEFICIARY
*----------------------------------------------------------------------
*Description:
*This is an Validation routine for the version APAP.H.GARNISH.DETAILS,DEL
*---------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : Prabhu N
* Program Name  : REDO.V.VAL.GET.GAR.BENEFICIARY
* ODR NUMBER    : ODR-2009-10-0531
*----------------------------------------------------------------------
*Input param = none
*output param =none

*-------------------------------------------------------------------------
*Date        Who                ref                    Desc
*01 nov 2011 Prabhu         PACS00149089           initial creation
*---------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AC.LOCKED.EVENTS
$INSERT I_F.APAP.H.GARNISH.DETAILS
  GOSUB PROCESS
  RETURN
*---------------------------------
PROCESS:
*---------------------------------
*Getting the values using R.NEW
*---------------------------------
  IF COMI EQ 'PAYMENT.TO.CREDITOR' AND NOT(VAL.TEXT) THEN
    R.NEW(APAP.GAR.BENEFICIARY)<1,1>=R.NEW(APAP.GAR.NAME.CREDITOR)
  END
  ELSE
    IF NOT(VAL.TEXT) THEN
      R.NEW(APAP.GAR.BENEFICIARY)<1,1>=''
    END
  END
  RETURN
*-----------------------------------
END
