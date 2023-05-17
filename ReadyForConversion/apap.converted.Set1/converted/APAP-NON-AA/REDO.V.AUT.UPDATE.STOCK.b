SUBROUTINE REDO.V.AUT.UPDATE.STOCK
*----------------------------------------------------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: VIGNESH KUMAAR MR
*----------------------------------------------------------------------------------------------------------------------
* DESCRIPTION: This routine is used to update the TT.STOCK.CONTROL table, during the TILL close if there is any change
* in the DENOM UNITS when compared with the TT.STOCK.CONTROL DENOM UNITS then the user entered information needs to be
* updated in the stock control table.
*----------------------------------------------------------------------------------------------------------------------
* Input / Output:
*----------------*
* IN  : NA
* OUT : NA
*
* Dependencies:
*--------------*
* CALLS     :
* CALLED BY : Auth Rtn in a VERSION record "TELLER.ID,REDO.CLOSE.TELLER"
*
* CHANGE REQUEST / DEVELOPMENT REF:
*----------------------------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------------------------
* DATE          WHO                  REFERENCE        DESCRIPTION
* 05/06/2013    VIGNESH KUMAAR MR    PACS00273071     Update TT.STOCK.CONTROL denom units during TILL close
* 15/07/2013    Vignesh Kumaar MR    PACS00306797     Remove EB-REDO.DENOM.MISMATCH Error
* 17/07/2014    Vignesh Kumaar MR    PACS00389135     TILL CLOSE OVERAGE/SHORTAGE DEALSLIP
* 16/05/2015    Vignesh Kumaar MR    PACS00458175     Till closure no possible - denomination
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TELLER.DENOMINATION
    $INSERT I_F.TT.STOCK.CONTROL
    $INSERT I_GTS.COMMON
    $INSERT I_F.COMPANY

    GOSUB INITIALISE
    GOSUB PROCESS

    IF OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB OVER.SHORT.DEALSLIP
    END

RETURN
*----------------------------------------------------------------------------------------------------------------------
INITIALISE:
*----------*

    GET.TOTAL = ''
    Y.OVER.FLAG = ''
    SET.FLAG = ''

    FN.TT.STOCK.CONTROL = 'F.TT.STOCK.CONTROL'
    F.TT.STOCK.CONTROL  = ''
    CALL OPF(FN.TT.STOCK.CONTROL,F.TT.STOCK.CONTROL)

    FN.TELLER.DENOMINATION = 'F.TELLER.DENOMINATION'
    F.TELLER.DENOMINATION = ''
    CALL OPF(FN.TELLER.DENOMINATION,F.TELLER.DENOMINATION)

RETURN
*----------------------------------------------------------------------------------------------------------------------
PROCESS:
*-------*

    GET.CCY = R.NEW(TT.TID.CURRENCY)
    GET.CATEG = R.NEW(TT.TID.CATEGORY)
    GET.TID.DENOM = R.NEW(TT.TID.DENOMINATION)
    GET.TID.UNITS = R.NEW(TT.TID.UNIT)
    Y.TID.CNT = 1

    LOOP
        REMOVE Y.CCY FROM GET.CCY SETTING CCY.POS
    WHILE Y.CCY:CCY.POS

        Y.DENOM = GET.TID.DENOM<1,Y.TID.CNT>
        Y.UNITS = GET.TID.UNITS<1,Y.TID.CNT>

* Fix for PACS00458175 [Till closure no possible - denomination]

        Y.STOCK.ID = Y.CCY:GET.CATEG<1,Y.TID.CNT>:ID.NEW:R.COMPANY(EB.COM.SUB.DIVISION.CODE)

