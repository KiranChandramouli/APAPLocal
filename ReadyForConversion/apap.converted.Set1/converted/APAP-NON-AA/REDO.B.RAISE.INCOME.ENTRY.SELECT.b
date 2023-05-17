SUBROUTINE REDO.B.RAISE.INCOME.ENTRY.SELECT
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.RAISE.INCOME.ENTRY.SELECT
*-----------------------------------------------------------------
* Description : This multi threaded routine is used to raise the entries whenever income has happened.
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      21-Nov-2011          Initial draft
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.RAISE.INCOME.ENTRY.COMMON


    SEL.CMD = 'SELECT ':FN.REDO.WORK.INT.CAP.AMT.RP
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
