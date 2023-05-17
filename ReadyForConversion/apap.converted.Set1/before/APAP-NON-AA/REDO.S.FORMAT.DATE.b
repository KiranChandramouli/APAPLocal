*---------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-9</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FORMAT.DATE
*---------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*DESCRIPTIONS:
*-------------
* This is Hook routine attached to EFFECTIVE.DATE field in RAD.CONDUIT.MAPPING table
* This routine formats date as YYMMDD

*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*

* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*

*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                    Reference             Description
* 12-OCT-2010    KAVITHA(TEMENOS)        ODR-2009-12-0290      INITIAL VERSION

*---------------------------------------------------------------

  GET.DATE = COMI
  COMI = GET.DATE[3,2]:GET.DATE[5,4]

  RETURN
*------------------------------------------------------------------
END