* End of Fix

        SET.FLAG = 1
        GOSUB CALC.DENOM.UNITS
        GET.TID.TOT = GET.TOTAL

        CALL F.READ(FN.TT.STOCK.CONTROL,Y.STOCK.ID,R.TT.STOCK.CONTROL,F.TT.STOCK.CONTROL,TT.STOCK.CONTROL.ERR)
        Y.DENOM = R.TT.STOCK.CONTROL<TT.SC.DENOMINATION>
        Y.UNITS = R.TT.STOCK.CONTROL<TT.SC.QUANTITY>
        GOSUB CALC.DENOM.UNITS
        GET.STOCK.TOT = GET.TOTAL

        Y.DENOM.UPD = GET.TID.DENOM<1,Y.TID.CNT>
        Y.QUAN.UPD = GET.TID.UNITS<1,Y.TID.CNT>

        GET.TT.DENOM.UPD = CHANGE(Y.DENOM.UPD,@SM,@VM)
        GET.TT.QUAN.UPD = CHANGE(Y.QUAN.UPD,@SM,@VM)

        IF R.TT.STOCK.CONTROL THEN
            R.TT.STOCK.CONTROL = ''
            R.TT.STOCK.CONTROL<TT.SC.DENOMINATION> = GET.TT.DENOM.UPD
            R.TT.STOCK.CONTROL<TT.SC.QUANTITY> = GET.TT.QUAN.UPD

*      WRITE R.TT.STOCK.CONTROL TO F.TT.STOCK.CONTROL, Y.STOCK.ID      ;*Tus Start
            CALL F.WRITE(FN.TT.STOCK.CONTROL,Y.STOCK.ID,R.TT.STOCK.CONTROL)  ;*Tus End
        END

        Y.TID.CNT += 1
    REPEAT
RETURN
*----------------------------------------------------------------------------------------------------------------------
CALC.DENOM.UNITS:
*----------------*

    GET.TOTAL = ''
    Y.DENOM.CNT = 1
    LOOP
        REMOVE Y.DENOM.ID FROM Y.DENOM SETTING DENOM.POS
    WHILE Y.DENOM.ID:DENOM.POS
        IF SET.FLAG THEN
            GET.UNITS = Y.UNITS<1,1,Y.DENOM.CNT>
        END ELSE
            GET.UNITS = Y.UNITS<1,Y.DENOM.CNT>
        END
        IF GET.UNITS NE '' OR GET.UNITS NE 0 THEN
            CALL CACHE.READ(FN.TELLER.DENOMINATION, Y.DENOM.ID, R.TELLER.DENOMINATION, DENOM.ERR)
            GET.DENOM.VALUE = R.TELLER.DENOMINATION<TT.DEN.VALUE>
            GET.TOTAL += GET.DENOM.VALUE * GET.UNITS
        END
        Y.DENOM.CNT += 1
    REPEAT
    GET.DENOM.VALUE = ''
    GET.UNITS = ''
    Y.DENOM.CNT = ''
    Y.DENOM = ''
    Y.UNITS = ''
    SET.FLAG = ''

RETURN
*----------------------------------------------------------------------------------------------------------------------
OVER.SHORT.DEALSLIP:
*------------------*

* Fix for PACS00389135 [TILL CLOSE OVERAGE/SHORTAGE DEALSLIP]

    Y.OVER1 = OFS$OVERRIDES<1>
    Y.OVER2 = OFS$OVERRIDES<2>

    LOCATE 'NO' IN Y.OVER2<1,1> SETTING OFS.POS THEN
        RETURN
    END

    Y.STORED.OVERRIDES = R.NEW(TT.TID.OVERRIDE)
    FINDSTR 'TT.ID.OVER' IN Y.STORED.OVERRIDES SETTING POS.FM.TT,POS.VM.TT THEN
        OFS$DEAL.SLIP.PRINTING = 1
        CALL PRODUCE.DEAL.SLIP('REDO.TT.CLOTILL')
    END ELSE
        FINDSTR 'TT.ID.SHORT' IN Y.STORED.OVERRIDES SETTING POS.FM.TT,POS.VM.TT THEN
            OFS$DEAL.SLIP.PRINTING = 1
            CALL PRODUCE.DEAL.SLIP('REDO.TT.CLOTILL')
        END
    END

RETURN

* End of Fix
*----------------------------------------------------------------------------------------------------------------------
END
