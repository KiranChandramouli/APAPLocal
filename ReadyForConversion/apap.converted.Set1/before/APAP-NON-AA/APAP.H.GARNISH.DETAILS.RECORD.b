*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE APAP.H.GARNISH.DETAILS.RECORD
*-------------------------------------------------------------------------
*DIS:is the record routine will default the @ID value in the field GARNISHMENT.REF
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : BHARATH C
* Program Name  : REDO.V.INP.GARNISHMENT.MAINT
* ODR NUMBER    : ODR-2009-10-0531
*----------------------------------------------------------------------
*Input param = none
*output param =none
*--------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.APAP.H.GARNISH.DETAILS

  GOSUB INIT
*GOSUB OPENFILE
  GOSUB PROCESS
  RETURN
*---------------------
INIT:
  GARNISHMENT.ID=''
  RETURN
*-------------------
OPENFILE:
  FN.GARNISHMENT='F.APAP.H.GARNISH.DETAILS$NAU'
  F.GARNISHMENT =''
  CALL OPF(FN.GARNISHMENT,F.GARNISHMENT)
  RETURN
*--------------------
PROCESS:
  GARNISHMENT.ID=ID.NEW
  R.NEW(APAP.GAR.GARNISHMENT.REF)=GARNISHMENT.ID

  IF R.OLD(APAP.GAR.IDENTITY.TYPE) EQ '' AND R.NEW(APAP.GAR.IDENTITY.NUMBER) EQ '' THEN
    R.NEW(APAP.GAR.RECEP.DATE) = TODAY  ;* Field to store the date on which garnishment has happened.
  END

  RETURN
*---------------------

END
