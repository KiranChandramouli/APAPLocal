SUBROUTINE REDO.V.INP.RAISE.OVERRIDE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: GANESH H
* PROGRAM NAME: REDO.V.INP.RAISE.OVERRIDE
* ODR NO      : ODR-2009-12-0285
*-------------------------------------------------------------------------
*
*   DESCRIPTION: This routine is an input routine attached to  TELLER and
*                FUNDS.TRANSFER versions. Generates OVERRIDE message when
*                COMMISSION or TAX is waived
*
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE           WHO               REFERENCE         DESCRIPTION

* 19.02.2010     GANESH H          ODR-2009-12-0285  INITIAL CREATION
* 11.02.2011     KAVITHA           HD1104937         OVERRIDE CHANGES
* 18.04.2011     Bharath G         PACS00032271      Updated Routine Attached in this pack.
* 18.12.2011     JOAQUIN COSTA C.  PACS00163682      COMM/TAX REDESIGN
*
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
*
    GOSUB LOCAL.REF
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------
*
    LOC.REF.APPLICATION = APPLICATION
    LOC.REF.FIELDS      = "L.TT.WV.TAX":@VM:"L.TT.WV.COMM"
    LREF.POS            = ''
    WLOCAL.REF          = ''
    PROCESS.GOAHEAD     = ''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LREF.POS)
    POS.WAIVE.TAX    = LREF.POS<1,1>
    POS.WAIVE.CHARGE = LREF.POS<1,2>
*
    IF APPLICATION EQ "TELLER" THEN
        WLOCAL.REF      = TT.TE.LOCAL.REF
        WAPP.OVERRIDE   = TT.TE.OVERRIDE
        PROCESS.GOAHEAD = 1
    END ELSE
        IF APPLICATION EQ "FUNDS.TRANSFER" THEN
            WLOCAL.REF      = FT.LOCAL.REF
            WAPP.OVERRIDE   = FT.OVERRIDE
            PROCESS.GOAHEAD = 1
        END
    END
*
RETURN
*
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
    Y.WAIVE.CHARGE = R.NEW(WLOCAL.REF)<1,POS.WAIVE.CHARGE>
    Y.WAIVE.TAX    = R.NEW(WLOCAL.REF)<1,POS.WAIVE.TAX>
*
    CHANGE @SM TO @FM IN Y.WAIVE.CHARGE
    CHANGE @SM TO @FM IN Y.WAIVE.TAX
*
*HD1104937 - S
    LOCATE 'YES' IN Y.WAIVE.CHARGE<1> SETTING CHG.POS THEN

        CURR.NO = DCOUNT(R.NEW(WAPP.OVERRIDE),@VM) + 1
        TEXT = 'REDO.WAIVE.CHARGE'
        CALL STORE.OVERRIDE(CURR.NO)
    END

    LOCATE 'YES' IN Y.WAIVE.TAX<1> SETTING TAX.POS THEN

        CURR.NO = DCOUNT(R.NEW(WAPP.OVERRIDE),@VM) + 1
        TEXT = 'REDO.WAIVE.TAX'
        CALL STORE.OVERRIDE(CURR.NO)

    END
*HD1104937-E
RETURN
*
*---------------------------------------------------------------------------------------------------
END
