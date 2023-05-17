*-----------------------------------------------------------------------------
* <Rating>-9</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FORMAT.TIME
*----------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER

*DESCRIPTIONS:
*-------------
* This is Hook routine attached to TIME field in RAD.CONDUIT.MAPPING table
* This routine format time

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


*-----------------------------------------------------------------------------

  FETCH.TIME = COMI[1,2]
  FETCH.MIN = COMI[4,2]
  COMI = FETCH.TIME:FETCH.MIN

  RETURN
*----------------------------------------------------------------------------
END
