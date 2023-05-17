*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE APAP.B.CREATE.LN.SERVICE.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : APAP.B.CREATE.LN.SERVICE
*-----------------------------------------------------------------------------
* Description:
*------------
*
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_APAP.B.CREATE.LN.SERVICE.COMMON

    GOSUB INIT
    RETURN

INIT:
    FN.APAP.LN.OFS.CONCAT = 'F.APAP.LN.OFS.CONCAT'
    F.APAP.LN.OFS.CONCAT = ''
    CALL OPF(FN.APAP.LN.OFS.CONCAT,F.APAP.LN.OFS.CONCAT)

    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    RETURN
*----------------------------------------------------------------
END
