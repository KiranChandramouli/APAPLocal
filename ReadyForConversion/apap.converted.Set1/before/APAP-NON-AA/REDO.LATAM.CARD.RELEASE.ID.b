*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LATAM.CARD.RELEASE.ID
*-----------------------------------------------------------------------------
!** FIELD definitions FOR TEMPLATE
*!
* @author youremail@temenos.com
* @stereotype id
* @package infra.eb
* @uses E
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------

  ID.ENTERED=ID.NEW
  CRD.TYP=FIELD(ID.NEW,".",1)
  COMP.CDE=FIELD(ID.NEW,".",2)

  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN

OPENFILES:

  FN.CARD.TYPE='F.CARD.TYPE'
  F.CARD.TYPE=''
  CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

  FN.COMPANY='F.COMPANY'
  F.COMPANY=''
  CALL OPF(FN.COMPANY,F.COMPANY)

  RETURN


PROCESS:


  CALL F.READ(FN.CARD.TYPE,CRD.TYP,R.CARD.TYPE,F.CARD.TYPE,ERR)
  IF R.CARD.TYPE ELSE

    E = 'EB-NOT.VALID.CARD.TYPE'
  END

  IF COMP.CDE NE '' THEN

    IF COMP.CDE NE ID.COMPANY THEN

      CALL F.READ(FN.COMPANY,COMP.CDE,R.COMP,F.COMPANY,ERR)

      IF R.COMP THEN

        E = "EB-CANNOT.ACCESS.COMPANY"

      END ELSE

        E = 'EB-NOT.VALID.COMPANY'
      END


    END ELSE
      RETURN
    END
  END ELSE

    ID.NEW=CRD.TYP:'.':ID.COMPANY

  END



  RETURN




  RETURN

END
