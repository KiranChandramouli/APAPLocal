*-----------------------------------------------------------------------------
* <Rating>-38</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LATAM.CARD.ACS.DEF.ID
*-----------------------------------------------------------------------------
!** ID ROUTINE for validate the ID of the CARD.ACS.DEF
* @author aslambarook@temenos.com
* @stereotype id
* @package infra.eb
* @uses E
*!
*-----------------------------------------------------------------------------
* Revision History :
*   -Date-          -Who-               - CD_REFERENCE - author
* 21/05/2008      MOHAMMED ASLAM.B        Description of modification. Why, what and who
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------
*** </region>

*** <region name= INSERTS>
*** <desc>Inserts</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.PRODUCT.PARAMETER
$INSERT I_F.ACCT.GEN.CONDITION
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------
*** </region>
*-----------------------------------------------------------------------------
*** <region name= MAIN PROCESS LOGIC>
*** <desc>Main process logic</desc>
  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
*** <desc>INITIALISE</desc>
INITIALISE:

  CARD.TYPE.ID = ''
  ACS.DEF.ID = ''

  RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= OPEN.FILES>
*** <desc>Open files</desc>
OPEN.FILES:

  FN.CTYPE = 'F.CARD.TYPE'
  F.CTYPE = ''
  CALL OPF(FN.CTYPE,F.CTYPE)

  FN.AAPRO = 'F.AA.PRODUCT'
  F.AAPRO = ''
  CALL OPF(FN.AAPRO,F.AAPRO)

  FN.AZPRO = 'F.AZ.PRODUCT.PARAMETER'
  F.AZPRO = ''
  CALL OPF(FN.AZPRO,F.AZPRO)

  FN.ACGEN = 'F.ACCT.GEN.CONDITION'
  F.ACGEN = ''
  CALL OPF(FN.ACGEN,F.ACGEN)
  RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
*** <desc>Process</desc>

PROCESS:
  IF ID.NEW EQ '' THEN
    RETURN
  END

  CARD.TYPE.ID = FIELD(ID.NEW,"-",1)
  ACS.DEF.ID = FIELD(ID.NEW,"-",3)
  CARD.ACS.DEF.IND = FIELD(ID.NEW,"-",2)
  ACS.DEF.DC = DCOUNT(ID.NEW,"-")
  R.CTYPE = ''
  ERR.CTYPE = ''
  CALL F.READ(FN.CTYPE,CARD.TYPE.ID,R.CTYPE,F.CTYPE,ERR.CTYPE)

  IF R.CTYPE NE "" THEN

    R.AAPRO = ''
    ERR.AAPRO = ''
    CALL F.READ(FN.AAPRO,ACS.DEF.ID,R.AAPRO,F.AAPRO,ERR.AAPRO)

    R.AZPRO = ''
    ERR.AZ.PRO = ''
    CALL F.READ(FN.AZPRO,ACS.DEF.ID,R.AZPRO,F.AZPRO,ERR.AZ.PRO)

    R.ACGEN = ''
    ERR.ACGEN = ''
    CALL F.READ(FN.ACGEN,ACS.DEF.ID,R.ACGEN,F.ACGEN,ERR.ACGEN)

    BEGIN CASE

    CASE CARD.ACS.DEF.IND EQ 'AC'
      IF NOT(R.ACGEN) THEN
        E = 'DC-CT.VALID.ID'
        CALL ERR
      END
    CASE CARD.ACS.DEF.IND EQ 'AZ'
      IF NOT(R.AZPRO) THEN
        E = 'DC-CT.VALID.ID'
        CALL ERR
      END
    CASE CARD.ACS.DEF.IND EQ 'AA'
      IF NOT(R.AAPRO) THEN
        E = 'DC-CT.VALID.ID'
        CALL ERR
      END
    CASE 1
      E = 'DC-CT.VALID.ID'
      CALL ERR
    END CASE

  END ELSE
    E = 'DC-CT.VALID.ID'
    CALL ERR
  END

  RETURN
*** </region>
*-----------------------------------------------------------------------------


END
