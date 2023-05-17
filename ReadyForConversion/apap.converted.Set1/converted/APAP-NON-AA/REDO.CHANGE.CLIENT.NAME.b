SUBROUTINE REDO.CHANGE.CLIENT.NAME
*----------------------------------------------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : VIGNESH KUMAAR M R
* Program Name : REDO.CHANGE.CLIENT.NAME
* ODR NUMBER : ODR-2009-10-0321
*----------------------------------------------------------------------------------------------------------------------
* Description : ID Routine to get the enrichment for the CUSTOMER & ID.NUMBER
* In parameter : None
* out parameter : None
*----------------------------------------------------------------------------------------------------------------------
* Modification history:
*---------------------*
* Date who Reference Description
* 15-JUL-2013 VIGNESH KUMAAR M R PACS00294931 FOR OTHER BANK CUSTOMER ID.NUMBER TO BE DISPLAYED IN CUSTOMER FIELD
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON

    $INSERT I_F.TELLER
    $INSERT I_F.REDO.NCF.ISSUED

    GET.TT.ID = FIELD(COMI,'.',3)

    FN.REDO.NCF.ISSUED = 'F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED = ''
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)

    CALL F.READ(FN.REDO.NCF.ISSUED,COMI,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,REDO.NCF.ISSUED.ERR)

    IF R.REDO.NCF.ISSUED<ST.IS.ID.NUMBER> NE '' AND GET.TT.ID[1,2] EQ 'TT' THEN

        FN.TELLER = 'F.TELLER'
        F.TELLER = ''
        CALL OPF(FN.TELLER,F.TELLER)

        CALL F.READ(FN.TELLER,GET.TT.ID,R.TELLER,F.TELLER,TELLER.ERR)
        CALL GET.LOC.REF('TELLER','L.TT.CLIENT.NME',GET.CUSTOMER.NAME)


        GET.CUST.NAME = R.TELLER<TT.TE.LOCAL.REF,GET.CUSTOMER.NAME>
        IF GET.CUST.NAME NE '' THEN
            OFS$ENRI<ST.IS.ID.NUMBER> = GET.CUST.NAME
            OFS$ENRI<ST.IS.CUSTOMER> = GET.CUST.NAME
        END
    END

RETURN
