*-----------------------------------------------------------------------------
* <Rating>63</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ANC.AZ.REINV.FREQ

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.AZ.ACCOUNT

*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date            Who                 Reference            Description
* 17-Apr-2010     Sudharsanan S       PACS00192055         INITIAL VERSION
* ----------------------------------------------------------------------------

  GOSUB PROCESS

  RETURN

*********
PROCESS:
*********



  Y.DATE = TODAY
  Y.DATE.BK = Y.DATE

  IF Y.DATE[5,2] = '01' THEN
    GOSUB CHECK.JAN.MON
  END
  ELSE IF Y.DATE[5,2] = '02'  THEN
    GOSUB CHECK.FEB.MON
  END
  ELSE
    Y.DAYS = "+31C"
    CALL CDT('',Y.DATE,Y.DAYS)
  END


*    CALL AWD('',Y.DATE,DATE.TYPE)

*    IF DATE.TYPE EQ 'H' THEN
*        Y.DAYS = "-1W"
*        CALL CDT('',Y.DATE,Y.DAYS)
*    END

  R.NEW(AZ.FREQUENCY) = Y.DATE:"M01":Y.DATE.BK[7,2]

  R.NEW(AZ.VALUE.DATE) = TODAY

  RETURN

CHECK.JAN.MON:

  IF Y.DATE[7,2] GE "29" THEN
    IF MOD(Y.DATE[1,4],4)>0 THEN
      Y.DATE = Y.DATE[1,4]:'0228'
    END ELSE
      Y.DATE = Y.DATE[1,4]:'0229'
    END
  END
  ELSE
    Y.DAYS = "+31C"
    CALL CDT('',Y.DATE,Y.DAYS)
  END

  RETURN

CHECK.FEB.MON:

  IF MOD(Y.DATE[1,4],4)>0 THEN
    Y.DAYS = "+28C"
    CALL CDT('',Y.DATE,Y.DAYS)
  END ELSE
    Y.DAYS = '+29C'
    CALL CDT('',Y.DATE,Y.DAYS)
  END

  RETURN


END
