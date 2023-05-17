*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.CORRECTION.DIRECT.DEBIT.SELECT


    $INCLUDE I_COMMON
    $INCLUDE I_EQUATE
    $INCLUDE TAM.BP I_REDO.CORRECTION.DIRECT.DEBIT.COMMON



    SEL.CMD = "SELECT FBNK.AA.ARRANGEMENT WITH PRODUCT.LINE EQ 'LENDING'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    CALL BATCH.BUILD.LIST('', SEL.LIST)



    RETURN

END
