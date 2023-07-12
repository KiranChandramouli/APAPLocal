*-----------------------------------------------------------------------------
* <Rating>-35</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.INSURANCE.VAL
*-----------------------------------------------------------------------------------------------------------------
* This routine is used to make fields no input at the validation level depending upon the values entered
* in CLASS.POLICY and INS.POLICY
*-----------------------------------------------------------------------------------------------------------------
* Modification History
*
*
*
*-----------------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.APAP.H.INSURANCE.DETAILS

*-----------------------------------------------------------------------------------------------------------------
MAIN.LOGIC:

  GOSUB INITIALISE

  GOSUB VALIDATE

  RETURN
*-----------------------------------------------------------------------------------------------------------------
***<region>

INITIALISE:

* Any variable Initialisation woule be done here

  RETURN
***</region>
*-----------------------------------------------------------------------------------------------------------------
***<region>

VALIDATE:
  IF OFS.VAL.ONLY EQ '1' AND MESSAGE EQ 'VAL' THEN
* If INS.POLICY is 'VU' and CLASS.POLICY is 'GROUP' then the below fields would be made NOINPUT - Ref: PACS00039517

    IF (R.NEW(INS.DET.INS.POLICY.TYPE) EQ 'VU' AND COMI EQ 'GROUP') THEN

      T(INS.DET.MON.POL.AMT)<3> = 'NOINPUT'
      T(INS.DET.EXTRA.AMT)<3> = 'NOINPUT'
      T(INS.DET.MON.TOT.PRE.AMT)<3> = 'NOINPUT'
      T(INS.DET.COLLATERAL.ID)<3> = 'NOINPUT'

    END


* If INS.POLICY is 'PVC' and CLASS.POLICY is 'GROUP' then the below fields would be made NOINPUT - Ref: PACS00039601

    IF (R.NEW(INS.DET.INS.POLICY.TYPE) EQ 'PVC' AND COMI EQ 'GROUP') THEN

      T(INS.DET.MON.POL.AMT)<3> = 'NOINPUT'
      T(INS.DET.MON.POL.AMT.DATE)<3> = 'NOINPUT'
      T(INS.DET.EXTRA.AMT)<3> = 'NOINPUT'
      T(INS.DET.MON.TOT.PRE.AMT)<3> = 'NOINPUT'

    END

    IF (R.NEW(INS.DET.INS.POLICY.TYPE) NE 'FHA' AND COMI NE 'FHA') THEN

      T(INS.DET.FHA.CASE.NO)<3> = 'NOINPUT'
      T(INS.DET.INS.CTRL.REC.DT)<3> = 'NOINPUT'
      T(INS.DET.INS.CTRL.APP.DT)<3> = 'NOINPUT'
      T(INS.DET.POL.ISS.DATE)<3> = 'NOINPUT'

    END
  END

  IF OFS.VAL.ONLY EQ '' AND MESSAGE EQ 'VAL' THEN


* If INS.POLICY is 'VU' and CLASS.POLICY is 'GROUP' then the below fields would be made NOINPUT - Ref: PACS00039517

    IF (R.NEW(INS.DET.INS.POLICY.TYPE) EQ 'VU' AND R.NEW(INS.DET.CLASS.POLICY) EQ 'GROUP') THEN

      T(INS.DET.MON.POL.AMT)<3> = 'NOINPUT'
      T(INS.DET.EXTRA.AMT)<3> = 'NOINPUT'
      T(INS.DET.MON.TOT.PRE.AMT)<3> = 'NOINPUT'
      T(INS.DET.COLLATERAL.ID)<3> = 'NOINPUT'

    END


* If INS.POLICY is 'PVC' and CLASS.POLICY is 'GROUP' then the below fields would be made NOINPUT - Ref: PACS00039601

    IF (R.NEW(INS.DET.INS.POLICY.TYPE) EQ 'PVC' AND R.NEW(INS.DET.CLASS.POLICY) EQ 'GROUP') THEN

      T(INS.DET.MON.POL.AMT)<3> = 'NOINPUT'
      T(INS.DET.MON.POL.AMT.DATE)<3> = 'NOINPUT'
      T(INS.DET.EXTRA.AMT)<3> = 'NOINPUT'
      T(INS.DET.MON.TOT.PRE.AMT)<3> = 'NOINPUT'

    END

    IF (R.NEW(INS.DET.INS.POLICY.TYPE) NE 'FHA' AND R.NEW(INS.DET.CLASS.POLICY) NE 'FHA') THEN

      T(INS.DET.FHA.CASE.NO)<3> = 'NOINPUT'
      T(INS.DET.INS.CTRL.REC.DT)<3> = 'NOINPUT'
      T(INS.DET.INS.CTRL.APP.DT)<3> = 'NOINPUT'
      T(INS.DET.POL.ISS.DATE)<3> = 'NOINPUT'

    END
  END



  RETURN

***</region>
*-----------------------------------------------------------------------------------------------------------------

END
