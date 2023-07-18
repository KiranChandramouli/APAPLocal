*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.SCHEDULE.PROJ.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : L.APAP.SCHEDULE.PROJ
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO               DESCRIPTION
*  20200530         ELMENDEZ              INITIAL CREATION
*-----------------------------------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE LAPAP.BP I_L.APAP.SCHEDULE.PROJ.COMMON
    $INCLUDE T24.BP I_F.AA.ARRANGEMENT
    $INCLUDE BP I_F.EB.L.APAP.SCHEDULE.PROJET
*-----------------------------------------------------------------------------
*SEL.CMD = 'SELECT ' : FN.AA.ARRANGEMENT : " WITH PRODUCT.LINE EQ LENDING AND ARR.STATUS NE 'CLOSE' AND ARR.STATUS NE 'AUTH' AND ARR.STATUS NE 'PENDING.CLOSURE' AND ARR.STATUS NE 'UNAUTH'"
    SEL.CMD = 'SELECT ' : FN.AA.ARRANGEMENT : " WITH ARR.STATUS EQ 'CURRENT' 'EXPIRED'"
    CALL OCOMO("SEL.CMD>":SEL.CMD)

    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
*CALL BATCH.BUILD.LIST(SEL.COMMAND,SEL.LIST )

    RETURN
END
