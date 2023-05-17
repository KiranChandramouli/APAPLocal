*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BUILD.REGOFF(ENQ.DATA)

*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.BUILD.REGOFF
*--------------------------------------------------------------------------------------------------------
*Description  : This is BUILD.ROUTINE to check the agency is valid for the user accessing the data
*Linked With  : REDO.RENEWAL.CARD.REGOFF
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 28 Sep 2011    Balagurunathan         PACS00131231          Initial Creation
*--------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.USER


  GOSUB MAIN.PROCESS


  RETURN

INITIALISE:

  AGENCY=''
  COMP.LIST=''
  RETURN


***************
MAIN.PROCESS:
***************

  FLDS.LIST=ENQ.DATA<2,1>

  LOCATE "AGENCY" IN FLDS.LIST<1,1> SETTING POS.FLDS THEN
    AGENCY=ENQ.DATA<4,POS.FLDS>

  END
  COMP.LIST=R.USER<EB.USE.COMPANY.CODE>

  IF AGENCY EQ '' THEN
    CHANGE FM TO ' ' IN COMP.LIST
    ENQ.DATA<4,POS.FLDS>=COMP.LIST
    RETURN

  END


  LOCATE AGENCY IN COMP.LIST<1,1> SETTING POS.COMP THEN
    ENQ.DATA<4,POS.FLDS>= AGENCY

  END ELSE
    ENQ.ERROR='EB-CANNOT.ACCESS.COMPANY'
  END

  LOCATE "ALL" IN COMP.LIST<1,1> SETTING POS.COMP THEN
    ENQ.DATA<4,POS.FLDS>=''
    ENQ.ERROR=''
  END

  RETURN


END
