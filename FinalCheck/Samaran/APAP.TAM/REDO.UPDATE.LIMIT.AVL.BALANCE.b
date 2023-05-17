$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.UPDATE.LIMIT.AVL.BALANCE
*-----------------------------------------------------------
*Description: This routine is to update the Limit available balance
*             when the limit's internal amount is modified.
*             It is attached to version - LIMIT,REDO.MANTENIMIENTO & LIMIT,REDO.INGRESO.
*-----------------------------------------------------------
*  Modification History :
*    26/01/2017  - PACS00574750
*                      Updating MAXIMUM.TOTAL field if INTERNAL.AMOUNT is changed.
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LIMIT

    GOSUB GET.LOC.REF
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------
GET.LOC.REF:
*-----------------------------------------------------------

    LOC.REF.APPLICATION   = "LIMIT"
    LOC.REF.FIELDS        = 'L.AVL.BALANCE'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AVL.BALANCE     = LOC.REF.POS<1,1>

RETURN
*-----------------------------------------------------------
PROCESS:
*-----------------------------------------------------------
    Y.OLD.INTERNAL.AMT = R.OLD(LI.INTERNAL.AMOUNT)
    Y.NEW.INTERNAL.AMT = R.NEW(LI.INTERNAL.AMOUNT)
    Y.OLD.AVL.BALANCE  = R.OLD(LI.LOCAL.REF)<1,POS.L.AVL.BALANCE>
    Y.MAXIMUM.TOTAL.AMOUNT = R.NEW(LI.MAXIMUM.TOTAL)

    IF Y.OLD.AVL.BALANCE EQ '' THEN     ;* I.e During the Limit creation.
        R.NEW(LI.LOCAL.REF)<1,POS.L.AVL.BALANCE>  = Y.NEW.INTERNAL.AMT
    END ELSE
        Y.NEW.AVL.BALANCE = Y.OLD.AVL.BALANCE+(Y.NEW.INTERNAL.AMT-Y.OLD.INTERNAL.AMT)
        R.NEW(LI.LOCAL.REF)<1,POS.L.AVL.BALANCE> = Y.NEW.AVL.BALANCE
        IF Y.NEW.AVL.BALANCE LT 0 THEN
            AF = LI.LOCAL.REF
            AV = POS.L.AVL.BALANCE
            ETEXT = 'EB-REDO.LIMIT.INSUFF.AVLBAL':@FM:FMT(Y.NEW.AVL.BALANCE,'L2,#15') ;*R22 AUTO CONVERSION
            CALL STORE.END.ERROR
        END
    END

    IF Y.NEW.INTERNAL.AMT NE Y.MAXIMUM.TOTAL.AMOUNT THEN
        R.NEW(LI.MAXIMUM.TOTAL) = Y.NEW.INTERNAL.AMT
    END

RETURN
END
