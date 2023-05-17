SUBROUTINE REDO.S.CALC.FT.AMT
    $INSERT I_COMMON
    $INSERT I_EQUATE

*DESCRIPTIONS:
*-------------
* This is Hook routine attached to TOTAL.CREDIT field in RAD.CONDUIT.MAPPING table
* This routine calculates the total credit amount

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


    ASSIGN.AMT = COMI
    TOT.LENGTH = LEN(ASSIGN.AMT)
    CREDIT.AMOUNT = COMI[4,TOT.LENGTH]
*    CREDIT.AMOUNT = CREDIT.AMOUNT * 100
    COMI = CREDIT.AMOUNT

RETURN
END
