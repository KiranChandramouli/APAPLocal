*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CH.GENUSRVALD
**
* Subroutine Type : VERSION
* Attached to     : EB.EXTERNAL.USER,REDO.PERS.NEWINT,
*                   EB.EXTERNAL.USER,REDO.PERS.NEWTEL,
*                   EB.EXTERNAL.USER,REDO.CORP.NEWINTADM,
*                   EB.EXTERNAL.USER,REDO.CORP.NEWINTAUTH,
*                   EB.EXTERNAL.USER,REDO.CORP.NEWINTINP
* Attached as     : CHECK.REC.RTN
* Primary Purpose : Assign one year as valid period for Channel User to be
*                   activated
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 1/11/10 - First Version
*           ODR Reference: ODR-2010-06-0155
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*           Roberto Mondragon - TAM Latin America
*           rmondragon@temenos.com
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.EB.EXTERNAL.USER

  STAT = R.NEW(EB.XU.STATUS)

  IF STAT EQ "ACTIVE" THEN
    INITIALDATE = TODAY
    ENDDATE1 = LEFT(INITIALDATE,4)
    ENDDATE2 = RIGHT(INITIALDATE,4)
    ENDDATE1 = ENDDATE1 + 1
    ENDDATE = ENDDATE1 : ENDDATE2
    R.NEW(EB.XU.END.DATE) = ENDDATE
  END

  RETURN

END
